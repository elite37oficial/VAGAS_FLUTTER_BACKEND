import 'dart:convert';

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../services/users_service.dart';
import 'controller.dart';

class UsersSecurityController extends Controller {
  final UsersService _usersService;
  UsersSecurityController(this._usersService);

  @override
  Handler getHandler({List<Middleware>? middlewares, bool isSecurity = false}) {
    Router router = Router();

    router.get('/users', (Request request) async {
      final bool isValid = await _validateAuth(request);
      if (isValid) {
        var result = await _usersService.findAll();
        return Response.ok(jsonEncode(result));
      } else {
        return Response.unauthorized('Not Authorized.');
      }
    });

    router.get('/users/id/<id>', (Request request, String id) async {
      if (id.isEmpty) {
        return Response.badRequest();
      }
      RegExp uuidRegex = RegExp(
          '^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-1[0-9a-fA-F]{3}-[89abAB][0-9a-fA-F]{3}-[0-9a-fA-F]{12}\$');

      if (uuidRegex.hasMatch(id)) {
        final bool isValid = await _validateAuth(request);
        if (isValid) {
          var result = await _usersService.findOne(id);
          return result != null
              ? Response.ok(jsonEncode(result))
              : Response.notFound('Vaga não encontrada na base de dados.');
        } else {
          return Response.unauthorized('Not Authorized.');
        }
      }
      return Response.badRequest();
    });

    return createHandler(
        router: router, isSecurity: isSecurity, middlewares: middlewares);
  }

  Future<bool> _validateAuth(Request request) async {
    JWT jwt = request.context['jwt'] as JWT;
    final String userIdFromJWT = jwt.payload['userID'];
    var result = await _usersService.findOne(userIdFromJWT);
    var idUser = result?.id;
    if (userIdFromJWT != idUser) {
      return false;
    }
    return true;
  }
}
