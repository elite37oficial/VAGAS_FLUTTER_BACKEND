class CompanyModel {
  String? id;
  String? name;
  String? location;
  String? photoUrl;
  String? description;
  String? status;
  String? createdBy;
  DateTime? createdDate;
  String? updatedBy;
  DateTime? updatedDate;

  CompanyModel({
    this.id,
    this.name,
    this.location,
    this.photoUrl,
    this.description,
    this.status,
    this.createdBy,
    this.createdDate,
    this.updatedBy,
    this.updatedDate,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    if (id != null) {
      result.addAll({'id': id});
    }
    if (name != null) {
      result.addAll({'name': name});
    }
    if (location != null) {
      result.addAll({'location': location});
    }
    if (photoUrl != null) {
      result.addAll({'photoUrl': photoUrl});
    }
    if (description != null) {
      result.addAll({'description': description});
    }
    if (status != null) {
      result.addAll({'status': status});
    }
    if (createdBy != null) {
      result.addAll({'createdBy': createdBy});
    }
    if (createdDate != null) {
      result.addAll({'createdDate': createdDate!.millisecondsSinceEpoch});
    }
    if (updatedBy != null) {
      result.addAll({'updatedBy': updatedBy});
    }
    if (updatedDate != null) {
      result.addAll({'updatedDate': updatedDate!.millisecondsSinceEpoch});
    }

    return result;
  }

  factory CompanyModel.fromMap(Map<String, dynamic> map) {
    return CompanyModel(
      id: map['id'],
      name: map['name'],
      location: map['location'],
      photoUrl: map['photoUrl'],
      description: map['description'],
      createdBy: map['created_by'],
      createdDate: map['created_date'],
      updatedBy: map['updated_by'],
      updatedDate: map['updated_date'],
    );
  }

  Map toJson() => toMap();

  // factory CompanyModel.fromJson(Map map) =>
  //     CompanyModel.fromMap(map);
}
