import 'package:shelf/shelf.dart';

import '../core/dependency_injector/dependency_injector.dart';
import '../core/middlewares/middleware_interception.dart';

abstract class Controller {
  Handler getHandler({
    List<Middleware>? middlewares,
    bool isSecurity = false,
    bool isJsonMimeType = true,
  });

  Handler createHandler({
    required Handler router,
    List<Middleware>? middlewares,
    bool isSecurity = false,
    bool isJsonMimeType = true,
  }) {
    middlewares ??= [];

    // if (isSecurity) {
    //   SecurityService securityService =
    //       DependencyInjector().get<SecurityService>();
    //   middlewares
    //       .addAll([securityService.authorization, securityService.verifyJwt]);
    // }
    if (isJsonMimeType) {
      MiddlewareInterception middlewareInterception =
          DependencyInjector().get<MiddlewareInterception>();
      middlewares.addAll([middlewareInterception.appJson]);
    }

    Pipeline pipe = Pipeline();

    for (var middleware in middlewares) {
      pipe = pipe.addMiddleware(middleware);
    }

    return pipe.addHandler(router);
  }
}
