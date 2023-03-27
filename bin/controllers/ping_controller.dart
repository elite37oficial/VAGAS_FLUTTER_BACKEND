import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

class PingController {
  Handler get handler {
    var router = Router();

    router.get('/ping', (Request request) async {
      return Response.ok('OK 3');
    });

    return router;
  }
}
