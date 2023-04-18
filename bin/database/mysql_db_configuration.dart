import 'package:dotenv/dotenv.dart';
import 'package:mysql1/mysql1.dart';

import 'db_configuration.dart';

class MySqlDbConfiguration implements DBConfiguration {
  MySqlConnection? _mySqlConnection;
  var env = DotEnv(includePlatformEnvironment: true)..load();

  @override
  Future<MySqlConnection> get connection async {
    _mySqlConnection ??= await createConection();

    if (_mySqlConnection == null) {
      throw Exception('[ERROR/DB] =>Failed to crate connection.');
    }

    return _mySqlConnection!;
  }

  @override
  Future<MySqlConnection> createConection() async {
    var configuration = ConnectionSettings(
      db: env['db_schema'],
      host: env['db_host'] ?? '',
      port: int.parse(env['db_port'].toString()),
      password: env['db_pass'],
      user: env['db_user'],
      // timeout: Duration(seconds: 60),
    );

    return await MySqlConnection.connect(configuration);
  }

  @override
  execQuery(String sql, [List? params]) async {
    var connection = await this.connection;
    print(sql);
    final result = await connection.query(sql, params);
    _mySqlConnection = await connection.close();
    return result;
  }
}
