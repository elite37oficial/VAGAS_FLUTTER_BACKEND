abstract class DAO<T> {
  Future<List<T>> findAll();
  Future<List<T?>> findByQuery({String? queryParam});
  Future<T?> findOne(String id);
  Future<bool> updateStatus(T value);
  Future<bool> update(T value);
  Future<bool> create(T value);
}
