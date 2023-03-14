import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:uuid/uuid.dart';

import '../database/mysql_db_configuration.dart';
import '../models/job_model.dart';
import '../services/generic_service.dart';

class JobsController {
  final GenericService<JobModel> _service;
  final MySqlDbConfiguration _mySqlDbConfiguration = MySqlDbConfiguration();
  final uuid = Uuid();

  JobsController(this._service);
  Handler get handler {
    var router = Router();

    router.get('/jobs', (Request request) async {
      // List<JobModel> jobsList = await _service.findAll();
      // List<Map> jobsMap = jobsList.map((job) => job.toJson()).toList();
      // return Response.ok(jsonEncode(jobsMap));
      var result = await _mySqlDbConfiguration.execQuery('SELECT * from JOBS');
      return Response.ok(result);
    });

    router.post('/jobs', (Request request) async {
      var body = await request.readAsString();

      var result = await _mySqlDbConfiguration.execQuery(
        // 'INSERT into companies (id,name,location,createdDate,createdBy) value (?,?,?,?,?)',
        // ['UUID()', 'Ifood', 'SP', 'NOW()', 'UUID()']);
        "INSERT INTO companies (id, NAME, location, createdBy, createdDate) VALUES(UUID(), 'Ifood', 'Ruak', 'raquelvalgas', NOW())",
      );
      // _service.save(JobModel.fromJson(jsonDecode(body)));
      return Response(201);
    });

    return router;
  }
}
