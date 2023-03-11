import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../models/job_model.dart';
import '../services/generic_service.dart';

class JobsController {
  final GenericService<JobModel> _service;

  JobsController(this._service);
  Handler get handler {
    var router = Router();

    router.get('/jobs', (Request request) async {
      List<JobModel> jobsList = await _service.findAll();
      List<Map> jobsMap = jobsList.map((job) => job.toJson()).toList();
      return Response.ok(jsonEncode(jobsMap));
    });

    router.post('/jobs', (Request request) async {
      var body = await request.readAsString();
      _service.save(JobModel.fromJson(jsonDecode(body)));
      return Response(201);
    });

    return router;
  }
}
