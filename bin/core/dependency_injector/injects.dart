import '../../controllers/jobs_controller.dart';
import '../../controllers/login_controller.dart';
import '../../controllers/ping_controller.dart';
import '../../dao/jobs_dao.dart';
import '../../database/mysql_db_configuration.dart';
import '../../services/jobs_service.dart';
import 'dependency_injector.dart';

class Injects {
  static DependencyInjector initialize() {
    var di = DependencyInjector();

    di.register<LoginController>(() => LoginController());
    di.register<PingController>(() => PingController());
    di.register<MySqlDbConfiguration>(() => MySqlDbConfiguration());
    di.register(() => JobDAO(di.get<MySqlDbConfiguration>()));
    di.register(() => JobsService(di.get<JobDAO>()));
    di.register(() => JobsController(di.get<JobsService>()));

    return di;
  }
}