import 'job_model.dart';

class JobSimple extends JobModel {
  @override
  final String id;
  final String title;
  final String photoUrl;
  final String city;
  final String modality;

  JobSimple({
    required this.id,
    required this.title,
    required this.photoUrl,
    required this.city,
    required this.modality,
  });

  @override
  Map<String, dynamic> toJson() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'title': title});
    result.addAll({'photoUrl': photoUrl});
    result.addAll({'city': city});
    result.addAll({'modality': modality});

    return result;
  }

  factory JobSimple.fromJson(Map<String, dynamic> map) {
    return JobSimple(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      photoUrl: map['photo_url'] ?? '',
      city: map['city'] ?? '',
      modality: map['modality'] ?? '',
    );
  }

  @override
  String toString() {
    return 'JobSimple(id: $id, title: $title, photoUrl: $photoUrl, city: $city, modality: $modality)';
  }
}
