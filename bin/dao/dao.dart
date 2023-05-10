import '../to/status_to.dart';

abstract class DAO<T> {
  Future<List<T>> findAll();
  Future<List<T?>> findByQuery({String? queryParam});
  Future<T?> findOne(String id);
  Future<String> update(T value);
  Future<String> create(T value);
  Future<bool> updateStatus(T value);
  Future<List<StatusTO>> getStatus();
  Future<int> getTotalPage(String? queryParam);
}
