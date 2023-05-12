import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

class CafeController {
  Handler get handler {
    var router = Router();

    router.get('/cafe', (Request request) async {
      return Response(418, body: 'I am a teapot');
    });

    return router;
  }
}
