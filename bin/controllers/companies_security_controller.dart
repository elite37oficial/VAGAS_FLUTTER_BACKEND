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
      final userID = getUserIdFromJWT(request);
      String limit = request.url.queryParameters['limit'] ?? '10';
      String page = request.url.queryParameters['page'] ?? '1';
      var result = await _companiesService.findByQuery(
          queryParam:
              "where t1.created_by = '$userID' limit ${int.parse(limit)} offset ${(int.parse(page) - 1) * int.parse(limit)}");
      int totalItens = await _companiesService
          .getTotalPage("where t1.created_by = '$userID'");
      int totalPages = (totalItens / int.parse(limit)).ceil();
      final response = {
        "actualPage": request.url.queryParameters['page'] ?? '1',
        "totalPages": totalPages.toString(),
        "totalContents": totalItens.toString(),
        "data": result
      };
      return Response.ok(jsonEncode(response));
    });

    router.get('/companies/id/<companyID>',
        (Request request, String companyID) async {
      if (companyID.isEmpty) {
        return Response.badRequest(
            body: jsonEncode({'message': 'O campo id é obrigatório'}));
      }
      RegExp uuidRegex = RegExp(
          '^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-1[0-9a-fA-F]{3}-[89abAB][0-9a-fA-F]{3}-[0-9a-fA-F]{12}\$');

      if (uuidRegex.hasMatch(companyID)) {
        var result = await _companiesService.findOne(companyID);
        return result != null
            ? Response.ok(jsonEncode(result))
            : Response.notFound(jsonEncode(
                {'message': 'Empresa não encontrada na base de dados.'}));
      }
      return Response.badRequest();
    });

    router.post('/companies', (Request request) async {
      final String body = await request.readAsString();
      final CompanyModel companyModel = CompanyModel.fromMap(jsonDecode(body));
      final String userIdFromJWT = getUserIdFromJWT(request);
      companyModel.createdBy = userIdFromJWT;
      companyModel.status = 1;
      final result = await _companiesService.save(companyModel);
      return result.isNotEmpty
          ? Response(201, body: jsonEncode({'id': result}))
          : Response(404);
    });

    router.put('/companies', (Request request) async {
      final String body = await request.readAsString();
      final CompanyModel companyModel = CompanyModel.fromMap(jsonDecode(body));

      if (companyModel.id == null) {
        return Response.badRequest(
            body: {'message': 'O Id não pode ser nulo.'});
      }

      CompanyModel? companyFromDb =
          await _companiesService.findOne(companyModel.id!);

      if (companyFromDb == null) {
        return Response(400);
      }

      final bool isValid = await validateAuth(companyFromDb.createdBy, request);

      if (!isValid) {
        return Response.forbidden(jsonEncode({'message': 'Not Authorized.'}));
      }

      final userID = getUserIdFromJWT(request);
      companyModel.updatedBy = userID;

      final String result = await _companiesService.save(companyModel);
      return result.isNotEmpty ? Response(201) : Response(500);
    });

    router.put('/companies-status', (Request request) async {
      final String body = await request.readAsString();
      final StatusTO statusTO = StatusTO.fromRequest(body);
      if (statusTO.resourceId == null || statusTO.status == null) {
        return Response.badRequest(
            body: jsonEncode(
                {'message': 'Os campos Id e status são obrigatórios'}));
      }

      final List<StatusTO> statusListFromDB =
          await _companiesService.getStatus();

      // final List<String?> listOfStatus = statusListFromDB
      //     .map((statusTo) => statusTo.name?.toLowerCase())
      //     .toList();
      final List<int?> listOfId =
          statusListFromDB.map((statusTo) => statusTo.id).toList();

      if (!listOfId.contains(statusTO.status)) {
        return Response.badRequest(
            body: jsonEncode({'message': 'O status informado não é válido.'}));
      }

      CompanyModel companyModel = CompanyModel()
        ..id = statusTO.resourceId
        ..status = statusListFromDB
            .firstWhereOrNull((statusToFromDB) =>
                statusToFromDB.id?.toString() == statusTO.status?.toString())
            ?.id;

      final CompanyModel? companyModelFromDB =
          await _companiesService.findOne(companyModel.id!);

      if (companyModelFromDB == null) {
        return Response.notFound(
          jsonEncode(
            {
              'message':
                  'Não existe uma empresa com o Id informado na base de dados'
            },
          ),
        );
      }
      companyModel.createdBy = companyModelFromDB.createdBy;

      final JWT jwt = request.context['jwt'] as JWT;
      final String profileID = jwt.payload['roles'];
      bool valid = true;
      if (!(profileID.toLowerCase() == "admin")) {
        valid = await validateAuth(companyModel.createdBy, request);
      }

      if (!valid) {
        return Response.forbidden(
          jsonEncode(
            {'message': 'Voce não tem permissão para editar esse recurso.'},
          ),
        );
      }

      final String userIdFromJWT = getUserIdFromJWT(request);
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
}
