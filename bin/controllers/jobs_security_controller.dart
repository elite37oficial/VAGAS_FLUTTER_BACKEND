import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../models/job_model.dart';
import '../services/jobs_service.dart';
import '../to/status_to.dart';
import '../utils/list_extension.dart';
import 'controller.dart';

class JobsSecurityController extends Controller {
  final JobsService _jobsService;
  JobsSecurityController(this._jobsService);

  @override
  Handler getHandler({
    List<Middleware>? middlewares,
    bool isSecurity = false,
    bool isJsonMimeType = true,
  }) {
    Router router = Router();

    router.put('/jobs', (Request request) async {
      final String body = await request.readAsString();
      final JobModel jobModel = JobModel.fromJson(jsonDecode(body));

      if (jobModel.id == null) {
        return Response.badRequest();
      }

      JobModel? job = await _jobsService.findOne(jobModel.id!);

      if (job == null) {
        return Response(400);
      }

      final bool isValid = await validateAuth(job.createdBy, request);

      if (!isValid) {
        return Response.forbidden('Not Authorized.');
      }
      final userID = getUserIdFromJWT(request);
      jobModel.changedBy = userID;

      final String result = await _jobsService.save(jobModel);
      return result.isNotEmpty ? Response(201) : Response(500);
    });

    router.put('/jobs-status', (Request request) async {
      final String body = await request.readAsString();
      final StatusTO statusTO = StatusTO.fromRequest(body);

      if (statusTO.resourceId == null || statusTO.status == null) {
        return Response.badRequest(
          body: 'O id da vaga e o status são obrigatórios',
        );
      }
      JobModel jobModel = JobModel();
      // jobModel.status = statusTO.status;
      jobModel.id = statusTO.resourceId;

      final List<StatusTO> statusListFromDb = await _jobsService.getStatus();
      // final List<String?> listOfStatus = statusListFromDb
      //     .map((statusTo) => statusTo.status?.toLowerCase())
      //     .toList();

      final List<int?> listOfStatus =
          statusListFromDb.map((statusTo) => statusTo.id).toList();

      if (!listOfStatus.contains(statusTO.status)) {
        return Response.badRequest(body: 'O status informado não é válido.');
      }

      jobModel.status = statusListFromDb
          .firstWhereOrNull((element) => element.id == statusTO.status)
          ?.id;

      final JobModel? jobFromDB = await _jobsService.findOne(jobModel.id!);

      if (jobFromDB == null) {
        return Response.notFound(
          'O id infomado não corresponde a uma vaga na base de dados.',
        );
      }

      jobModel.createdBy = jobFromDB.createdBy;

      final bool valid = await validateAuth(jobModel.createdBy, request);

      if (!valid) {
        return Response.forbidden(
          'Você não tem permissão para modificar este recurso.',
        );
      }

      final userID = getUserIdFromJWT(request);
      jobModel.changedBy = userID;

      bool result = await _jobsService.updateStatus(jobModel);

      return result
          ? Response(201, body: 'Status atualizado com sucesso!')
          : Response(500);
    });

    router.post('/jobs', (Request request) async {
      var body = await request.readAsString();
      JobModel jobmodel = JobModel.fromJson(jsonDecode(body));
      final String userIdFromJWT = getUserIdFromJWT(request);
      jobmodel.createdBy = userIdFromJWT;
      jobmodel.status = 1;
      var result = await _jobsService.save(jobmodel);
      return result.isNotEmpty
          ? Response(201, body: jsonEncode({'id': result}))
          : Response(404);
    });
    return createHandler(
      router: router,
      isSecurity: isSecurity,
      middlewares: middlewares,
      isJsonMimeType: isJsonMimeType,
    );
  }
}
