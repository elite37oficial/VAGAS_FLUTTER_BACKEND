import '../dao/jobs_report_dao.dart';
import '../models/jobs_report_model.dart';

class JobsReportService {
  final JobsReportDAO _jobsReportDAO;
  JobsReportService(this._jobsReportDAO);

  Future<bool> create(JobsReportModel jobsReportModel) async {
    return await _jobsReportDAO.create(jobsReportModel);
  }
}
