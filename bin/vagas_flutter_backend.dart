import 'controllers/jobs_controller.dart';
import 'controllers/login_controller.dart';
import 'controllers/ping_controller.dart';
import 'core/dependency_injector/injects.dart';
import 'core/middlewares/middleware_interception.dart';
import 'core/custom_server.dart';
import 'package:shelf/shelf.dart';
import 'package:dotenv/dotenv.dart';

void main() async {
  var env = DotEnv(includePlatformEnvironment: true)..load();

  final _di = Injects.initialize();

  final cascade = Cascade()
      .add(_di.get<LoginController>().handler)
      .add(_di.get<PingController>().handler)
      .add(_di.get<JobsController>().handler)
      .handler;

  final pipeline = Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(MiddlewareInterception().appJson)
      .addHandler(cascade);

  await CustomServer().initilize(
    handler: pipeline,
    address: env['address'] ?? 'localhost',
    port: int.parse(env['port'].toString()),
  );
}
