import 'package:password_dart/password_dart.dart';
import 'package:uuid/uuid.dart';

import '../database/db_configuration.dart';
import '../models/user_model.dart';
import '../to/status_to.dart';
import 'dao.dart';

class UserDAO implements DAO<UserModel> {
  final DBConfiguration _dbConfiguration;
  final Uuid uuid;

  UserDAO(this._dbConfiguration, this.uuid);

  @override
  Future<bool> create(UserModel value) async {
    final DateTime now = DateTime.now().toUtc();
    value.status = 'active';
    value.profileId = 'Recrutador';
    if (value.password != null) {
      final String password = value.password!;
      final String pass = Password.hash(password, PBKDF2());
      final String id = uuid.v1();
      var result = await _dbConfiguration.execQuery(
          'INSERT INTO users (id, profile_id, name, phone, email, password, status, created_by, created_date) values(?,?,?,?,?,?,?,?,?);',
          [
            id,
            value.profileId,
            value.name,
            value.phone,
            value.email,
            pass,
            value.status,
            id,
            now
          ]);
      return result.affectedRows > 0;
    } else {
      return false;
    }
  }

  @override
  Future<List<UserModel>> findAll() async {
    var result = await _dbConfiguration.execQuery('SELECT * FROM users');
    return result
        .map((r) => UserModel.fromJson(r.fields))
        .toList()
        .cast<UserModel>();
  }

  @override
  Future<List<UserModel?>> findByQuery({String? queryParam}) async {
    // TODO: implement findOne
    throw UnimplementedError();
  }

  @override
  Future<UserModel?> findOne(String id) async {
    var result = await _dbConfiguration
        .execQuery('SELECT * FROM users WHERE id = ?;', [id]);
    return result.isEmpty ? null : UserModel.fromJson(result.first.fields);
  }

  @override
  Future<bool> update(UserModel value) async {
    final DateTime now = DateTime.now().toUtc();
    final String password = value.password ?? "";
    final String pass = Password.hash(password, PBKDF2());
    var result = await _dbConfiguration.execQuery(
        'UPDATE users set profile_id = ?, name = ?, phone = ?, email = ?, password = ?, updated_by = ?, updated_date = ? where id = ?',
        [
          value.profileId,
          value.name,
          value.phone,
          value.email,
          pass,
          value.changedBy,
          now,
          value.id
        ]);

    return result.affectedRows > 0;
  }

  Future<UserModel?> findByEmail(String email) async {
    var result = await _dbConfiguration.execQuery(
      'Select id, password, profile_id, email, name from users where email = ?;',
      [email],
    );

    if (result.isEmpty) {
      return null;
    }
    return UserModel.fromRequest(result.first.fields);
  }

  @override
  Future<bool> updateStatus(UserModel value) {
    // TODO: implement updateStatus
    throw UnimplementedError();
  }

  Future<List<String>> getPermissions(String profileId) async {
    final result = await _dbConfiguration.execQuery(
      'Select role_id from profile_roles where profile_id = ?;',
      [profileId],
    );

    final List<String> permissions = result
        .map((r) => r.fields['role_id'].toString())
        .toList()
        .cast<String>();

    return permissions;
  }

  @override
  Future<List<StatusTO>> getStatus() async {
    final result =
        await _dbConfiguration.execQuery('Select * from users_status;');
    final List<StatusTO> statusList = result
        .map((r) => (StatusTO.fromJson(r.fields)))
        .toList()
        .cast<StatusTO>();

    return statusList;
  }
}
