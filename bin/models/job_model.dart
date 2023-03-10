class JobModel {
  final int? id;
  final int companyId;
  final String title;
  final String description;
  final double salary;
  final String local;
  final String seniority;
  final String regime;
  final String link;
  final String whatsappNumber;
  final String email;
  final String createdBy;
  final DateTime createdDate;
  final String changedBy;
  final DateTime changedDate;

  JobModel({
    this.id,
    required this.companyId,
    required this.title,
    required this.description,
    required this.salary,
    required this.local,
    required this.seniority,
    required this.regime,
    required this.link,
    required this.whatsappNumber,
    required this.email,
    required this.createdBy,
    required this.createdDate,
    required this.changedBy,
    required this.changedDate,
  });
}
