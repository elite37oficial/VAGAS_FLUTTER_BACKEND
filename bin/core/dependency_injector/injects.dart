import 'package:dotenv/dotenv.dart';
import 'package:uuid/uuid.dart';

import '../../controllers/companies_security_controller.dart';
import '../../controllers/jobs_controller.dart';
import '../../controllers/jobs_security_controller.dart';
import '../../controllers/login_controller.dart';
import '../../controllers/ping_controller.dart';
import '../../dao/companies_dao.dart';
import '../../controllers/users_controller.dart';
import '../../controllers/users_security_controller.dart';
import '../../dao/jobs_dao.dart';
import '../../dao/users_dao.dart';
import '../../database/mysql_db_configuration.dart';
import '../../services/auth_service.dart';
import '../../services/companies_service.dart';
import '../../services/jobs_service.dart';
import '../../services/users_service.dart';
import '../security/security_service.dart';
import '../security/security_service_imp.dart';
import 'dependency_injector.dart';

class Injects {
  static DependencyInjector initialize() {
    var di = DependencyInjector();

    di.register<DotEnv>(() => DotEnv(includePlatformEnvironment: true)..load());
    di.register<Uuid>(() => Uuid());
    di.register<SecurityService>(() => SecurityServiceImp());

    di.register<MySqlDbConfiguration>(() => MySqlDbConfiguration());
    di.register<CompaniesDAO>(
        () => CompaniesDAO(di.get<MySqlDbConfiguration>(), di.get()));
    di.register<CompaniesService>(
        () => CompaniesService(di.get<CompaniesDAO>()));
    di.register<UserDAO>(
        () => UserDAO(di.get<MySqlDbConfiguration>(), di.get<Uuid>()));
    di.register<UsersService>(() => UsersService(di.get<UserDAO>()));
    di.register(() => UsersController(di.get<UsersService>()));
    di.register(() => UsersSecurityController(di.get<UsersService>()));
    di.register<AuthService>(() => AuthService(di.get<UsersService>()));
    di.register<CompaniesSecurityController>(
        () => CompaniesSecurityController(di.get()));
    di.register<LoginController>(() =>
        LoginController(di.get<AuthService>(), di.get<SecurityService>()));
    di.register<PingController>(() => PingController());
    di.register(() => JobDAO(di.get<MySqlDbConfiguration>(), di.get<Uuid>()));
    di.register(() => JobsService(di.get<JobDAO>()));
    di.register(() => JobsController(di.get<JobsService>()));
    di.register(() => JobsSecurityController(di.get<JobsService>()));

    return di;
  }
}
