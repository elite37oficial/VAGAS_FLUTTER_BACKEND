import '../dao/users_dao.dart';

class PermissionService {
  final UserDAO _userDAO;
  PermissionService(this._userDAO);

  Future<List<String>> getPermissions(String profileId) async {
    return _userDAO.getPermissions(profileId);
  }
}
