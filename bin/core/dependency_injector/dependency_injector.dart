typedef InstanceCreator<T> = T Function();

class DependencyInjector {
  //singleton
  DependencyInjector._();
  static final _singleton = DependencyInjector._();
  factory DependencyInjector() => _singleton;

  //map
  final Map _instanceMap = <Type, _InstanceGenerator<Object>>{};

  //register
  void register<T extends Object>(
    InstanceCreator<T> instanceCreator, {
    bool isSingleton = true,
  }) {
    _instanceMap[T] = _InstanceGenerator(instanceCreator, isSingleton);
  }

  //get
  T get<T extends Object>() {
    final instance = _instanceMap[T]?.getInstance();
    if (instance != null && instance is T) return instance;
    throw Exception('[ERROR] -> Instance ${T.toString()} not found');
  }

  call<T extends Object>() => get<T>();
}

class _InstanceGenerator<T> {
  T? _instance;
  bool _isFirstGet = false;

  final InstanceCreator<T> _instanceCreator;

  _InstanceGenerator(this._instanceCreator, bool isSingleton)
      : _isFirstGet = isSingleton;

  T? getInstance() {
    if (_isFirstGet) {
      _instance = _instanceCreator();
      _isFirstGet = false;
    }

    return _instance ?? _instanceCreator();
  }
}
