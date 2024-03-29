import 'package:dotenv/dotenv.dart';
import 'package:uuid/uuid.dart';

import '../../controllers/companies_images_controller.dart';
import '../../controllers/companies_security_controller.dart';
import '../../controllers/jobs_controller.dart';
import '../../controllers/jobs_report_controller.dart';
import '../../controllers/jobs_security_controller.dart';
import '../../controllers/login_controller.dart';
import '../../controllers/ping_controller.dart';
import '../../controllers/reset_passwords_controller.dart';
import '../../dao/companies_dao.dart';
import '../../controllers/users_controller.dart';
import '../../controllers/users_security_controller.dart';

import '../../dao/jobs_dao.dart';

import '../../dao/reset_passwords_dao.dart';
import '../../dao/jobs_report_dao.dart';
import '../../dao/users_dao.dart';
import '../../database/db_configuration.dart';
import '../../database/mysql_db_configuration.dart';
import '../../services/auth_service.dart';
import '../../services/companies_service.dart';

import '../../services/jobs_report_service.dart';
import '../../services/jobs_service.dart';
import '../../services/permissions_service.dart';
import '../../services/reset_passwords_service.dart';
import '../../services/users_service.dart';
import '../middlewares/middleware_interception.dart';
import '../security/security_service.dart';
import '../security/security_service_imp.dart';
import 'dependency_injector.dart';

class Injects {
  static DependencyInjector initialize() {
    var di = DependencyInjector();

    di.register<DotEnv>(() => DotEnv(includePlatformEnvironment: true)..load());
    di.register<Uuid>(() => Uuid());
    di.register<MiddlewareInterception>(() => MiddlewareInterception());

    di.register<DBConfiguration>(() => MySqlDbConfiguration());
    di.register(() => CompaniesImageController());
    di.register<JobsReportDAO>(() => JobsReportDAO(di.get<DBConfiguration>()));
    di.register<JobsReportService>(
        () => JobsReportService(di.get<JobsReportDAO>()));
    di.register<JobsReportController>(
        () => JobsReportController(di.get<JobsReportService>()));
    di.register<CompaniesDAO>(() => CompaniesDAO(di.get(), di.get()));
    di.register<CompaniesService>(
        () => CompaniesService(di.get<CompaniesDAO>()));
    di.register<UserDAO>(() => UserDAO(di.get(), di.get<Uuid>()));
    di.register<PermissionService>(() => PermissionService(di.get<UserDAO>()));
    di.register<SecurityService>(
        () => SecurityServiceImp(di.get<PermissionService>()));
    di.register<UsersService>(() => UsersService(di.get<UserDAO>()));
    di.register<UsersController>(() => UsersController(di.get<UsersService>()));
    di.register<UsersSecurityController>(
        () => UsersSecurityController(di.get<UsersService>()));
    di.register<CompaniesSecurityController>(
        () => CompaniesSecurityController(di.get()));
    di.register<AuthService>(() => AuthService(di.get<UsersService>()));
    di.register<LoginController>(() =>
        LoginController(di.get<AuthService>(), di.get<SecurityService>()));
    di.register<PingController>(() => PingController());
    di.register<JobDAO>(
        () => JobDAO(di.get<DBConfiguration>(), di.get<Uuid>()));
    di.register<JobsService>(() => JobsService(di.get<JobDAO>()));
    di.register<JobsController>(() => JobsController(di.get<JobsService>()));
    di.register<JobsSecurityController>(
        () => JobsSecurityController(di.get<JobsService>()));
    di.register<ResetPasswordsDao>(
        () => ResetPasswordsDao(di.get<DBConfiguration>(), di.get<Uuid>()));
    di.register<ResetPasswordsService>(
        () => ResetPasswordsService(di.get<ResetPasswordsDao>()));
    di.register<ResetPasswordsController>(() => ResetPasswordsController(
        di.get<UsersService>(),
        di.get<ResetPasswordsService>(),
        di.get<SecurityService>()));

    return di;
  }
}
