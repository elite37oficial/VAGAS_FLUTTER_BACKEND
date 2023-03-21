import 'package:uuid/uuid.dart';

import '../database/db_configuration.dart';
import '../models/job_details.dart';
import '../models/job_model.dart';
import '../models/job_simple.dart';
import 'dao.dart';

class JobDAO implements DAO<JobModel> {
  final DBConfiguration _dbConfiguration;
  final uuid = Uuid();

  JobDAO(this._dbConfiguration);

  @override
  Future<bool> create(JobModel value) async {
    var result = await _dbConfiguration.execQuery(
        'INSERT INTO jobs (id, companyId, title, description, salary, location,seniority, regime, link, whatsapp, email, createdBy, createdDate) values (?,?,?,?,?,?,?,?,?,?,?,?,?); ',
        [
          uuid.v1(),
          value.companyId,
          value.title,
          value.description,
          value.salary,
          value.modality,
          value.seniority,
          value.regime,
          value.link,
          value.whatsappNumber,
          value.email,
          value.createdBy,
          value.createdDate
        ]);
    return result.affectedRows > 0;
  }

  @override
  Future<bool> delete(String id) async {
    var result = await _dbConfiguration
        .execQuery('DELETE from jobs where id = ?;', [id]);
    return result.affectedRows > 0;
  }

  @override
  Future<List<JobModel>> findAll() async {
    var result = await _dbConfiguration.execQuery('SELECT * FROM jobs');
    return result
        .map((r) => JobModel.fromJson(r.fields))
        .toList()
        .cast<JobModel>();
  }

  @override
  Future<JobModel?> findOne(String id) async {
    // var result = await _dbConfiguration.execQuery(
    //     'SELECT id, companyId, title, description, salary, location, seniority,city,regime,link, whatsapp, email  from jobs where id = ?;',
    //     [id]);
    var result = await _dbConfiguration.execQuery(
        'SELECT t1.id, t1.title, t1.city, t1.regime, t1.modality, t1.description, t1.whatsapp, t1.salary, t1.email, t1.link, t2.description AS descriptionCompany, t2.photoUrl, t2.name as nameCompany FROM jobs AS t1 INNER JOIN companies AS t2 ON t2.id = t1.companyId where t1.id = ?;',
        [id]);

    return result.isEmpty ? null : JobDetails.fromJson(result.first.fields);
  }

  @override
  Future<bool> update(JobModel value) async {
    final DateTime today = DateTime.now().toUtc();
    var result = await _dbConfiguration.execQuery(
        'UPDATE jobs set companyId = ?, title = ?, description = ?, salary = ?, local = ?,seniority = ?, regime = ?, link = ?, whatsappNumber = ?, email = ?, createdBy = ?, createdDate = ?, changedBy = ?, changedDate = ?, where id = ?; ',
        [
          value.companyId,
          value.title,
          value.description,
          value.salary,
          value.modality,
          value.regime,
          value.link,
          value.whatsappNumber,
          value.email,
          value.createdBy,
          value.createdDate,
          value.changedBy,
          today
        ]);

    return result.affectedRows > 0;
  }

  @override
  Future<List<JobModel?>> findJobSimple({Map? queryParam}) async {
    if (queryParam?.keys.isNotEmpty ?? false) {
      var result = await _dbConfiguration.execQuery(
          "Select t1.id, t1.title, t2.photoUrl, t1.city, t1.modality from jobs as t1 inner join companies as t2 on t2.id = t1.companyId where t1.${queryParam!.keys.first} = '${queryParam.values.first}';");
      return result
          .map((r) => JobSimple.fromJson(r.fields))
          .toList()
          .cast<JobSimple>();
    }

    var result = await _dbConfiguration.execQuery(
        'Select t1.id, t1.title, t2.photoUrl, t1.city, t1.modality from jobs as t1 inner join companies as t2 on t2.id = t1.companyId;');
    return result
        .map((r) => JobSimple.fromJson(r.fields))
        .toList()
        .cast<JobSimple>();
  }
}
