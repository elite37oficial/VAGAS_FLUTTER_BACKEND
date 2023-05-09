import 'job_model.dart';

class JobDetails extends JobModel {
  final String? id;
  final String? companyId;
  final String? nameCompany;
  final String? title;
  final String? description;
  final num? salary;
  final String? modality;
  final String? city;
  final String? state;
  final String? link;
  final String? regime;
  final String? whatsapp;
  final String? email;
  final String? statusJob;
  final String? seniority;
  final String? descriptionCompany;
  final String? createdBy;

  factory JobDetails.fromJson(Map map) {
    return JobDetails(
      id: map['id'],
      companyId: map['company_id'],
      nameCompany: map['name_company'],
      statusJob: map['status'],
      title: map['title'],
      description: map['description'],
      regime: map['regime'],
      salary: map['salary'],
      seniority: map['seniority'],
      descriptionCompany: map['description_company'],
      modality: map['modality'],
      city: map['city'],
      state: map['state'],
      link: map['link'],
      whatsapp: map['whatsapp'],
      email: map['email'],
      createdBy: map['created_by'],
    );
  }

  @override
  Map toJson() {
    return {
      'id': id,
      'nameCompany': nameCompany,
      'companyId': companyId,
      'status': statusJob,
      'title': title,
      'description': description,
      'regime': regime,
      'seniority': seniority,
      'descriptionCompany': descriptionCompany,
      'salary': salary,
      'modality': modality,
      'city': city,
      'state': state,
      'link': link,
      'whatsapp': whatsapp,
      'email': email,
      'createdBy': createdBy
    };
  }

  JobDetails({
    required this.id,
    required this.nameCompany,
    required this.companyId,
    this.statusJob,
    required this.title,
    required this.description,
    required this.salary,
    required this.modality,
    this.seniority,
    this.regime,
    required this.descriptionCompany,
    required this.city,
    required this.state,
    required this.link,
    required this.whatsapp,
    required this.email,
    required this.createdBy,
  });
}
