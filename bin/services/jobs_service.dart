import '../dao/dao.dart';
import '../models/job_model.dart';
import '../to/status_to.dart';
import 'generic_service.dart';

class JobsService implements GenericService<JobModel> {
  final DAO<JobModel> _dao;

  JobsService(this._dao);

  @override
  Future<List<JobModel>> findAll() async {
    return await _dao.findAll();
  }

  @override
  Future<List<JobModel?>> findByQuery({String? queryParam}) async {
    return await _dao.findByQuery(queryParam: queryParam);
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

  @override
  Future<bool> updateStatus(JobModel value) async {
    return await _dao.updateStatus(value);
  }

  @override
  Future<List<StatusTO>> getStatus() async {
    return await _dao.getStatus();
  }
}
