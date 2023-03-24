import 'package:shelf/shelf.dart';

import '../core/dependency_injector/dependency_injector.dart';
import '../core/security/security_service.dart';

abstract class Controller {
  Handler getHandler({List<Middleware>? middlewares, bool isSecurity = false});

  Handler createHandler(
      {required Handler router,
      List<Middleware>? middlewares,
      bool isSecurity = false}) {
    middlewares ??= [];

    if (isSecurity) {
      SecurityService securityService =
          DependencyInjector().get<SecurityService>();
      middlewares
          .addAll([securityService.authorization, securityService.verifyJwt]);
    }

    Pipeline pipe = Pipeline();

    for (var middleware in middlewares) {
      pipe = pipe.addMiddleware(middleware);
    }

    return pipe.addHandler(router);
  }
}
