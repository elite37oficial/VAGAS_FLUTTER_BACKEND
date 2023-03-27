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
  final String descriptionEmpresa;

  factory JobDetails.fromJson(Map map) {
    return JobDetails(
      id: map['id'],
      nameCompany: map['name_company'],
      title: map['title'],
      description: map['description'],
      salary: map['salary'],
      photoUrl: map['photo_url'],
      descriptionEmpresa: map['description_company'],
      modality: map['modality'],
      city: map['city'],
      state: map['state'],
      link: map['link'],
      whatsapp: map['whatsapp'],
      email: map['email'],
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
      'descriptionEmpresa': descriptionEmpresa,
      'salary': salary,
      'modality': modality,
      'city': city,
      'state': state,
      'link': link,
      'whatsapp': whatsapp,
      'email': email
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
    required this.descriptionEmpresa,
    required this.city,
    required this.state,
    required this.link,
    required this.whatsapp,
    required this.email,
  });
}
