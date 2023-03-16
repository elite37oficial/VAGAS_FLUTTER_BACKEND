class JobModel {
  final String? id;
  final String companyId;
  final String title;
  final String description;
  final double salary;
  final String local;
  final String seniority;
  final String regime;
  final String link;
  final String whatsappNumber;
  final String email;
  final String createdBy;
  final DateTime createdDate;
  final String changedBy;
  final DateTime? changedDate;

  JobModel({
    this.id,
    required this.companyId,
    required this.title,
    required this.description,
    required this.salary,
    required this.local,
    required this.seniority,
    required this.regime,
    required this.link,
    required this.whatsappNumber,
    required this.email,
    required this.createdBy,
    required this.createdDate,
    required this.changedBy,
    this.changedDate,
  });

  factory JobModel.fromJson(Map map) {
    return JobModel(
      id: map['id'] ?? '',
      companyId: map['companyId'],
      title: map['title'],
      description: map['description'],
      salary: map['salary'],
      local: map['location'],
      seniority: map['seniority'],
      regime: map['regime'],
      link: map['link'],
      whatsappNumber: map['whatsapp'],
      email: map['email'],
      createdBy: map['createdBy'],
      createdDate: map['createdDate'],
      changedBy: map['updatedBy'] ?? '',
      changedDate: map['updatedDate'] ?? DateTime.now(),
    );
  }

  Map toJson() {
    return {
      'id': id,
      'companyId': companyId,
      'title': title,
      'description': description,
      'salary': salary,
      'local': local,
      'seniority': seniority,
      'regime': regime,
      'link': link,
      'whatsappNumber': whatsappNumber,
      'email': email,
      'createdBy': createdBy,
      'createdDate': createdDate.millisecondsSinceEpoch,
      'changedBy': changedBy,
      'changedDate': changedDate?.millisecondsSinceEpoch,
    };
  }

  @override
  String toString() {
    return 'JobModel(id: $id, companyId: $companyId, title: $title, description: $description, salary: $salary, local: $local, seniority: $seniority, regime: $regime, link: $link, whatsappNumber: $whatsappNumber, email: $email, createdBy: $createdBy, createdDate: $createdDate, changedBy: $changedBy, changedDate: $changedDate)';
  }
}
