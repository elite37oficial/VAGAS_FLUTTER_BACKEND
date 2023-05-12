import 'package:shelf_swagger_ui/shelf_swagger_ui.dart';

import 'controllers/cafe_controller.dart';
import 'controllers/companies_images_controller.dart';
import 'controllers/companies_security_controller.dart';
import 'controllers/jobs_controller.dart';
import 'controllers/jobs_report_controller.dart';
import 'controllers/jobs_security_controller.dart';
import 'controllers/login_controller.dart';
import 'controllers/ping_controller.dart';
import 'controllers/reset_passwords_controller.dart';
import 'controllers/users_controller.dart';
import 'controllers/users_security_controller.dart';
import 'core/dependency_injector/injects.dart';

import 'core/custom_server.dart';
import 'package:shelf/shelf.dart';
import 'package:dotenv/dotenv.dart';

import 'core/middlewares/middleware_interception.dart';
import 'core/security/security_service.dart';

void main() async {
  var env = DotEnv(includePlatformEnvironment: true)..load();

  final path = './specs/swagger.yaml';
  final swaggerHandler =
      SwaggerUI(path, title: 'Documentação Projeto Vagas API', deepLink: true);

  final di = Injects.initialize();
  final cascade = Cascade()
      .add(di.get<LoginController>().getHandler())
      .add(di.get<PingController>().handler)
      .add(di.get<CafeController>().handler)
      .add(di.get<JobsController>().getHandler())
      .add(di.get<UsersController>().getHandler())
      .add(di.get<ResetPasswordsController>().getHandler())
      .add(di.get<UsersSecurityController>().getHandler())
      .add(di.get<JobsSecurityController>().getHandler())
      .add(di.get<CompaniesSecurityController>().getHandler())
      .add(di.get<JobsReportController>().getHandler())
      .add(di.get<CompaniesImageController>().getHandler(isJsonMimeType: false))
      .add(swaggerHandler)
      .handler;

  final SecurityService securityService = di.get<SecurityService>();

  final pipeline = Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(securityService.authorization)
      .addMiddleware(securityService.verifyJwt)
      .addMiddleware(di.get<MiddlewareInterception>().cors)
      .addHandler(cascade);

  await CustomServer().initilize(
    handler: pipeline,
    address: env['address'] ?? 'localhost',
    port: int.parse(env['port'].toString()),
  );
}
