abstract class DAO<T> {
  Future<List<T>> findAll();
  Future<List<T?>> findJobSimple({String? queryParam});
  Future<T?> findOne(String id);
  Future<bool> delete(String id);
  Future<bool> update(T value);
  Future<bool> create(T value);
}
