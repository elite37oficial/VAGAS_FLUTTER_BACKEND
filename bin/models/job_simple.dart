import 'job_model.dart';

class JobSimple extends JobModel {
  @override
  final String id;
  final String title;
  final String companyId;
  final String? regime;
  final String companyName;
  final String city;
  final String modality;

  JobSimple({
    required this.companyId,
    required this.companyName,
    required this.id,
    required this.title,
    required this.regime,
    required this.city,
    required this.modality,
  });

  @override
  Map<String, dynamic> toJson() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'title': title});
    result.addAll({'companyName': companyName});
    result.addAll({'companyId': companyId});
    result.addAll({'regime': regime});
    result.addAll({'city': city});
    result.addAll({'modality': modality});

    return result;
  }

  factory JobSimple.fromJson(Map<String, dynamic> map) {
    return JobSimple(
      id: map['id'],
      title: map['title'],
      companyId: map['company_id'],
      companyName: map['name_company'],
      regime: map['regime'],
      city: map['city'],
      modality: map['modality'],
    );
  }

  @override
  String toString() {
    return 'JobSimple(id: $id, title: $title,companyName: $companyName,regime: $regime, city: $city, modality: $modality)';
  }
}
