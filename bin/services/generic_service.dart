abstract class GenericService<T> {
  Future<T?> findOne(String id);
  Future<List<T>> findAll();
  Future<List<T?>> findJobSimple({Map? queryParam});
  Future<bool> save(T value);
  Future<bool> delete(String id);
}
