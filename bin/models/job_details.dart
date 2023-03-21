import 'job_model.dart';

class JobDetails extends JobModel {
  final String? id;
  final String? companyId;
  final String? title;
  final String? description;
  final double? salary;
  final String? local;
  final String? seniority;
  final String? city;
  final String? regime;
  final String? link;
  final String? whatsappNumber;
  final String? email;

  factory JobDetails.fromJson(Map map) {
    return JobDetails(
      id: map['id'],
      companyId: map['companyId'],
      title: map['title'],
      description: map['description'],
      salary: map['salary'],
      local: map['location'],
      city: map['city'],
      seniority: map['seniority'],
      regime: map['regime'],
      link: map['link'],
      whatsappNumber: map['whatsapp'],
      email: map['email'],
    );
  }

  JobDetails({
    required this.id,
    required this.companyId,
    required this.title,
    required this.description,
    required this.salary,
    required this.local,
    required this.seniority,
    required this.city,
    required this.regime,
    required this.link,
    required this.whatsappNumber,
    required this.email,
  });
}
