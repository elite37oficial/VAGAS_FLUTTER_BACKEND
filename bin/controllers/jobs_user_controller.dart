import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../models/job_model.dart';
import '../services/jobs_service.dart';
import 'controller.dart';

class JobsUserController extends Controller {
  final JobsService _jobsService;
  JobsUserController(this._jobsService);

  @override
  Handler getHandler({List<Middleware>? middlewares, bool isSecurity = false}) {
    Router router = Router();

    router.delete('/jobs', (Request request) async {
      final String? id = request.url.queryParameters['id'];
      if (id == null) {
        return Response(400);
      }
      var result = await _jobsService.delete(id);
      return result ? Response(200) : Response.internalServerError();
    });

    router.put('/jobs', (Request request) async {
      final String body = await request.readAsString();
      final JobModel jobModel = JobModel.fromJson(jsonDecode(body));
      var result = await _jobsService.save(jobModel);
      return result ? Response(201) : Response(500);
    });

    router.post('/jobs', (Request request) async {
      var body = await request.readAsString();
      JobModel jobmodel = JobModel.fromJson(jsonDecode(body));
      var result = await _jobsService.save(jobmodel);
      return result ? Response(201) : Response(404);
    });
    return createHandler(
        router: router, isSecurity: isSecurity, middlewares: middlewares);
  }
}
