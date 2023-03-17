import 'controllers/jobs_controller.dart';
import 'controllers/login_controller.dart';
import 'controllers/ping_controller.dart';
import 'core/middlewares/middleware_interception.dart';
import 'core/custom_server.dart';
import 'package:shelf/shelf.dart';
import 'package:dotenv/dotenv.dart';

import 'dao/jobs_dao.dart';
import 'database/mysql_db_configuration.dart';
import 'services/jobs_service.dart';

void main() async {
  var env = DotEnv(includePlatformEnvironment: true)..load();

  final cascade = Cascade()
      .add(LoginController().handler)
      .add(PingController().handler)
      .add(JobsController(
        JobsService(),
        JobDAO(
          MySqlDbConfiguration(),
        ),
      ).handler)
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
