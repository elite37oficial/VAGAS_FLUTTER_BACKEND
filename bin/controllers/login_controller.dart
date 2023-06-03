import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../core/security/security_service.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../to/auth_to.dart';
import 'controller.dart';

class LoginController extends Controller {
  final AuthService _authService;
  final SecurityService _securityServiceImp;
  LoginController(this._authService, this._securityServiceImp);

  @override
  Handler getHandler({
    List<Middleware>? middlewares,
    bool isSecurity = false,
    bool isJsonMimeType = true,
  }) {
    var router = Router();

    router.options('/login', (Request request) {
      final headersPermitidos = {
        'Access-Control-Allow-Origin': 'https://*.elite37.com.br',
        'Access-Control-Allow-Methods': 'POST, OPTIONS',
        'Access-Control-Allow-Headers': 'Origin, Content-Type, X-Auth-Token'
      };
      return Response(200, headers: headersPermitidos);
    });

    router.post('/login', (Request request) async {
      final body = await request.readAsString();
      final AuthTO authTO = AuthTO.fromRequest(body);
      final UserModel? userModel = await _authService.authenticate(authTO);
      if (userModel != null) {
        final String userID = userModel.id!;
        final String profileID = userModel.profileId!;
        // final List<String> permissions =
        //     await _authService.getPermissions(profileID);
        final String token =
            await _securityServiceImp.generateJWT(userID, profileID);
        return Response.ok(jsonEncode({'token': token}));
      } else {
        return Response(401);
      }
    });

    return createHandler(
      router: router,
      isSecurity: isSecurity,
      middlewares: middlewares,
      isJsonMimeType: isJsonMimeType,
    );
  }
}
