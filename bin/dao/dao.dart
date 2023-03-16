abstract class DAO<T> {
  Future<List<T>> findAll();
  Future<T?> findOne(String id);
  Future<bool> delete(String id);
  Future<bool> update(T value);
  Future<bool> create(T value);
}
