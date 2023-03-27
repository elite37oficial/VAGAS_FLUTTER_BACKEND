import 'package:shelf/shelf.dart';

abstract class SecurityService<T> {
  Future<String> generateJWT(String userID, String profileID);
  Future<T?> validateJWT(String token);

  Middleware get authorization;
  Middleware get verifyJwt;
}
