import '../models/job_model.dart';
import '../utils/list_extension.dart';
import 'generic_service.dart';

class JobsService implements GenericService<JobModel> {
  final List<JobModel> _fakeDB = [];

  @override
  Future<bool> delete(int id) async {
    bool result = _exist(id);
    if (result) {
      _fakeDB.removeWhere((job) => job.id == id);
    }
    return result;
  }

  @override
  Future<List<JobModel>> findAll() async {
    return _fakeDB;
  }

  @override
  Future<JobModel?> findOne(int id) async {
    bool result = _exist(id);
    if (result) {
      return _fakeDB.firstWhere((job) => job.id == id);
    }
    return null;
  }

  @override
  Future<bool> save(JobModel object) async {
    JobModel? jobModel = _fakeDB.firstWhereOrNull((job) => job.id == object.id);
    if (jobModel == null) {
      _fakeDB.add(object);
    } else {
      var index = _fakeDB.indexOf(object);
      _fakeDB[index] = object;
    }
    return true;
  }

  bool _exist(int id) {
    return _fakeDB.any((job) => job.id == id);
  }
}
