import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../models/user_model.dart';
import '../services/users_service.dart';
import 'controller.dart';

class UsersController extends Controller {
  final UsersService _usersService;
  UsersController(this._usersService);

  @override
  Handler getHandler({
    List<Middleware>? middlewares,
    bool isSecurity = false,
    bool isJsonMimeType = true,
  }) {
    Router router = Router();

    router.post('/users', (Request request) async {
      var body = await request.readAsString();
      UserModel userModel = UserModel.fromJson(jsonDecode(body));
      if (userModel.email == null) {
        return Response.badRequest(body: 'O campo email é obrigatório');
      }
      final userFromDB = await _usersService.findByEmail(userModel.email!);
      if (userFromDB != null) {
        return Response.badRequest(body: 'Email já está em uso');
      }
      var result = await _usersService.save(userModel);
      return result.isNotEmpty
          ? Response(201, body: result)
          : Response.badRequest();
    });

    return createHandler(
      router: router,
      isSecurity: isSecurity,
      middlewares: middlewares,
      isJsonMimeType: isJsonMimeType,
    );
  }
}
