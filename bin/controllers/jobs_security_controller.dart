import 'dart:convert';

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../models/job_model.dart';
import '../services/jobs_service.dart';
import '../to/status_to.dart';
import 'controller.dart';

class JobsSecurityController extends Controller {
  final JobsService _jobsService;
  JobsSecurityController(this._jobsService);

  @override
  Handler getHandler({List<Middleware>? middlewares, bool isSecurity = false}) {
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

      final bool result = await _jobsService.save(jobModel);
      return result ? Response(201) : Response(500);
    });

    router.put('/jobs-status', (Request request) async {
      final String body = await request.readAsString();
      final StatusTO statusTO = StatusTO.fromRequest(body);
      JobModel jobModel = JobModel();
      jobModel.status = statusTO.status;
      jobModel.id = statusTO.id;

      if (jobModel.id == null || jobModel.status == null) {
        return Response.badRequest();
      }

      switch (jobModel.status) {
        case 0:
        case 1:
          break;
        default:
          return Response.badRequest();
      }

      //validar se usuario possui autorização para pausar a vaga

      bool result = await _jobsService.updateStatus(jobModel);

      return result ? Response(201) : Response(500);
    });

    router.post('/jobs', (Request request) async {
      var body = await request.readAsString();
      JobModel jobmodel = JobModel.fromJson(jsonDecode(body));
      JWT jwt = request.context['jwt'] as JWT;
      final String userIdFromJWT = jwt.payload['userID'];
      jobmodel.createdBy = userIdFromJWT;
      var result = await _jobsService.save(jobmodel);
      return result ? Response(201) : Response(404);
    });
    return createHandler(
        router: router, isSecurity: isSecurity, middlewares: middlewares);
  }

  Future<bool> _validateAuth(JobModel job, Request request) async {
    final String createdBy = job.createdBy!;
    JWT jwt = request.context['jwt'] as JWT;
    final String userIdFromJWT = jwt.payload['userID'];

    if (userIdFromJWT != createdBy) {
      return false;
    }
    return true;
  }
}
