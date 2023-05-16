import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
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

  Future<bool> validateAuth(String? createdBy, Request request) async {
    final String userIdFromJWT = getUserIdFromJWT(request);
    if (userIdFromJWT != createdBy) {
      return false;
    }
    return true;
  }

  String getUserIdFromJWT(Request request) {
    final JWT jwt = request.context['jwt'] as JWT;
    final userID = jwt.payload['userID'];
    return userID;
  }

  bool isAdminFromJWT(Request request) {
    final JWT jwt = request.context['jwt'] as JWT;
    final String profileId = jwt.payload['roles'];
    if (profileId.toLowerCase() == "admin") {
      return true;
    } else {
      return false;
    }
  }
}
