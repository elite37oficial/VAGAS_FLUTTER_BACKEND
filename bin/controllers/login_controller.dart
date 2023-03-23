import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../core/dependency_injector/dependency_injector.dart';
import '../core/security/security_service.dart';

class LoginController {
  Handler get handler {
    var router = Router();

    DependencyInjector di = DependencyInjector();
    SecurityService securityServiceImp = di.get<SecurityService>();

    router.post('/login', (Request request) async {
      // final body = await request.readAsString();
      //lógica para validar email e senha com o banco
      final String token = await securityServiceImp.generateJWT('userID');
      return Response.ok(token);
    });

    return router;
  }
}
