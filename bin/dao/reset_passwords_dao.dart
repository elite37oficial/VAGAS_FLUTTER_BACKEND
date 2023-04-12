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
}
