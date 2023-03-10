abstract class GenericService<T> {
  Future<T> findOne(int id);
  Future<List<T>> findAll();
  Future<bool> save(T object);
  Future<bool> delete(int id);
}
