import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../models/jobs_report_model.dart';
import '../services/jobs_report_service.dart';
import 'controller.dart';

class JobsReportController extends Controller {
  final JobsReportService _jobsReportService;

  JobsReportController(this._jobsReportService);

  @override
  Handler getHandler({
    List<Middleware>? middlewares,
    bool isSecurity = false,
    bool isJsonMimeType = true,
  }) {
    final Router router = Router();

    router.post('/jobs-report', (Request request) async {
      final String body = await request.readAsString();
      final Map map = jsonDecode(body);

      RegExp uuidRegex = RegExp(
          '^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-1[0-9a-fA-F]{3}-[89abAB][0-9a-fA-F]{3}-[0-9a-fA-F]{12}\$');
      final bool isValidUuid = uuidRegex.hasMatch(map['jobId']);

      if (map['jobId'] == null || !isValidUuid || map['description'] == null) {
        return Response.badRequest(
            body: jsonEncode({
          'message': 'Os parâmetros ID - válido e Descrição são obrigatórios'
        }));
      }

      final JobsReportModel jobsReportModel = JobsReportModel.fromRequest(map);
      final result = await _jobsReportService.create(jobsReportModel);
      return result ? Response(201) : Response.internalServerError();
    });

    return createHandler(
      router: router,
      isSecurity: isSecurity,
      middlewares: middlewares,
      isJsonMimeType: isJsonMimeType,
    );
  }
}
