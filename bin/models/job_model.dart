class JobModel {
  final String? id;
  final String? companyId;
  final String? title;
  final String? description;
  final double? salary;
  final String? modality;
  final String? seniority;
  final String? city;
  final String? regime;
  final String? link;
  final String? whatsappNumber;
  final String? email;
  final String? createdBy;
  final DateTime? createdDate;
  final String? changedBy;
  final DateTime? changedDate;

  JobModel({
    this.id,
    this.companyId,
    this.title,
    this.description,
    this.salary,
    this.modality,
    this.seniority,
    this.city,
    this.regime,
    this.link,
    this.whatsappNumber,
    this.email,
    this.createdBy,
    this.createdDate,
    this.changedBy,
    this.changedDate,
  });

  factory JobModel.fromJson(Map map) {
    return JobModel(
      id: map['id'],
      companyId: map['companyId'],
      title: map['title'],
      description: map['description'],
      salary: map['salary'],
      modality: map['location'],
      seniority: map['seniority'],
      city: map['city'],
      regime: map['regime'],
      link: map['link'],
      whatsappNumber: map['whatsapp'],
      email: map['email'],
      createdBy: map['createdBy'],
      createdDate: map['createdDate'] == null
          ? DateTime.now().toUtc()
          : map['createdDate'] is DateTime
              ? map['createdDate']
              : DateTime.fromMillisecondsSinceEpoch(map['createdDate'],
                  isUtc: true),
      changedBy: map['updatedBy'] ?? '',
      changedDate: map['updatedDate'] == null
          ? DateTime.now().toUtc()
          : map['updatedDate'] is DateTime
              ? map['updatedDate']
              : DateTime.fromMillisecondsSinceEpoch(map['updatedDate'],
                  isUtc: true),
    );
  }

  Map toJson() {
    return {
      'id': id,
      'companyId': companyId,
      'title': title,
      'description': description,
      'salary': salary,
      'modality': modality,
      'seniority': seniority,
      'city': city,
      'regime': regime,
      'link': link,
      'whatsappNumber': whatsappNumber,
      'email': email,
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
    return 'JobModel(id: $id, companyId: $companyId, title: $title, description: $description, salary: $salary, modality: $modality, seniority: $seniority, city: $city, regime: $regime, link: $link, whatsappNumber: $whatsappNumber, email: $email, createdBy: $createdBy, createdDate: $createdDate, changedBy: $changedBy, changedDate: $changedDate)';
  }
}
