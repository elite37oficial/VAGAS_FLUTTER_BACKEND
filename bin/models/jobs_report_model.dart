class JobsReportModel {
  final int? id;
  final String jobId;
  final String description;
  final DateTime createdDate;

  JobsReportModel({
    this.id,
    required this.jobId,
    required this.description,
    required this.createdDate,
  });

  factory JobsReportModel.fromRequest(Map map) {
    return JobsReportModel(
      jobId: map['jobId'],
      description: map['description'],
      createdDate: DateTime.now().toUtc(),
    );
  }
}
