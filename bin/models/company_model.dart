class CompanyModel {
  String? id;
  String? name;
  String? location;
  String? description;
  int? status;
  String? createdBy;
  DateTime? createdDate;
  String? updatedBy;
  DateTime? updatedDate;

  CompanyModel({
    this.id,
    this.name,
    this.location,
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
      description: map['description'],
      createdBy: map['created_by'],
      createdDate: map['created_date'].toLocal(),
      updatedBy: map['updated_by'],
      updatedDate: (map['updated_date']).toLocal(),
    );
  }

  Map toJson() => toMap();
}
