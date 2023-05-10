import '../dao/companies_dao.dart';
import '../models/company_model.dart';
import '../to/status_to.dart';
import 'generic_service.dart';

class CompaniesService implements GenericService<CompanyModel> {
  final CompaniesDAO _companiesDAO;
  CompaniesService(this._companiesDAO);

  @override
  Future<List<CompanyModel>> findAll() async {
    return await _companiesDAO.findAll();
  }

  @override
  Future<List<CompanyModel?>> findByQuery({String? queryParam}) async {
    return await _companiesDAO.findByQuery(queryParam: queryParam);
  }

  @override
  Future<CompanyModel?> findOne(String id) async {
    return await _companiesDAO.findOne(id);
  }

  @override
  Future<String> save(CompanyModel value) {
    return value.id == null
        ? _companiesDAO.create(value)
        : _companiesDAO.update(value);
  }

  @override
  Future<bool> updateStatus(CompanyModel value) async {
    return await _companiesDAO.updateStatus(value);
  }

  @override
  Future<List<StatusTO>> getStatus() async {
    return await _companiesDAO.getStatus();
  }

  @override
  Future<int> getTotalPage(String? queryParam) {
    // TODO: implement getTotalPage
    throw UnimplementedError();
  }
}
