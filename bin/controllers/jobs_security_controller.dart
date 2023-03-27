import 'dart:convert';

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../models/job_model.dart';
import '../services/jobs_service.dart';
import 'controller.dart';

class JobsSecurityController extends Controller {
  final JobsService _jobsService;
  JobsSecurityController(this._jobsService);

  @override
  Handler getHandler({List<Middleware>? middlewares, bool isSecurity = false}) {
    Router router = Router();

    router.delete('/jobs/id/<id>', (Request request, String id) async {
      if (id.isEmpty) {
        return Response(400);
      }

      JobModel? job = await _jobsService.findOne(id);

      if (job == null) {
        return Response(400);
      }
      final bool isValid = await _validateAuth(job, request);

      if (!isValid) {
        return Response.forbidden('Not Authorized.');
      }

      // final String createdBy = job.createdBy!;
      // JWT jwt = request.context['jwt'] as JWT;
      // final String userIdFromJWT = jwt.payload['userID'];
      // if (userIdFromJWT != createdBy) {
      //   return Response.forbidden('Not Authorized.');
      // }

      var result = await _jobsService.delete(id);
      return result ? Response(200) : Response.internalServerError();
    });

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

      var result = await _jobsService.save(jobModel);
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
