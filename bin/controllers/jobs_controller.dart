import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../dao/dao.dart';
import '../models/job_model.dart';
import '../services/generic_service.dart';

class JobsController {
  final GenericService<JobModel> _service;
  final DAO _dao;

  JobsController(this._service, this._dao);
  Handler get handler {
    var router = Router();

    router.get('/jobs', (Request request) async {
      var result = await _dao.findAll();
      return Response.ok(jsonEncode(result));
    });

    router.delete('/jobs', (Request request) async {
      final String? id = request.url.queryParameters['id'];
      if (id == null) {
        return Response(400);
      }
      var result = await _dao.delete(id);
      return result ? Response(200) : Response.internalServerError();
    });

    router.put('/jobs', (Request request) async {
      final String body = await request.readAsString();
      var result = await _dao.update(JobModel.fromJson(jsonDecode(body)));
      return result ? Response(500) : Response(500);
    });

    router.post('/jobs', (Request request) async {
      var body = await request.readAsString();
      JobModel jobmodel = JobModel.fromJson(jsonDecode(body));
      var result = await _dao.create(jobmodel);
      return result ? Response(201) : Response(404);
      //   var result = await _mySqlDbConfiguration.execQuery(
      //     // 'INSERT into companies (id,name,location,createdDate,createdBy) value (?,?,?,?,?)',
      //     // ['UUID()', 'Ifood', 'SP', 'NOW()', 'UUID()']);
      //     // "INSERT INTO companies (id, NAME, location, createdBy, createdDate) VALUES(UUID(), 'Ifood', 'Ruak', 'raquelvalgas', NOW())",
      //   // );
      //   // _service.save(JobModel.fromJson(jsonDecode(body)));
      //   return Response(201);
      // );
    });

    return router;
  }
}
