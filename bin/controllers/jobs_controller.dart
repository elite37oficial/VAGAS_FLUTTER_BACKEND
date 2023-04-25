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
  Handler getHandler(
      {List<Middleware>? middlewares,
      bool isSecurity = false,
      bool isJsonMimeType = true}) {
    var router = Router();

    router.get('/jobs', (Request request) async {
      final bool hasQuery = request.url.hasQuery;
      if (hasQuery) {
        final queryParams = _validateQueryParams(request.url.queryParameters);
        if (queryParams == null) {
          return Response.badRequest();
        }
        var result = await _service.findByQuery(queryParam: queryParams);
        return Response.ok(jsonEncode(result));
      }
      var result = await _service.findByQuery();
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
      isJsonMimeType: isJsonMimeType,
    );
  }

  String? _validateQueryParams(Map<String, String> queryParams) {
    String? where;
    int page = 1;
    String? pagination;
    queryParams.forEach((key, value) {
      switch (key) {
        case "city":
        case "page":
        case "status":
        case "limit":
        case "modality":
        case "regime":
        case "seniority":
        case "company_id":
        case "created_by":
        case "title":
        case "name":
        case "search":
          if (queryParams.keys.first != key &&
              (key != 'limit' && key != 'page')) {
            where = "${where ?? ''} and ";
          }
          if (key == 'search') {
            where =
                "where city like '%$value%' or modality like '%$value%' or regime like '%$value%' or seniority like '%$value%' or title like '%$value%' or t2.name like '%$value%'";
          } else {
            if (value.contains(',')) {
              late String newValues = '';
              var listOfValue = value.split(',');
              for (var value in listOfValue) {
                value = value.trim();
                if (value.trim() == listOfValue.last.trim()) {
                  newValues += "'%$value%')";
                  break;
                }
                newValues += "'%$value%' or t1.$key like ";
              }
              where = where == null
                  ? "where (t1.$key like $newValues"
                  : "$where (t1.$key like $newValues";
              break;
            }
            if (key == 'status') {
              int valueOfStatus = int.tryParse(value) ?? 1;
              value = valueOfStatus.toString();
            }
            if (key.contains('name')) {
              where = where == null
                  ? "where t2.$key like '%$value%'"
                  : "$where t2.$key like '%$value%'";
              break;
            }
            if (key == 'page') {
              page = int.tryParse(value) ?? 0;
              if (page < 0) page *= -1;
              break;
            } else if (key == 'limit') {
              int limit = int.tryParse(value) ?? 10;
              if (limit < 0) limit *= -1;
              value = limit.toString();
              pagination = "limit $value offset ${(page - 1) * 10}";
              break;
            }

            where = where == null
                ? "where t1.$key like '%$value%'"
                : "$where t1.$key like '%$value%'";
          }
          break;

        default:
          where = null;
          break;
      }
    });

    if (where!.trim().endsWith('and')) {
      int index = where!.lastIndexOf('and');
      where = where!.replaceRange(index, null, '');
    }

    return "$where ${pagination ?? ''}";
  }
}
