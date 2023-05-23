import 'dart:convert';

import 'package:dotenv/dotenv.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:shelf/shelf.dart';

import 'package:shelf_router/shelf_router.dart';

import '../core/security/security_service.dart';
import '../models/reset_password_model.dart';
import '../models/user_model.dart';
import '../services/reset_passwords_service.dart';
import '../services/users_service.dart';
import 'controller.dart';

class ResetPasswordsController extends Controller {
  final UsersService _usersService;
  final ResetPasswordsService _resetPasswordsService;
  final SecurityService _securityServiceImp;

  ResetPasswordsController(this._usersService, this._resetPasswordsService,
      this._securityServiceImp);

  @override
  Handler getHandler(
      {List<Middleware>? middlewares,
      bool isSecurity = false,
      bool isJsonMimeType = true}) {
    var router = Router();
    router.post('/reset-password-email', (Request request) async {
      final body = await request.readAsString();
      final Map bodyJson = jsonDecode(body);

      final UserModel? user =
          await _usersService.findByEmail(bodyJson["email"]);
      if (user != null) {
        ResetPasswordModel resetPasswordModel = ResetPasswordModel();
        resetPasswordModel.userId = user.id;
        var result = await _resetPasswordsService.save(resetPasswordModel);
        if (result != null) {
          final bool resultEmail = await envioDeEmail(user, result);
          if (resultEmail) {
            return Response.ok(
                jsonEncode({'msg': "Password reset email sent."}));
          } else {
            return Response.badRequest();
          }
        }
      } else {
        return Response.badRequest();
      }
    });

    router.post('/reset-password', (Request request) async {
      final body = await request.readAsString();
      ResetPasswordModel resetPasswordModel =
          ResetPasswordModel.fromJson(jsonDecode(body));

      if (resetPasswordModel.password ==
          resetPasswordModel.passwordConfirmation) {
        final String? returnValidade =
            await validadeResetPassword(resetPasswordModel);
        if (returnValidade.toString().length == 36) {
          resetPasswordModel.userId = returnValidade;
          var result =
              await _resetPasswordsService.updatePassword(resetPasswordModel);
          if (result != null) {
            final token = await gerarToken(resetPasswordModel.userId!);
            return Response.ok(jsonEncode({'token': token}));
          } else {
            return Response.badRequest(
                body: jsonEncode({'msg': "Senha igual a antiga"}));
          }
        } else {
          return Response.badRequest(body: jsonEncode({'msg': returnValidade}));
        }
      } else {
        return Response.badRequest(
            body: jsonEncode(
                {'msg': "Senha e Confirmação de senha não são iguais"}));
      }
    });

    return createHandler(
        router: router,
        isSecurity: isSecurity,
        middlewares: middlewares,
        isJsonMimeType: isJsonMimeType);
  }

  Future<bool> envioDeEmail(UserModel user, String token) async {
    var env = DotEnv(includePlatformEnvironment: true)..load();

    final smtpServer = SmtpServer(
      env['smtp_server']!,
      port: int.parse(env['smtp_port'].toString()),
      username: env['smtp_user'],
      password: env['smtp_pass'],
      ssl: true,
    );

    final message = Message()
      ..from = Address(env['smtp_user']!, 'Elite37')
      ..recipients.add(user.email)
      ..subject = 'Vagas Elite37 | Redefinição de senha'
      ..html =
          "<p>Olá, ${user.name}</p>\n<p>Recebemos uma solicitação para restaurar sua senha de acesso em nosso site.</p><p>Se você reconhece essa ação, clique no botão abaixo para prosseguir:</p><p><a href='appvagas.elite37.com.br/auth/resetPassword?token=$token'>Redefinir Senha</a></p><p>Atenciosamente,</p><p>Elite37</p>";

    bool statusCode;
    try {
      final sendReport = await send(message, smtpServer);
      print(sendReport.toString());
      statusCode = true;
    } on MailerException catch (e) {
      print('Messagem não envida: $e');
      statusCode = false;
    }

    return statusCode;
  }

  Future<String?> validadeResetPassword(
      ResetPasswordModel resetPasswordModel) async {
    final resultBD =
        await _resetPasswordsService.findOne(resetPasswordModel.token!);
    if (resultBD != null) {
      final DateTime dateValidate =
          DateTime.parse(resultBD.date.toString()).add(Duration(minutes: 30));
      if (resetPasswordModel.date!.isBefore(dateValidate)) {
        return resultBD.userId;
      } else {
        return "Token expirado";
      }
    } else {
      return "Não existe esse token";
    }
  }

  Future<String?> gerarToken(String id) async {
    final UserModel? user = await _usersService.findOne(id);
    final String? profileId = user?.profileId;
    final String token = await _securityServiceImp.generateJWT(id, profileId!);
    return token;
  }
}
