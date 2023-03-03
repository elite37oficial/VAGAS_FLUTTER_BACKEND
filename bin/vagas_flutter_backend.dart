import 'custom_server.dart';
import 'package:shelf/shelf.dart';
import 'package:dotenv/dotenv.dart';

void main() async {
  var env = DotEnv(includePlatformEnvironment: true)..load();

  await CustomServer().initilize(
    handler: (request) => Response.ok('hello world'),
    address: env['address'] ?? 'localhost',
    port: int.parse(env['port'].toString()),
  );
}
