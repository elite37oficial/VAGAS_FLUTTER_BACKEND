import 'dart:io';
import 'package:mime/mime.dart';
import 'package:shelf/shelf.dart';

import 'package:shelf_router/shelf_router.dart';
import 'controller.dart';

class CompaniesSecurityImageController extends Controller {
  @override
  Handler getHandler({
    List<Middleware>? middlewares,
    bool isSecurity = false,
    bool isJsonMimeType = true,
  }) {
    final Router router = Router();

    // middlewares ??= [];
    // middlewares
    //     .remove(DependencyInjector().get<MiddlewareInterception>().appJson);

    router.post('/companies/image', (Request request) async {
      // Certifica se de que a solicitação contém um arquivo
      var contentDisposition = request.headers['content-disposition'];
      if (contentDisposition == null ||
          !contentDisposition.startsWith('attachment')) {
        return Response(HttpStatus.badRequest,
            body: 'Nenhum arquivo fornecido.');
      }

      // Extrai o nome do arquivo da string "content-disposition"
      var filename =
          contentDisposition.split('filename=')[1].replaceAll('"', '');

      // Cria um diretório para armazenar as imagens, se ele não existir
      var directory = Directory(
        r'C:\Users\Luan Fonseca\Desktop\Elite\VAGAS_FLUTTER_BACKEND\bin\uploads',
      );
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }

      // Abre um fluxo de saída para o arquivo no diretório de imagens
      var file = File('${directory.path}/$filename');
      var sink = file.openWrite();

      // Lê o corpo da solicitação como um arquivo multipart e grava no arquivo
      var boundary = _extractBoundary(request.headers['content-type']);
      var transformer = MimeMultipartTransformer(boundary).bind(request.read());

      await transformer.forEach((part) async {
        // part.headers.values.forEach(print);

        await part.pipe(sink).whenComplete(() => sink.close());
      });

      // Retorna a URL do arquivo
      var url = Uri.parse('http://localhost:8080/companies/image/$filename');
      return Response(HttpStatus.created,
          body: url.toString(), headers: {'Access-Control-Allow-Origin': '*'});
    });

    return createHandler(
      router: router,
      middlewares: middlewares,
      isSecurity: isSecurity,
      isJsonMimeType: isJsonMimeType,
    );
  }

  String _extractBoundary(String? contentType) {
    var match = RegExp('boundary=(.*)').firstMatch(contentType ?? '');
    if (match != null) {
      return match.group(1)!;
    }
    throw Exception('Não foi possível extrair o boundary do Content-Type.');
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
