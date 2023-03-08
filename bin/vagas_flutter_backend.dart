import 'controllers/jobs/jobs_controller.dart';
import 'controllers/login_controller.dart';
import 'custom_server.dart';
import 'package:shelf/shelf.dart';
import 'package:dotenv/dotenv.dart';

void main() async {
  var env = DotEnv(includePlatformEnvironment: true)..load();

  final cascade = Cascade()
      .add(LoginController().handler)
      .add(JobsController().handler)
      .handler;

  final pipeline = Pipeline().addMiddleware(logRequests()).addHandler(cascade);

  await CustomServer().initilize(
    handler: pipeline,
    address: env['address'] ?? 'localhost',
    port: int.parse(env['port'].toString()),
  );
}
