import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

class PingController {
  Handler get handler {
    var router = Router();

    router.get('/ping', (Request request) async {
      final body = await request.readAsString();
      return Response.ok('OK');
    });

    return router;
  }
}
