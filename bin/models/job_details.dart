import 'job_model.dart';

class JobDetails extends JobModel {
  final String? id;
  final String? empresa_Id;
  final String? titulo;
  final String? descricao;
  final double? salario;
  final String? modalidade;
  final String? cidade;
  final String? link_vaga;
  final String? whatsapp;
  final String? email;

  factory JobDetails.fromJson(Map map) {
    return JobDetails(
      id: map['id'],
      empresa_Id: map['companyId'],
      titulo: map['title'],
      descricao: map['description'],
      salario: map['salary'],
      modalidade: map['location'],
      cidade: map['city'],
      link_vaga: map['link'],
      whatsapp: map['whatsapp'],
      email: map['email'],
    );
  }

  @override
  Map toJson() {
    return {
      'id': id,
      'empresa_id': empresa_Id,
      'titulo': titulo,
      'descricao': descricao,
      'salario': salario,
      'modalidade': modalidade,
      'cidade': cidade,
      'link_vaga': link_vaga,
      'whatsapp': whatsapp,
      'email': email
    };
  }

  JobDetails({
    required this.id,
    required this.empresa_Id,
    required this.titulo,
    required this.descricao,
    required this.salario,
    required this.modalidade,
    required this.cidade,
    required this.link_vaga,
    required this.whatsapp,
    required this.email,
  });
}
