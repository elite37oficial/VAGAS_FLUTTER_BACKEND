import 'dart:convert';

import 'package:dotenv/dotenv.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:shelf/shelf.dart';

import 'package:shelf_router/shelf_router.dart';

import '../models/reset_password_model.dart';
import '../models/user_model.dart';
import '../services/reset_passwords_service.dart';
import '../services/users_service.dart';
import 'controller.dart';

class ResetPasswordsController extends Controller {
  final UsersService _usersService;
  final ResetPasswordsService _resetPasswordsService;

  ResetPasswordsController(this._usersService, this._resetPasswordsService);

  @override
  Handler getHandler(
      {List<Middleware>? middlewares,
      bool isSecurity = false,
      isJsonMimeType = true}) {
    var router = Router();
    router.post('/redefinir-senha-email', (Request request) async {
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
            return Response.ok("Password reset email sent.");
          } else {
            return Response.badRequest();
          }
        }
      } else {
        return Response.badRequest();
      }
    });

    return createHandler(
      router: router,
      isSecurity: isSecurity,
      middlewares: middlewares,
      isJsonMimeType: isJsonMimeType,
    );
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
          "<p>Olá, ${user.name}</p>\n<p>Recebemos uma solicitação para restaurar sua senha de acesso em nosso site.</p><p>Se você reconhece essa ação, clique no botão abaixo para prosseguir:</p><p><a href='appvagas.elite37.com.br/resetsenha?token=$token'>Redefinir Senha</a></p><p>Atenciosamente,</p><p>Elite37</p>";

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
}
