import '../dao/users_dao.dart';
import '../models/user_model.dart';

class UsersService {
  final UserDAO userDAO;

  UsersService(this.userDAO);

  Future<UserModel?> findByEmail(String email) async {
    final result = await userDAO.findByEmail(email);
    return result;
  }
}
