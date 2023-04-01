class JobModel {
  String? id;
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
  String? status;
  String? state;
  String? createdBy;

  final DateTime? createdDate;
  String? changedBy;
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
    this.status,
    this.state,
    this.createdBy,
    this.createdDate,
    this.changedBy,
    this.changedDate,
  });

  factory JobModel.fromJson(Map map) {
    return JobModel(
      id: map['id'],
      companyId: map['company_id'],
      title: map['title'],
      description: map['description'],
      salary: map['salary'],
      modality: map['modality'],
      seniority: map['seniority'],
      city: map['city'],
      status: map['status'],
      regime: map['regime'],
      link: map['link'],
      whatsappNumber: map['whatsapp'],
      email: map['email'],
      state: map['state'],
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
      'companyId': companyId,
      'title': title,
      'description': description,
      'salary': salary,
      'modality': modality,
      'seniority': seniority,
      'city': city,
      'regime': regime,
      'status': status,
      'link': link,
      'whatsappNumber': whatsappNumber,
      'email': email,
      'state': state,
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
    return 'JobModel(id: $id, companyId: $companyId,status: $status, title: $title, description: $description, salary: $salary, modality: $modality, seniority: $seniority, city: $city, regime: $regime, link: $link, whatsappNumber: $whatsappNumber, email: $email, state? $state, createdBy: $createdBy, createdDate: $createdDate, changedBy: $changedBy, changedDate: $changedDate)';
  }
}
