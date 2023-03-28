class UserModel {
  String? id;
  String? profileId;
  String? name;
  String? phone;
  String? email;
  String? password;
  int? status;
  String? createdBy;
  late DateTime? createdDate;
  String? changedBy;
  DateTime? changedDate;

  UserModel(
      {this.id,
      this.profileId,
      this.name,
      this.phone,
      this.email,
      this.password,
      this.status,
      this.createdBy,
      this.createdDate,
      this.changedBy,
      this.changedDate}) {
    createdDate = DateTime.now();
  }

  factory UserModel.fromRequest(Map map) {
    return UserModel()
      ..id = map['id']
      ..password = map['password']
      ..profileId = map['profile_id'];
  }

  factory UserModel.fromJson(Map map) {
    return UserModel(
      id: map['id'],
      profileId: map['profile_id'],
      name: map['name'],
      phone: map['phone'],
      email: map['email'],
      password: map['password'],
      status: map['status'],
      createdBy: map['created_by'],
      createdDate: map['created_date'] == null
          ? DateTime.now().toUtc()
          : map['created_date'] is DateTime
              ? map['created_date']
              : DateTime.fromMillisecondsSinceEpoch(map['created_date'],
                  isUtc: true),
      changedBy: map['updated_by'] ?? '',
      changedDate: map['updated_date'] == null
          ? DateTime.now().toUtc()
          : map['updated_date'] is DateTime
              ? map['updated_date']
              : DateTime.fromMillisecondsSinceEpoch(map['updated_date'],
                  isUtc: true),
    );
  }

  Map toJson() {
    return {
      'id': id,
      'profileId': profileId,
      'name': name,
      'phone': phone,
      'email': email,
      'password': password,
      'status': status,
      if (createdBy != null) 'createdBy': createdBy,
      if (createdDate != null)
        'createdDate': createdDate?.millisecondsSinceEpoch,
      if (changedBy != null) 'changedBy': changedBy,
      if (changedDate != null)
        'changedDate': changedDate?.millisecondsSinceEpoch,
    };
  }

  @override
  String toString() {
    return 'UserModel(id: $id, profileId: $profileId, name: $name, phone: $phone, email: $email, password: $password, status: $status, createdBy: $createdBy, createdDate: $createdDate, changedBy: $changedBy, changedDate: $changedDate)';
  }
}
