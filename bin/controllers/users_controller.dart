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
  Handler getHandler({List<Middleware>? middlewares, bool isSecurity = false}) {
    Router router = Router();

    router.post('/users', (Request request) async {
      var body = await request.readAsString();
      UserModel userModel = UserModel.fromJson(jsonDecode(body));
      var result = await _usersService.save(userModel);
      return result ? Response(201) : Response(204);
    });

    return createHandler(
        router: router, isSecurity: isSecurity, middlewares: middlewares);
  }
}