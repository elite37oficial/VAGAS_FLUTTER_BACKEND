import 'dart:convert';

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
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

      final bool isValid = await _validateAuth(job, request);

      if (!isValid) {
        return Response.forbidden('Not Authorized.');
      }
      final userID = _getUserIdFromJWT(request);
      jobModel.changedBy = userID;

      final bool result = await _jobsService.save(jobModel);
      return result ? Response(201) : Response(500);
    });

    router.put('/jobs-status', (Request request) async {
      final String body = await request.readAsString();
      final StatusTO statusTO = StatusTO.fromRequest(body);

      if (statusTO.resourceId == null || statusTO.status == null) {
        return Response.badRequest();
      }
      JobModel jobModel = JobModel();
      // jobModel.status = statusTO.status;
      jobModel.id = statusTO.resourceId;

      final List<StatusTO> statusListFromDb = await _jobsService.getStatus();
      final List<String?> listOfStatus = statusListFromDb
          .map((statusTo) => statusTo.status?.toLowerCase())
          .toList();

      if (!listOfStatus.contains(statusTO.status?.toLowerCase())) {
        return Response.badRequest();
      }

      jobModel.status = statusListFromDb
          .firstWhereOrNull((element) =>
              element.status?.toLowerCase() == statusTO.status?.toLowerCase())
          ?.id;

      final JobModel? jobFromDB = await _jobsService.findOne(jobModel.id!);

      if (jobFromDB == null) {
        return Response.notFound('Not Found.');
      }

      jobModel.createdBy = jobFromDB.createdBy;

      final bool valid = await _validateAuth(jobModel, request);
      if (!valid) {
        return Response.forbidden('Not Authorized.');
      }
      final userID = _getUserIdFromJWT(request);
      jobModel.changedBy = userID;

      bool result = await _jobsService.updateStatus(jobModel);

      return result ? Response(201) : Response(500);
    });

    router.post('/jobs', (Request request) async {
      var body = await request.readAsString();
      JobModel jobmodel = JobModel.fromJson(jsonDecode(body));
      final String userIdFromJWT = _getUserIdFromJWT(request);
      jobmodel.createdBy = userIdFromJWT;
      jobmodel.status = 1;
      var result = await _jobsService.save(jobmodel);
      return result ? Response(201) : Response(404);
    });
    return createHandler(
      router: router,
      isSecurity: isSecurity,
      middlewares: middlewares,
      isJsonMimeType: isJsonMimeType,
    );
  }

  Future<bool> _validateAuth(JobModel job, Request request) async {
    final String createdBy = job.createdBy!;
    final String userIdFromJWT = _getUserIdFromJWT(request);

    if (userIdFromJWT != createdBy) {
      return false;
    }
    return true;
  }

  String _getUserIdFromJWT(Request request) {
    final JWT jwt = request.context['jwt'] as JWT;
    final userID = jwt.payload['userID'];
    return userID;
  }
}
