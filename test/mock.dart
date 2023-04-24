import 'package:mocktail/mocktail.dart';
import 'package:mysql1/mysql1.dart';

import '../bin/database/db_configuration.dart';
import '../bin/models/user_model.dart';

class MockDBConfiguration extends Mock implements DBConfiguration {}

class MockResults extends Mock implements Results {
  @override
  int? get affectedRows => 1;
}

final UserModel mockUserModel = UserModel(
  name: 'name',
  email: 'name@email.com',
  password: 'senha123',
  phone: '(12) 99721-3383',
);
