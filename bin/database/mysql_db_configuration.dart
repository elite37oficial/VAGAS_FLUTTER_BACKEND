import 'package:dotenv/dotenv.dart';
import 'package:mysql1/mysql1.dart';

import 'db_configuration.dart';

class MySqlDbConfiguration implements DBConfiguration {
  MySqlConnection? _mySqlConnection;
  var env = DotEnv(includePlatformEnvironment: true)..load();

  @override
  Future<MySqlConnection> get connection async {
    _mySqlConnection ??= await createConection();

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
      timeout: Duration(seconds: 60),
    );

    return await MySqlConnection.connect(configuration);
  }

  @override
  execQuery(String sql, [List? params]) async {
    var connection = await this.connection;
    print(sql);
    return connection.query(sql, params);
  }
}
