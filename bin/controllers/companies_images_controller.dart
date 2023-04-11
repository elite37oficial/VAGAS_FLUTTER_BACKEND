import 'dart:convert';
import 'dart:io';
import 'package:dotenv/dotenv.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../core/dependency_injector/dependency_injector.dart';
import 'controller.dart';

class CompaniesImageController extends Controller {
  @override
  Handler getHandler({
    List<Middleware>? middlewares,
    bool isSecurity = false,
    bool isJsonMimeType = true,
  }) {
    final Router router = Router();
    final env = DependencyInjector().get<DotEnv>();
    final imagePath = env['baseImagePath'];
    final Directory directory = Directory(imagePath!);

    router.post('/companies-image', (Request request) async {
      final String body = await request.readAsString();
      final Map map = jsonDecode(body);

      final String image64FromDB = map['image64'];

      final list = image64FromDB.split(';base64,');
      final String contentType = list[0].substring(5);
      final String extension = contentType.split('/')[1];

      final String imageCode = list[1];

      final List<int> bytes = base64.decode(imageCode);

      if (!directory.existsSync()) {
        directory.createSync();
      }

      try {
        final file = File('${directory.path}/${map['companyId']}.$extension');
        if (!file.existsSync()) {
          file.writeAsBytesSync(bytes);
          return Response(201);
        }
        return Response.notFound('arquivo já existe!');
      } catch (e) {
        print(e.toString());
        return Response.internalServerError();
      }
    });

    router.get('/companies-image/id/<companyID>',
        (Request request, String? companyID) async {
      if (companyID == null) {
        return Response.badRequest();
      }
      RegExp uuidRegex = RegExp(
          '^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-1[0-9a-fA-F]{3}-[89abAB][0-9a-fA-F]{3}-[0-9a-fA-F]{12}\$');
      final bool isValid = uuidRegex.hasMatch(companyID);

      if (!isValid) {
        return Response.badRequest();
      }

      // Directory diretorioAtual = Directory('uploads');
      List<FileSystemEntity> listaArquivos = directory.listSync();

      List<File> arquivosFiltrados = listaArquivos
          .where((arquivo) {
            return arquivo is File && arquivo.path.contains(companyID);
          })
          .map((arquivo) => arquivo as File)
          .toList();

      if (arquivosFiltrados.isNotEmpty) {
        final fileContents = await arquivosFiltrados.first.readAsBytes();
        final String extension = arquivosFiltrados.first.path.split('.')[1];
        return Response.ok(fileContents,
            headers: {'content-type': 'image/$extension'});
      } else {
        //REVER metodo de retorno
        return Response.badRequest();
      }
    });

    return createHandler(
      router: router,
      isSecurity: isSecurity,
      middlewares: middlewares,
      isJsonMimeType: isJsonMimeType,
    );
  }
}
