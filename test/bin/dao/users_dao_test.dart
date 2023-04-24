import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:uuid/uuid.dart';

import '../../../bin/dao/users_dao.dart';

import '../../mock.dart';

void main() {
  late MockDBConfiguration mockDBConfiguration;
  late UserDAO userDAO;
  late MockResults mockResults;

  setUpAll(() {
    mockResults = MockResults();
    mockDBConfiguration = MockDBConfiguration();
    userDAO = UserDAO(mockDBConfiguration, Uuid());
  });
  test('deve retornar true ao criar um novo usuário', () async {
    // when(() async => await mockDBConfiguration.execQuery(any())).thenAnswer(
    //   (_) async => mockResults,
    // );
    when(() async => await mockDBConfiguration.execQuery(any()))
        .thenAnswer((_) async {
      return mockResults;
    });
    final result = await userDAO.create(mockUserModel);
    expect(result, true);
  });
}
