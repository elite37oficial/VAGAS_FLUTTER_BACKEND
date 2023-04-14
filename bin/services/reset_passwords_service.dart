import '../dao/reset_passwords_dao.dart';
import '../models/reset_password_model.dart';

class ResetPasswordsService {
  final ResetPasswordsDao _dao;

  ResetPasswordsService(this._dao);

  Future<String?> save(ResetPasswordModel value) async {
    return await _dao.create(value);
  }

  Future<ResetPasswordModel?> findOne(String token) async {
    return await _dao.findOne(token);
  }

  Future<ResetPasswordModel?> updatePassword(ResetPasswordModel value) async {
    return await _dao.updatePassword(value);
  }
}
