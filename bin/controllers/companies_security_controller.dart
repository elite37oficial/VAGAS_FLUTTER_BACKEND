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
  Handler getHandler({List<Middleware>? middlewares, bool isSecurity = false}) {
    Router router = Router();

    router.get('/companies', (Request request) async {
      // verificação do created_by
      final List<CompanyModel?> result = await _companiesService.findByQuery();
      return Response.ok(jsonEncode(result));
    });

    router.post('/companies', (Request request) async {
      final String body = await request.readAsString();
      final CompanyModel companyModel = CompanyModel.fromMap(jsonDecode(body));
      JWT jwt = request.context['jwt'] as JWT;
      final String userIdFromJWT = jwt.payload['userID'];
      companyModel.createdBy = userIdFromJWT;
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

      var result = await _companiesService.save(companyModel);
      return result ? Response(201) : Response(500);
    });

    router.put('/companies-status', (Request request) async {
      final String body = await request.readAsString();
      final StatusTO statusTO = StatusTO.fromRequest(body);
      CompanyModel companyModel = CompanyModel();
      companyModel.status = statusTO.status;
      companyModel.id = statusTO.id;

      if (companyModel.id == null || companyModel.status == null) {
        return Response.badRequest();
      }

      switch (companyModel.status) {
        case 0:
        case 1:
          break;
        default:
          return Response.badRequest();
      }

      //validar se usuario possui autorização para pausar a vaga

      bool result = await _companiesService.updateStatus(companyModel);

      return result ? Response(201) : Response(500);
    });

    return createHandler(
        router: router, middlewares: middlewares, isSecurity: isSecurity);
  }

  Future<bool> _validateAuth(CompanyModel companyModel, Request request) async {
    final String createdBy = companyModel.createdBy!;
    JWT jwt = request.context['jwt'] as JWT;
    final String userIdFromJWT = jwt.payload['userID'];

    if (userIdFromJWT != createdBy) {
      return false;
    }

    return true;
  }
}
