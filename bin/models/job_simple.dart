import 'job_model.dart';

class JobSimple extends JobModel {
  @override
  final String id;
  final String titulo;
  final String urlFoto;
  final String cidade;
  final String modalidade;

  JobSimple({
    required this.id,
    required this.titulo,
    required this.urlFoto,
    required this.cidade,
    required this.modalidade,
  });

  @override
  Map<String, dynamic> toJson() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'titulo': titulo});
    result.addAll({'url_foto': urlFoto});
    result.addAll({'cidade': cidade});
    result.addAll({'modalidade': modalidade});

    return result;
  }

  factory JobSimple.fromJson(Map<String, dynamic> map) {
    return JobSimple(
      id: map['id'] ?? '',
      titulo: map['title'] ?? '',
      urlFoto: map['photoUrl'] ?? '',
      cidade: map['city'] ?? '',
      modalidade: map['modality'] ?? '',
    );
  }

  @override
  String toString() {
    return 'JobSimple(id: $id, titulo: $titulo, url_foto: $urlFoto, cidade: $cidade, modalidade: $modalidade)';
  }
}
