import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import '../core/security/security_service.dart';

class LoginController {
  final SecurityService securityService;
  LoginController(this.securityService);

  Handler get handler {
    var router = Router();

    router.post('/login', (Request request) async {
      // final body = await request.readAsString();
      //lógica para validar email e senha com o banco
      final String token = await securityService.generateJWT('userID');
      return Response.ok(token);
    });

    return router;
  }
}
