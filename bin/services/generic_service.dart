import '../to/status_to.dart';

abstract class GenericService<T> {
  Future<T?> findOne(String id);
  Future<List<T>> findAll();
  Future<List<T?>> findByQuery({String? queryParam});
  Future<bool> save(T value);
  Future<bool> updateStatus(T value);
  Future<List<StatusTO>> getStatus();
}
