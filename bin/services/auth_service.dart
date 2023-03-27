import 'dart:developer';

import 'package:password_dart/password_dart.dart';

import '../models/user_model.dart';
import '../to/auth_to.dart';
import 'users_service.dart';

class AuthService {
  final UsersService _userService;
  AuthService(this._userService);

  Future<UserModel?> authenticate(AuthTO authTO) async {
    try {
      final UserModel? user = await _userService.findByEmail(authTO.email);

      if (user == null) {
        return null;
      }
      bool verifyPass = Password.verify(authTO.password, user.password!);
      return verifyPass ? user : null;
    } catch (e) {
      log('[ERROR] -> Authenticate method by email ${authTO.email} not found!');
    }
    return null;
  }
}
