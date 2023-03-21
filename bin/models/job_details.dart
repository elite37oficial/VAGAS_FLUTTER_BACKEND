import 'job_model.dart';

class JobDetails extends JobModel {
  final String? id;
  final String? nomeEmpresa;
  final String? titulo;
  final String? descricao;
  final double? salario;
  final String? modalidade;
  final String? cidade;
  final String? linkVaga;
  final String? whatsapp;
  final String? email;
  final String fotoUrl;
  final String descricaoEmpresa;

  factory JobDetails.fromJson(Map map) {
    return JobDetails(
      id: map['id'],
      nomeEmpresa: map['nameCompany'],
      titulo: map['title'],
      descricao: map['description'],
      salario: map['salary'],
      fotoUrl: map['photoUrl'],
      descricaoEmpresa: map['descriptionCompany'],
      modalidade: map['modality'],
      cidade: map['city'],
      linkVaga: map['link'],
      whatsapp: map['whatsapp'],
      email: map['email'],
    );
  }

  @override
  Map toJson() {
    return {
      'id': id,
      'nome_empresa': nomeEmpresa,
      'titulo': titulo,
      'descricao': descricao,
      'foto_url': fotoUrl,
      'descricao_empresa': descricaoEmpresa,
      'salario': salario,
      'modalidade': modalidade,
      'cidade': cidade,
      'link_vaga': linkVaga,
      'whatsapp': whatsapp,
      'email': email
    };
  }

  JobDetails({
    required this.id,
    required this.nomeEmpresa,
    required this.titulo,
    required this.descricao,
    required this.salario,
    required this.modalidade,
    required this.fotoUrl,
    required this.descricaoEmpresa,
    required this.cidade,
    required this.linkVaga,
    required this.whatsapp,
    required this.email,
  });
}
