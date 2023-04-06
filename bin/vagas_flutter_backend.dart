import 'controllers/companies_image_controller.dart';
import 'controllers/companies_security_controller.dart';
import 'controllers/companies_security_image_controller.dart';
import 'controllers/jobs_controller.dart';
import 'controllers/jobs_security_controller.dart';
import 'controllers/login_controller.dart';
import 'controllers/ping_controller.dart';
import 'controllers/users_controller.dart';
import 'controllers/users_security_controller.dart';
import 'core/dependency_injector/injects.dart';
import 'core/custom_server.dart';
import 'package:shelf/shelf.dart';
import 'package:dotenv/dotenv.dart';

void main() async {
  var env = DotEnv(includePlatformEnvironment: true)..load();

  final di = Injects.initialize();

  final cascade = Cascade()
      .add(di.get<LoginController>().getHandler())
      .add(di.get<PingController>().handler)
      .add(di.get<JobsController>().getHandler())
      .add(di.get<UsersController>().getHandler())
      .add(di.get<CompaniesImageController>().getHandler(isJsonMimeType: false))
      .add(di.get<UsersSecurityController>().getHandler(isSecurity: true))
      .add(di.get<JobsSecurityController>().getHandler(isSecurity: true))
      .add(di
          .get<CompaniesSecurityImageController>()
          .getHandler(isSecurity: true, isJsonMimeType: false))
      .add(di.get<CompaniesSecurityController>().getHandler(isSecurity: true))
      .handler;

  final pipeline = Pipeline()
      .addMiddleware(logRequests())
      // .addMiddleware(MiddlewareInterception().appJson)
      .addHandler(cascade);

  await CustomServer().initilize(
    handler: pipeline,
    address: env['address'] ?? 'localhost',
    port: int.parse(env['port'].toString()),
  );
}
