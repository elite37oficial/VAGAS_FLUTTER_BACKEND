import 'package:shelf/shelf.dart';

class MiddlewareInterception {
  Middleware get appJson => createMiddleware(
        responseHandler: (Response response) => response.change(
          headers: {'content-type': 'application/json'},
        ),
      );

  Middleware get cors {
    final headersPermitidos = {
      'Access-Control-Allow-Origin': '*',
      'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
      'Access-Control-Allow-Headers': '*'
    };

    Response? handlerOptions(Request request) {
      if (request.method == 'OPTIONS') {
        return Response(200, headers: headersPermitidos);
      } else {
        return null;
      }
    }

    Response addCorsHeader(Response response) =>
        response.change(headers: headersPermitidos);

    return createMiddleware(
        requestHandler: handlerOptions, responseHandler: addCorsHeader);
  }
}
