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
