import 'package:shelf_router/shelf_router.dart';

import 'controllers/login_controller.dart';
import 'custom_server.dart';
import 'package:shelf/shelf.dart';
import 'package:dotenv/dotenv.dart';

void main() async {
  var env = DotEnv(includePlatformEnvironment: true)..load();

  final router = Router();

  router.get('/jobs', (Request request) async {
    return Response.ok('Lista de vagas');
  });

  final cascade = Cascade().add(LoginController().handler).add(router).handler;

  final pipeline = Pipeline().addMiddleware(logRequests()).addHandler(cascade);

  await CustomServer().initilize(
    handler: pipeline,
    address: env['address'] ?? 'localhost',
    port: int.parse(env['port'].toString()),
  );
}
