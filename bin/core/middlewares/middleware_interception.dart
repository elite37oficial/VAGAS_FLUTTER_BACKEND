import 'package:shelf/shelf.dart';

class MiddlewareInterception {
  Middleware get appJson => createMiddleware(
        responseHandler: (Response response) => response.change(
          headers: {'content-type': 'application/json'},
        ),
      );
}
