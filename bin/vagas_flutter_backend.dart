import 'custom_server.dart';
import 'package:shelf/shelf.dart';

void main() async {
  await CustomServer().initilize(
    handler: (request) => Response.ok('hello world'),
    address: 'localhost',
    port: 8080,
  );
}
