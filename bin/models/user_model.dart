class UserModel {
  final String? id;
  final String? profileId;
  final String? name;
  final String? phone;
  final String? email;
  final String? password;
  final String? createdBy;
  late DateTime? createdDate;
  final String? changedBy;
  final DateTime? changedDate;

  UserModel(
      {this.id,
      this.profileId,
      this.name,
      this.phone,
      this.email,
      this.password,
      this.createdBy,
      this.createdDate,
      this.changedBy,
      this.changedDate}) {
    createdDate = DateTime.now();
  }

  factory UserModel.fromJson(Map map) {
    return UserModel(
      id: map['id'],
      profileId: map['profile_id'],
      name: map['name'],
      phone: map['phone'],
      email: map['email'],
      password: map['password'],
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
    return 'UserModel(id: $id, profileId: $profileId, name: $name, phone: $phone, email: $email, password: $password, createdBy: $createdBy, createdDate: $createdDate, changedBy: $changedBy, changedDate: $changedDate)';
  }
}
