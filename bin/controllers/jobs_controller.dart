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
      final bool hasQuery = request.url.hasQuery;
      if (hasQuery) {
        final queryParams = _validateQueryParams(request.url.queryParameters);
        if (queryParams == null) {
          return Response.badRequest();
        }
        var result = await _service.findJobSimple(queryParam: queryParams);
        return Response.ok(jsonEncode(result));
      }
      var result = await _service.findJobSimple();
      return Response.ok(jsonEncode(result));
    });

    router.get('/jobs/<id>', (Request request, String id) async {
      if (id.isEmpty) {
        return Response.badRequest();
      }
      RegExp uuidRegex = RegExp(
          '^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-1[0-9a-fA-F]{3}-[89abAB][0-9a-fA-F]{3}-[0-9a-fA-F]{12}\$');

      if (uuidRegex.hasMatch(id)) {
        var result = await _service.findOne(id);
        return result != null
            ? Response.ok(jsonEncode(result))
            : Response.notFound('Vaga não encontrada na base de dados.');
      }
      return Response.badRequest();
    });

    router.delete('/jobs', (Request request) async {
      final String? id = request.url.queryParameters['id'];
      if (id == null) {
        return Response(400);
      }
      var result = await _service.delete(id);
      return result ? Response(200) : Response.internalServerError();
    });

    router.put('/jobs', (Request request) async {
      final String body = await request.readAsString();
      var result = await _service.save(JobModel.fromJson(jsonDecode(body)));
      return result ? Response(500) : Response(500);
    });

    router.post('/jobs', (Request request) async {
      var body = await request.readAsString();
      JobModel jobmodel = JobModel.fromJson(jsonDecode(body));
      var result = await _service.save(jobmodel);
      return result ? Response(201) : Response(404);
    });

    return router;
  }

  Map<String, String>? _validateQueryParams(Map<String, String> queryParams) {
    Map<String, String> result = {};
    switch (queryParams.keys.first) {
      case 'id':
        return queryParams;
      case 'cidade':
        result.addAll({'city': queryParams['cidade']!});
        return result;
      case 'modalidade':
        result.addAll({'modality': queryParams['modalidade']!});
        return result;
      case 'titulo':
        result.addAll({'title': queryParams['titulo']!});
        return result;
      default:
        return null;
    }
  }
}
