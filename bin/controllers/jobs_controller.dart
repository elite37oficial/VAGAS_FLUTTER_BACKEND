import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

class JobsController {
  Handler get handler {
    var router = Router();

    router.get('/jobs', (Request request) async {
      return Response.ok(
        "Lista de vagas",
        headers: {'content-type': 'application/json'},
      );
    });

    return router;
  }
}
