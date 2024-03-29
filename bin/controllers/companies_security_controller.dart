import 'dart:convert';

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../models/company_model.dart';
import '../services/companies_service.dart';
import '../to/status_to.dart';
import '../utils/list_extension.dart';
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
      final List<CompanyModel?> result = await _companiesService.findByQuery(
          queryParam: "t1.created_by = '$userID'");
      return Response.ok(jsonEncode(result));
    });

    router.get('/companies/id/<companyID>',
        (Request request, String companyID) async {
      if (companyID.isEmpty) {
        return Response.badRequest();
      }
      RegExp uuidRegex = RegExp(
          '^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-1[0-9a-fA-F]{3}-[89abAB][0-9a-fA-F]{3}-[0-9a-fA-F]{12}\$');

      if (uuidRegex.hasMatch(companyID)) {
        var result = await _companiesService.findOne(companyID);
        return result != null
            ? Response.ok(jsonEncode(result))
            : Response.notFound('Empresa não encontrada na base de dados.');
      }
      return Response.badRequest();
    });

    router.post('/companies', (Request request) async {
      final String body = await request.readAsString();
      final CompanyModel companyModel = CompanyModel.fromMap(jsonDecode(body));
      final String userIdFromJWT = _getUserIdFromJWT(request);
      companyModel.createdBy = userIdFromJWT;
      companyModel.status = 1;
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
      if (statusTO.resourceId == null || statusTO.status == null) {
        return Response.badRequest();
      }

      CompanyModel companyModel = CompanyModel();

      companyModel.id = statusTO.resourceId;

      final List<StatusTO> statusListFromDB =
          await _companiesService.getStatus();
      final List<String?> listOfStatus =
          statusListFromDB.map((e) => e.status?.toLowerCase()).toList();
      companyModel.status = statusListFromDB
          .firstWhereOrNull(
              (e) => e.status?.toLowerCase() == statusTO.status?.toLowerCase())
          ?.id;

      if (!listOfStatus.contains(statusTO.status?.toLowerCase())) {
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
