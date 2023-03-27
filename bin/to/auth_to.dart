import 'dart:convert';

class AuthTO {
  final String email;
  final String password;

  AuthTO({required this.email, required this.password});

  factory AuthTO.fromRequest(String body) {
    final Map map = jsonDecode(body);
    return AuthTO(email: map['email'], password: map['password']);
  }
}
