import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

class PingController {
  Handler get handler {
    var router = Router();

    router.get('/ping', (Request request) async {
      final now = DateTime.now();
      return Response.ok(now.toString());
    });

    return router;
  }
}
