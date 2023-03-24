import 'package:uuid/uuid.dart';

import '../database/db_configuration.dart';
import '../models/job_details.dart';
import '../models/job_model.dart';
import '../models/job_simple.dart';
import 'dao.dart';

class JobDAO implements DAO<JobModel> {
  final DBConfiguration _dbConfiguration;
  final Uuid uuid;

  JobDAO(this._dbConfiguration, this.uuid);

  @override
  Future<bool> create(JobModel value) async {
    final DateTime now = DateTime.now().toUtc();
    var result = await _dbConfiguration.execQuery(
        'INSERT INTO jobs (id, company_id, title, description, salary, modality, seniority, regime, link, whatsapp, email, city, created_by, created_date) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?); ',
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
          value.city,
          value.createdBy,
          now
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
    var result = await _dbConfiguration.execQuery(
        'SELECT t1.id, t1.title, t1.city, t1.regime, t1.modality, t1.description, t1.whatsapp, t1.salary, t1.email, t1.link, t2.description AS description_company, t2.photo_url, t2.name as name_company FROM jobs AS t1 INNER JOIN companies AS t2 ON t2.id = t1.company_id where t1.id = ?;',
        [id]);

    return result.isEmpty ? null : JobDetails.fromJson(result.first.fields);
  }

  @override
  Future<bool> update(JobModel value) async {
    final DateTime now = DateTime.now().toUtc();
    var result = await _dbConfiguration.execQuery(
      'UPDATE jobs set company_id = ?, title = ?, description = ?, salary = ?, modality = ?,seniority = ?, regime = ?, link = ?, whatsapp = ?, email = ?, city = ?, updated_by = ?, updated_date = ? where id = ?',
      [
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
        value.city,
        value.changedBy,
        now,
        value.id
      ],
    );

    return result.affectedRows > 0;
  }

  @override
  Future<List<JobModel?>> findJobSimple({String? queryParam}) async {
    if (queryParam?.isNotEmpty ?? false) {
      var result = await _dbConfiguration.execQuery(
          "Select t1.id, t1.title, t2.photo_url, t1.city, t1.modality from jobs as t1 inner join companies as t2 on t2.id = t1.company_id where $queryParam ;");
      return result
          .map((r) => JobSimple.fromJson(r.fields))
          .toList()
          .cast<JobSimple>();
    }

    var result = await _dbConfiguration.execQuery(
        'Select t1.id, t1.title, t2.photo_url, t1.city, t1.modality from jobs as t1 inner join companies as t2 on t2.id = t1.company_id;');
    return result
        .map((r) => JobSimple.fromJson(r.fields))
        .toList()
        .cast<JobSimple>();
  }
}
