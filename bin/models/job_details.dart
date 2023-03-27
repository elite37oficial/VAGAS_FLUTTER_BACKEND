import 'job_model.dart';

class JobDetails extends JobModel {
  final String? id;
  final String? nameCompany;
  final String? title;
  final String? description;
  final double? salary;
  final String? modality;
  final String? city;
  final String? state;
  final String? link;
  final String? whatsapp;
  final String? email;
  final String photoUrl;
  final String descriptionCompany;
  final String createdBy;

  factory JobDetails.fromJson(Map map) {
    return JobDetails(
      id: map['id'],
      nameCompany: map['name_company'],
      title: map['title'],
      description: map['description'],
      salary: map['salary'],
      photoUrl: map['photo_url'],
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
      'title': title,
      'description': description,
      'photoUrl': photoUrl,
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
    required this.title,
    required this.description,
    required this.salary,
    required this.modality,
    required this.photoUrl,
    required this.descriptionCompany,
    required this.city,
    required this.state,
    required this.link,
    required this.whatsapp,
    required this.email,
    required this.createdBy,
  });
}
