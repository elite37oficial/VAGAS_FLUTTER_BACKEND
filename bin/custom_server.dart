import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;

class CustomServer {
  Future<void> initilize(
      {required Handler handler,
      required String address,
      required int port}) async {
    await shelf_io.serve(handler, address, port);

    print('servidor inicializado => http://$address:$port');
  }
}
