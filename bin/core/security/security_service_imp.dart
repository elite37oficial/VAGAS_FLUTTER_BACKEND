import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:dotenv/dotenv.dart';
import 'package:shelf/shelf.dart';

import '../dependency_injector/dependency_injector.dart';
import 'security_service.dart';

class SecurityServiceImp implements SecurityService<JWT> {
  DependencyInjector di = DependencyInjector();

  @override
  Future<String> generateJWT(String userID, String profileID) async {
    DotEnv dotEnv = di.get<DotEnv>();
    var jwt = JWT({
      'iat': DateTime.now().millisecondsSinceEpoch,
      'userID': userID,
      'roles': profileID,
    });

    String? key = dotEnv['jwt_key'];
    if (key == null) {
      throw Exception('[Error] -> secret key JWT not inserted on .env');
    }
    String token = jwt.sign(SecretKey(key));
    return token;
  }

  @override
  Future<JWT?> validateJWT(String token) async {
    DotEnv dotEnv = di.get<DotEnv>();
    String? key = dotEnv['jwt_key'];
    if (key == null) {
      throw Exception('[Error] -> secret key JWT not inserted on .env');
    }
    try {
      return JWT.verify(token, SecretKey(key));
    } on JWTInvalidError {
      return null;
    } on JWTExpiredError {
      return null;
    } on JWTNotActiveError {
      return null;
    } on JWTUndefinedError {
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Middleware get authorization {
    return (Handler handler) {
      return (Request request) async {
        String? authorizationOnHeader = request.headers['Authorization'];

        JWT? jwt;

        if (authorizationOnHeader != null) {
          if (authorizationOnHeader.startsWith('Bearer')) {
            String token = authorizationOnHeader.substring(7);
            jwt = await validateJWT(token);
          }
        }

        Request req = request.change(context: {'jwt': jwt});
        return handler(req);
      };
    };
  }

  @override
  Middleware get verifyJwt {
    return createMiddleware(
      requestHandler: (request) {
        if (request.context['jwt'] == null) {
          return Response.forbidden('Not Authorized');
        }
        return null;
      },
    );
  }
}
