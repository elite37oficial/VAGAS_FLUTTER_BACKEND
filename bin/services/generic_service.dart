import '../to/status_to.dart';

abstract class GenericService<T> {
  Future<T?> findOne(String id);
  Future<List<T>> findAll();
  Future<List<T?>> findByQuery({String? queryParam});
  Future<String> save(T value);
  Future<bool> updateStatus(T value);
  Future<List<StatusTO>> getStatus();
  Future<int> getTotalPage(String? queryParam);
}
