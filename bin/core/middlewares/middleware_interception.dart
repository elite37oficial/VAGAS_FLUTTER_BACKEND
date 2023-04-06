import 'package:mime/mime.dart';
import 'package:shelf/shelf.dart';

import 'dart:convert';

class MiddlewareInterception {
  Middleware get appJson => createMiddleware(
        responseHandler: (Response response) => response.change(
          headers: {'content-type': 'application/json'},
        ),
      );

  Middleware get multipartMiddleware {
    return (Handler innerHandler) {
      return (Request request) async {
        if (request.method == 'POST' &&
            request.headers['Content-Type']
                    ?.startsWith('multipart/form-data') ==
                true) {
          final String contentType = request.headers['Content-Type']!;
          final List<String> stringList = contentType.split(';');
          final String boundary = stringList[1];
          // final int index = boundary.lastIndexOf('-');
          final String boundaryValue = boundary.substring(10);

          var transformer = MimeMultipartTransformer(boundaryValue);
          var bodyStream = request.read();
          var parts = await transformer.bind(bodyStream).toList();

          var fields = <String, dynamic>{};
          var files = <String, List<int>>{};

          for (var part in parts) {
            var contentDisposition = part.headers['content-disposition']!;
            var name = _parseContentDisposition(contentDisposition)['name'];
            var filename =
                _parseContentDisposition(contentDisposition)['filename'];

            if (filename != null) {
              files[name!] = (await part.toList()).cast<int>();
            } else {
              fields[name!] = await utf8.decodeStream(part);
            }
          }

          request = Request(request.method, request.requestedUri,
              headers: request.headers,
              context: {'fields': fields, 'files': files});
        }

        return innerHandler(request);
      };
    };
  }

  Map<String, String> _parseContentDisposition(String contentDisposition) {
    var params = contentDisposition.split(';').map((e) => e.trim());
    var name = params
        .firstWhere((e) => e.startsWith('name='))
        .split('=')[1]
        .replaceAll('"', '');
    var filename = params
        .firstWhere((e) => e.startsWith('filename='))
        .split('=')[1]
        .replaceAll('"', '');
    return {'name': name, 'filename': filename};
  }
}
