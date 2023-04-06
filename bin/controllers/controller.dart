import 'package:shelf/shelf.dart';

import '../core/dependency_injector/dependency_injector.dart';
import '../core/middlewares/middleware_interception.dart';
import '../core/security/security_service.dart';

abstract class Controller {
  Handler getHandler(
      {List<Middleware>? middlewares,
      bool isSecurity = false,
      bool isJsonMimeType = true});

  Handler createHandler({
    required Handler router,
    List<Middleware>? middlewares,
    bool isSecurity = false,
    bool isJsonMimeType = true,
  }) {
    middlewares ??= [];

    if (isSecurity) {
      final SecurityService securityService =
          DependencyInjector().get<SecurityService>();
      bool isOnList = middlewares.contains(securityService.validateJWT);
      if (!isOnList) {
        middlewares.addAll([
          securityService.authorization,
          securityService.verifyJwt,
        ]);
      }
    }

    if (isJsonMimeType) {
      MiddlewareInterception middlewareInterception =
          DependencyInjector().get<MiddlewareInterception>();
      middlewares.add(middlewareInterception.appJson);
    }

    Pipeline pipe = Pipeline();

    for (var middleware in middlewares) {
      pipe = pipe.addMiddleware(middleware);
    }

    return pipe.addHandler(router);
  }
}
