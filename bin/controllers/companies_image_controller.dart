import 'dart:io';
import 'package:dotenv/dotenv.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'controller.dart';

class CompaniesImageController extends Controller {
  @override
  Handler getHandler({
    List<Middleware>? middlewares,
    bool isSecurity = false,
    bool isJsonMimeType = true,
  }) {
    final Router router = Router();
    var env = DotEnv(includePlatformEnvironment: true)..load();

    // middlewares ??= [];
    // middlewares
    //     .remove(DependencyInjector().get<MiddlewareInterception>().appJson);

    router.get('/companies/image/<image_file>',
        (Request request, String imageFile) async {
      final String basePath = env['baseImagePath'] ?? '';
      // r'C:\Users\Luan Fonseca\Desktop\Elite\VAGAS_FLUTTER_BACKEND\bin\uploads\';

      // Monta o caminho completo do arquivo a ser servido.
      var filePath = basePath + request.url.pathSegments.last;

      try {
        // Lê o arquivo e retorna seu conteúdo como uma resposta.
        var file = File(filePath);
        var fileContents = await file.readAsBytes();
        return Response.ok(fileContents, headers: {
          HttpHeaders.contentTypeHeader: getContentType(filePath),
        });
      } on FileSystemException {
        return Response.notFound('Arquivo não encontrado.');
      }
    });

    return createHandler(
      router: router,
      middlewares: middlewares,
      isSecurity: isSecurity,
      isJsonMimeType: isJsonMimeType,
    );
  }
}

// Obtém o tipo MIME do arquivo com base na extensão.
String getContentType(String filePath) {
  switch (filePath.split('.').last) {
    case 'png':
      return 'image/png';
    case 'jpg':
    case 'jpeg':
      return 'image/jpeg';
    default:
      return 'application/octet-stream';
  }
}
