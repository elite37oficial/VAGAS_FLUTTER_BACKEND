import 'package:password_dart/password_dart.dart';
import 'package:uuid/uuid.dart';

import '../database/db_configuration.dart';
import '../models/reset_password_model.dart';

class ResetPasswordsDao {
  final DBConfiguration _dbConfiguration;
  final Uuid uuid;

  ResetPasswordsDao(this._dbConfiguration, this.uuid);

  Future<String?> create(ResetPasswordModel value) async {
    final DateTime now = DateTime.now().toUtc();
    final String token = uuid.v1();
    var result = await _dbConfiguration.execQuery(
        'INSERT INTO reset_passwords (token, user_id, date) values(?,?,?);',
        [token, value.userId, now]);
    if (result.affectedRows > 0) {
      return token;
    } else {
      return null;
    }
  }

  Future<ResetPasswordModel?> findOne(String token) async {
    var result = await _dbConfiguration.execQuery(
        'SELECT t1.*, t2.`password` as passwordOld, t2.profile_id FROM reset_passwords AS t1 INNER JOIN users AS t2 ON t2.id = t1.user_id WHERE t1.token = ?',
        [token]);
    return result.isEmpty
        ? null
        : ResetPasswordModel.fromJson(result.first.fields);
  }

  Future<ResetPasswordModel?> updatePassword(ResetPasswordModel value) async {
    final result = await _dbConfiguration
        .execQuery('Select password from users WHERE id = ?', [value.userId]);
    final passwordOld = result.first.fields['password'];
    final String password = value.password ?? "";
    bool verifyPass = Password.verify(password, passwordOld!);
    if (!verifyPass) {
      final String pass = Password.hash(password, PBKDF2());
      await _dbConfiguration.execQuery(
          'UPDATE users SET PASSWORD = ? WHERE id = ?', [pass, value.userId]);
      return value;
    } else {
      return null;
    }
  }
}
