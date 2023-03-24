import 'dart:convert';

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../core/dependency_injector/dependency_injector.dart';
import '../core/security/security_service.dart';
import 'controller.dart';

class LoginController extends Controller {
  @override
  Handler getHandler({List<Middleware>? middlewares, bool isSecurity = false}) {
    var router = Router();

    DependencyInjector di = DependencyInjector();
    SecurityService securityServiceImp = di.get<SecurityService>();

    router.post('/login', (Request request) async {
      // final body = await request.readAsString();
      //lógica para validar email e senha com o banco
      final String token = await securityServiceImp.generateJWT('userID');
      final JWT? validateToken = await securityServiceImp.validateJWT(token);
      return Response.ok(jsonEncode({
        'token': token,
        'isValid': validateToken != null,
        'roles': validateToken?.payload['roles']
      }));
    });

    return createHandler(
      router: router,
      isSecurity: isSecurity,
      middlewares: middlewares,
    );
  }
}
