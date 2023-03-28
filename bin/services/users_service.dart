import '../dao/users_dao.dart';
import '../models/user_model.dart';

class UsersService {
  final UserDAO userDAO;

  UsersService(this.userDAO);

  Future<UserModel?> findByEmail(String email) async {
    final result = await userDAO.findByEmail(email);
    return result;
  }

  Future<bool> save(UserModel value) async {
    return value.id != null
        ? await userDAO.update(value)
        : await userDAO.create(value);
  }
}
