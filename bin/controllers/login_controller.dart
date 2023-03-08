import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

class LoginController {
  Handler get handler {
    var router = Router();

    router.post('/login', (Request request) async {
      final body = await request.readAsString();
      return Response.ok(body, headers: {'content-type': 'application/json'});
    });

    return router;
  }
}
