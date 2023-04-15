import 'package:uuid/uuid.dart';

import '../database/db_configuration.dart';
import '../models/company_model.dart';
import '../to/status_to.dart';
import 'dao.dart';

class CompaniesDAO implements DAO<CompanyModel> {
  final DBConfiguration _dbConfiguration;
  final Uuid _uuid;
  CompaniesDAO(this._dbConfiguration, this._uuid);

  @override
  Future<bool> create(CompanyModel value) async {
    final DateTime now = DateTime.now().toUtc();
    var result = await _dbConfiguration.execQuery(
        'INSERT INTO companies (id, name, location,status, description, created_by, created_date) values (?,?,?,?,?,?);',
        [
          _uuid.v1(),
          value.name,
          value.location,
          value.status,
          value.description,
          value.createdBy,
          now
        ]);
    return result.affectedRows > 0;
  }

  @override
  Future<List<CompanyModel>> findAll() async {
    var result = await _dbConfiguration.execQuery('SELECT * FROM companies');
    return result
        .map((r) => CompanyModel.fromMap(r.fields))
        .toList()
        .cast<CompanyModel>();
  }

  @override
  Future<List<CompanyModel?>> findByQuery({String? queryParam}) async {
    if (queryParam?.isNotEmpty ?? false) {
      var result = await _dbConfiguration.execQuery(
          "Select t1.id, t1.name, t1.location, t1.description from companies as t1 where $queryParam;");
      return result
          .map((r) => CompanyModel.fromMap(r.fields))
          .toList()
          .cast<CompanyModel>();
    }

    var result = await _dbConfiguration.execQuery(
        "Select t1.id, t1.name, t1.location, t1.description from companies as t1 where t1.status = '1';");
    return result
        .map((r) => CompanyModel.fromMap(r.fields))
        .toList()
        .cast<CompanyModel>();
  }

  @override
  Future<CompanyModel?> findOne(String id) async {
    var result = await _dbConfiguration.execQuery(
        'SELECT t1.id, t1.name, t1.location, t1.description, t1.created_by, t1.created_date, t1.updated_by, t1.updated_date FROM companies AS t1 where t1.id = ?;',
        [id]);

    return result.isEmpty ? null : CompanyModel.fromMap(result.first.fields);
  }

  @override
  Future<bool> update(CompanyModel value) async {
    final DateTime now = DateTime.now().toUtc();
    var result = await _dbConfiguration.execQuery(
      'UPDATE companies set name = ?, location = ?, description = ?, updated_by = ?, updated_date = ? where id = ?',
      [
        value.name,
        value.location,
        value.description,
        value.createdBy,
        now,
        value.id
      ],
    );

    return result.affectedRows > 0;
  }

  @override
  Future<bool> updateStatus(CompanyModel value) async {
    final DateTime today = DateTime.now().toUtc();
    var result = await _dbConfiguration.execQuery(
      'UPDATE companies set status = ?, updated_by = ?, updated_date = ? where id = ?',
      [value.status, value.updatedBy, today, value.id],
    );

    return result.affectedRows > 0;
  }

  @override
  Future<List<StatusTO>> getStatus() async {
    final result =
        await _dbConfiguration.execQuery('Select * from companies_status;');
    final List<StatusTO> statusList = result
        .map((r) => (StatusTO.fromJson(r.fields)))
        .toList()
        .cast<StatusTO>();

    return statusList;
  }
}
