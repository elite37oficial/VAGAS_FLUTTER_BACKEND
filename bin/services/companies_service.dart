import '../dao/companies_dao.dart';
import '../models/company_model.dart';
import 'generic_service.dart';

class CompaniesService implements GenericService<CompanyModel> {
  final CompaniesDAO _companiesDAO;
  CompaniesService(this._companiesDAO);

  // @override
  // Future<bool> delete(String id) async {
  //   return await _companiesDAO.delete(id);
  // }

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
  Future<bool> save(CompanyModel value) {
    return value.id == null
        ? _companiesDAO.create(value)
        : _companiesDAO.update(value);
  }

  @override
  Future<bool> updateStatus(CompanyModel value) async {
    return await _companiesDAO.updateStatus(value);
  }
}
