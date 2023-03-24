import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../models/job_model.dart';
import '../services/generic_service.dart';
import 'controller.dart';

class JobsController extends Controller {
  final GenericService<JobModel> _service;

  JobsController(this._service);

  @override
  Handler getHandler({List<Middleware>? middlewares, bool isSecurity = false}) {
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

    router.get('/jobs/id/<id>', (Request request, String id) async {
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

    return createHandler(
      router: router,
      isSecurity: isSecurity,
      middlewares: middlewares,
    );
  }

  Map<String, String>? _validateQueryParams(Map<String, String> queryParams) {
    Map<String, String> result = {};
    switch (queryParams.keys.first) {
      case 'id':
        return queryParams;
      case 'city':
        result.addAll({'city': queryParams['city']!});
        return result;
      case 'modality':
        result.addAll({'modality': queryParams['modality']!});
        return result;
      case 'title':
        result.addAll({'title': queryParams['title']!});
        return result;
      default:
        return null;
    }
  }
}
