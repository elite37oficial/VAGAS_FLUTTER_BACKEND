class AdminModel {
  final int? id;
  final String nome;
  final String telefone;
  final String email;
  final String password;
  final String createdBy;
  late DateTime createdDate;
  final String? changedBy;
  final DateTime? changedDate;

  AdminModel(
      {this.id,
      required this.nome,
      required this.telefone,
      required this.email,
      required this.password,
      required this.createdBy,
      this.changedBy,
      this.changedDate}) {
    createdDate = DateTime.now();
  }
}
