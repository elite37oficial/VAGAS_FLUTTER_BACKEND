import 'package:uuid/uuid.dart';
import '../database/db_configuration.dart';
import '../models/job_details.dart';
import '../models/job_model.dart';
import '../models/job_simple.dart';
import '../to/status_to.dart';
import 'dao.dart';

class JobDAO implements DAO<JobModel> {
  final DBConfiguration _dbConfiguration;
  final Uuid uuid;

  JobDAO(this._dbConfiguration, this.uuid);

  @override
  Future<bool> create(JobModel value) async {
    final DateTime now = DateTime.now().toUtc();
    var result = await _dbConfiguration.execQuery(
        'INSERT INTO jobs (id, company_id, title, status, description, salary, modality, seniority, regime, link, whatsapp, email, city, state, created_by, created_date) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?); ',
        [
          uuid.v1(),
          value.companyId,
          value.title,
          value.status,
          value.description,
          value.salary,
          value.modality,
          value.seniority,
          value.regime,
          value.link,
          value.whatsappNumber,
          value.email,
          value.city,
          value.state,
          value.createdBy,
          now
        ]);
    return result.affectedRows > 0;
  }

  @override
  Future<List<JobModel>> findAll() async {
    var result = await _dbConfiguration
        .execQuery('SELECT * FROM jobs ORDER BY created_date desc');
    return result
        .map((r) => JobModel.fromJson(r.fields))
        .toList()
        .cast<JobModel>();
  }

  @override
  Future<JobModel?> findOne(String id) async {
    var result = await _dbConfiguration.execQuery(
        "SELECT t1.id, t1.title, t1.city, t1.state, t1.regime, t1.modality, t1.description, t1.whatsapp, t1.salary, t1.email, t1.seniority, t1.link, t1.created_by, t2.description AS description_company, t2.name as name_company, t2.id as company_id, t3.name as status FROM jobs AS t1 INNER JOIN companies AS t2 ON t2.id = t1.company_id inner join jobs_status as t3 on t1.status = t3.id where t1.id = ? ORDER BY t1.created_date desc;",
        [id]);

    return result.isEmpty ? null : JobDetails.fromJson(result.first.fields);
  }

  @override
  Future<bool> update(JobModel value) async {
    final DateTime now = DateTime.now().toUtc();
    var result = await _dbConfiguration.execQuery(
      'UPDATE jobs set company_id = ?, title = ?, description = ?, salary = ?, modality = ?,seniority = ?, regime = ?, link = ?, whatsapp = ?, email = ?, city = ?, state = ?, updated_by = ?, updated_date = ? where id = ?',
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
        value.state,
        value.changedBy,
        now,
        value.id
      ],
    );

    return result.affectedRows > 0;
  }

  @override
  Future<bool> updateStatus(JobModel value) async {
    final DateTime now = DateTime.now().toUtc();
    var result = await _dbConfiguration.execQuery(
      'UPDATE jobs set status = ?, updated_by = ?, updated_date = ? where id = ?',
      [value.status, value.id, now, value.id],
    );

    return result.affectedRows > 0;
  }

  @override
  Future<List<JobModel?>> findByQuery({String? queryParam}) async {
    if (queryParam?.isNotEmpty ?? false) {
      var result = await _dbConfiguration.execQuery(
          "Select t1.id, t1.title, t1.city, t1.regime, t1.state, t1.created_date, t1.created_by, t3.name as status, t1.modality, t2.id as company_id, t2.name as company_name from jobs as t1 inner join companies as t2 on t2.id = t1.company_id inner join jobs_status as t3 on t1.status = t3.id $queryParam ORDER BY t1.created_date desc;");
      return result
          .map((r) => JobSimple.fromJson(r.fields))
          .toList()
          .cast<JobSimple>();
    }
    var result = await _dbConfiguration.execQuery(
        "Select t1.id, t1.title, t1.city, t1.regime, t1.state, t1.created_date, t1.created_by, t3.name as status, t1.modality, t2.name as company_name, t2.id as company_id from jobs as t1 inner join companies as t2 on t2.id = t1.company_id inner join jobs_status as t3 on t1.status = t3.id where t1.status='1' ORDER BY t1.created_date desc;");
    return result
        .map((r) => JobSimple.fromJson(r.fields))
        .toList()
        .cast<JobSimple>();
  }

  @override
  Future<List<StatusTO>> getStatus() async {
    final result =
        await _dbConfiguration.execQuery('Select * from jobs_status;');
    final List<StatusTO> statusToList = result
        .map((r) => StatusTO.fromJson(r.fields))
        .toList()
        .cast<StatusTO>();

    return statusToList;
  }
}
