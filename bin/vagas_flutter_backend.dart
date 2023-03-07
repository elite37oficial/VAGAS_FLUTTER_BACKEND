import 'package:shelf_router/shelf_router.dart';

import 'custom_server.dart';
import 'package:shelf/shelf.dart';
import 'package:dotenv/dotenv.dart';

void main() async {
  var env = DotEnv(includePlatformEnvironment: true)..load();

  final router = Router();
  router.post('/login', (Request request) async {
    final body = await request.readAsString();
    return Response.ok(body, headers: {'content-type': 'application/json'});
  });

  router.get('/jobs', (Request request) async {
    return Response.ok('Lista de vagas');
  });

  final pipeline = Pipeline().addMiddleware(logRequests()).addHandler(router);

  await CustomServer().initilize(
    handler: pipeline,
    address: env['address'] ?? 'localhost',
    port: int.parse(env['port'].toString()),
  );
}
