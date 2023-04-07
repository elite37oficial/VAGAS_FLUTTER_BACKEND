import 'controllers/companies_security_controller.dart';
import 'controllers/jobs_controller.dart';
import 'controllers/jobs_report_controller.dart';
import 'controllers/jobs_security_controller.dart';
import 'controllers/login_controller.dart';
import 'controllers/ping_controller.dart';
import 'controllers/users_controller.dart';
import 'controllers/users_security_controller.dart';
import 'core/dependency_injector/injects.dart';
import 'core/middlewares/middleware_interception.dart';
import 'core/custom_server.dart';
import 'package:shelf/shelf.dart';
import 'package:dotenv/dotenv.dart';

import 'core/security/security_service.dart';

void main() async {
  var env = DotEnv(includePlatformEnvironment: true)..load();

  final di = Injects.initialize();
  final cascade = Cascade()
      .add(di.get<LoginController>().getHandler())
      .add(di.get<PingController>().handler)
      .add(di.get<JobsController>().getHandler())
      .add(di.get<UsersController>().getHandler())
      .add(di.get<UsersSecurityController>().getHandler())
      .add(di.get<JobsSecurityController>().getHandler())
      .add(di.get<CompaniesSecurityController>().getHandler())
      .add(di.get<JobsReportController>().getHandler())
      .handler;

  final SecurityService securityService = di.get<SecurityService>();

  final pipeline = Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(MiddlewareInterception().appJson)
      .addMiddleware(securityService.authorization)
      .addMiddleware(securityService.verifyJwt)
      .addHandler(cascade);

  await CustomServer().initilize(
    handler: pipeline,
    address: env['address'] ?? 'localhost',
    port: int.parse(env['port'].toString()),
  );
}
