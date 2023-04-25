import 'job_model.dart';

class JobSimple extends JobModel {
  @override
  final String id;
  final String title;
  final String companyId;
  final String? regime;
  final String companyName;
  final String state;
  final String city;
  final String modality;
  final String jobStatus;
  final String createdBy;

  JobSimple(
      {required this.companyId,
      required this.companyName,
      required this.id,
      required this.title,
      required this.state,
      required this.regime,
      required this.city,
      required this.modality,
      required this.jobStatus,
      required this.createdBy});

  @override
  Map<String, dynamic> toJson() {
    final result = <String, dynamic>{};
    result.addAll({'status': jobStatus});
    result.addAll({'created_by': createdBy});
    result.addAll({'id': id});
    result.addAll({'state': state});
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
      companyName: map['company_name'],
      regime: map['regime'],
      city: map['city'],
      state: map['state'],
      modality: map['modality'],
      jobStatus: map['status'],
      createdBy: map['created_by'],
    );
  }

  @override
  String toString() {
    return 'JobSimple(id: $id, title: $title, companyName: $companyName, status: $status, createdBy: $createdBy, regime: $regime, city: $city, state: $state, modality: $modality)';
  }
}
