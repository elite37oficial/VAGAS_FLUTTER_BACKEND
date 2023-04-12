import '../database/db_configuration.dart';
import '../models/jobs_report_model.dart';

class JobsReportDAO {
  final DBConfiguration _dbConfiguration;

  JobsReportDAO(this._dbConfiguration);

  Future<bool> create(JobsReportModel jobsReportModel) async {
    final result = await _dbConfiguration.execQuery(
      'INSERT INTO jobs_reports (job_id, description, created_date) VALUES (?,?,?);',
      [
        jobsReportModel.jobId,
        jobsReportModel.description,
        jobsReportModel.createdDate
      ],
    );

    return result.affectedRows > 0;
  }
}
