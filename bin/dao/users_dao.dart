import '../database/db_configuration.dart';
import '../models/user_model.dart';
import 'dao.dart';

class UserDAO implements DAO<UserModel> {
  final DBConfiguration _dbConfiguration;
  UserDAO(this._dbConfiguration);

  @override
  Future<bool> create(UserModel value) {
    // TODO: implement create
    throw UnimplementedError();
  }

  @override
  Future<bool> delete(String id) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<List<UserModel>> findAll() {
    // TODO: implement findAll
    throw UnimplementedError();
  }

  @override
  Future<List<UserModel?>> findByQuery({String? queryParam}) async {
    // TODO: implement findOne
    throw UnimplementedError();
  }

  @override
  Future<UserModel?> findOne(String id) {
    // TODO: implement findOne
    throw UnimplementedError();
  }

  @override
  Future<bool> update(UserModel value) {
    // TODO: implement update
    throw UnimplementedError();
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
