import 'package:password_dart/password_dart.dart';
import 'package:uuid/uuid.dart';

import '../database/db_configuration.dart';
import '../models/user_model.dart';
import 'dao.dart';

class UserDAO implements DAO<UserModel> {
  final DBConfiguration _dbConfiguration;
  final Uuid uuid;

  UserDAO(this._dbConfiguration, this.uuid);

  @override
  Future<bool> create(UserModel value) async {
    final DateTime now = DateTime.now().toUtc();
    if (value.password != null) {
      final String password = value.password!;
      final String pass = Password.hash(password, PBKDF2());
      final String id = uuid.v1();
      var result = await _dbConfiguration.execQuery(
          'INSERT INTO users (id, profile_id, name, phone, email, password, created_by, created_date) values(?,?,?,?,?,?,?,?);',
          [
            id,
            value.profileId,
            value.name,
            value.phone,
            value.email,
            pass,
            id,
            now
          ]);
      return result.affectedRows > 0;
    } else {
      return false;
    }
  }

  @override
  Future<bool> delete(String id) {
    // TODO: implement delete
    throw UnimplementedError();
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
        'Select id, password, profile_id from users where email = ?;', [email]);

    return result.affectedRows == 0
        ? null
        : UserModel.fromRequest(result.first.fields);
  }

  @override
  Future<bool> updateStatus(UserModel value) {
    // TODO: implement updateStatus
    throw UnimplementedError();
  }
}
