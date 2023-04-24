import 'package:dotenv/dotenv.dart';
import 'package:mysql1/mysql1.dart';

import '../core/dependency_injector/dependency_injector.dart';
import 'db_configuration.dart';

class MySqlDbConfiguration implements DBConfiguration {
  MySqlConnection? mySqlConnection;
  MySqlDbConfiguration({
    this.mySqlConnection,
  });
  final DotEnv env = DependencyInjector().get<DotEnv>();

  @override
  Future<MySqlConnection> get connection async {
    mySqlConnection ??= await createConection();

    if (mySqlConnection == null) {
      throw Exception('[ERROR/DB] =>Failed to crate connection.');
    }

    return mySqlConnection!;
  }

  @override
  Future<MySqlConnection> createConection() async {
    var configuration = ConnectionSettings(
      db: env['db_schema'],
      host: env['db_host'] ?? '',
      port: int.parse(env['db_port'].toString()),
      password: env['db_pass'],
      user: env['db_user'],
    );

    return await MySqlConnection.connect(configuration);
  }

  @override
  execQuery(String sql, [List? params]) async {
    var connection = await this.connection;
    print(sql);
    final result = await connection.query(sql, params);
    mySqlConnection = await connection.close();
    return result;
  }
}
