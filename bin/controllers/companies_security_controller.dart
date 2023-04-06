import 'dart:convert';

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../models/company_model.dart';
import '../services/companies_service.dart';
import '../to/status_to.dart';
import 'controller.dart';

class CompaniesSecurityController extends Controller {
  final CompaniesService _companiesService;
  CompaniesSecurityController(this._companiesService);

  @override
  Handler getHandler(
      {List<Middleware>? middlewares,
      bool isSecurity = false,
      bool isJsonMimeType = true}) {
    Router router = Router();

    router.get('/companies', (Request request) async {
      final userID = _getUserIdFromJWT(request);
      final String query =
          "t1.created_by = '$userID' and t1.status = 'active';";
      final List<CompanyModel?> result =
          await _companiesService.findByQuery(queryParam: query);
      return Response.ok(jsonEncode(result));
    });

    router.post('/companies', (Request request) async {
      final String body = await request.readAsString();
      final CompanyModel companyModel = CompanyModel.fromMap(jsonDecode(body));
      final String userIdFromJWT = _getUserIdFromJWT(request);
      companyModel.createdBy = userIdFromJWT;
      companyModel.status = 'active';
      final result = await _companiesService.save(companyModel);
      return result ? Response(201) : Response(404);
    });

    router.put('/companies', (Request request) async {
      final String body = await request.readAsString();
      final CompanyModel companyModel = CompanyModel.fromMap(jsonDecode(body));

      if (companyModel.id == null) {
        return Response.badRequest();
      }

      CompanyModel? companyFromDb =
          await _companiesService.findOne(companyModel.id!);

      if (companyFromDb == null) {
        return Response(400);
      }

      final bool isValid = await _validateAuth(companyFromDb, request);

      if (!isValid) {
        return Response.forbidden('Not Authorized.');
      }

      final userID = _getUserIdFromJWT(request);
      companyModel.updatedBy = userID;

      final bool result = await _companiesService.save(companyModel);
      return result ? Response(201) : Response(500);
    });

    router.put('/companies-status', (Request request) async {
      final String body = await request.readAsString();
      final StatusTO statusTO = StatusTO.fromRequest(body);
      CompanyModel companyModel = CompanyModel();

      companyModel.status = statusTO.status.toLowerCase();
      companyModel.id = statusTO.id;

      if (companyModel.id == null || companyModel.status == null) {
        return Response.badRequest();
      }

      final List<String> listOfStatus = await _companiesService.getStatus();

      if (!listOfStatus.contains(companyModel.status?.toLowerCase())) {
        return Response.badRequest();
      }

      final CompanyModel? companyModelFromDB =
          await _companiesService.findOne(companyModel.id!);

      if (companyModelFromDB == null) {
        return Response.notFound('Not Found');
      }
      companyModel.createdBy = companyModelFromDB.createdBy;

      final JWT jwt = request.context['jwt'] as JWT;
      final String profileID = jwt.payload['roles'];
      bool valid = true;
      if (!(profileID == "Admin")) {
        valid = await _validateAuth(companyModel, request);
      }

      if (!valid) {
        return Response.forbidden('Not Authorized.');
      }

      final String userIdFromJWT = _getUserIdFromJWT(request);
      companyModel.updatedBy = userIdFromJWT;
      bool result = await _companiesService.updateStatus(companyModel);

      return result ? Response(201) : Response(500);
    });

    return createHandler(
      router: router,
      middlewares: middlewares,
      isSecurity: isSecurity,
      isJsonMimeType: isJsonMimeType,
    );
  }

  Future<bool> _validateAuth(CompanyModel companyModel, Request request) async {
    final String createdBy = companyModel.createdBy!;
    final String userIdFromJWT = _getUserIdFromJWT(request);
    if (userIdFromJWT != createdBy) {
      return false;
    }
    return true;
  }

  String _getUserIdFromJWT(Request request) {
    final JWT jwt = request.context['jwt'] as JWT;
    final userID = jwt.payload['userID'];
    return userID;
  }
}
