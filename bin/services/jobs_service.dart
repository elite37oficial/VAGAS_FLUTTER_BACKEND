import '../dao/dao.dart';
import '../models/job_model.dart';
import 'generic_service.dart';

class JobsService implements GenericService<JobModel> {
  final DAO<JobModel> _dao;

  JobsService(this._dao);

  @override
  Future<bool> delete(String id) async {
    var result = await _dao.delete(id);
    return result;
  }

  @override
  Future<List<JobModel>> findAll() async {
    return await _dao.findAll();
  }

  @override
  Future<List<JobModel?>> findJobSimple({String? queryParam}) async {
    return await _dao.findJobSimple(queryParam: queryParam);
  }

  @override
  Future<JobModel?> findOne(String id) async {
    return await _dao.findOne(id);
  }

  @override
  Future<bool> save(JobModel value) async {
    return value.id != null
        ? await _dao.update(value)
        : await _dao.create(value);
  }
}
