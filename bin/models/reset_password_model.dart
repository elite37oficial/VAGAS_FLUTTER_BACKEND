class ResetPasswordModel {
  String? token;
  String? userId;
  DateTime? date;
  String? password;
  String? passwordConfirmation;
  String? passwordOld;

  ResetPasswordModel(
      {this.token,
      this.userId,
      this.date,
      this.password,
      this.passwordConfirmation,
      this.passwordOld});

  factory ResetPasswordModel.fromJson(Map map) {
    return ResetPasswordModel(
      token: map['token'],
      userId: map['user_id'],
      password: map['password'],
      passwordConfirmation: map['passwordConfirmation'],
      passwordOld: map['passwordOld'],
      date: map['date'] == null
          ? DateTime.now().toUtc()
          : map['date'] is DateTime
              ? map['date']
              : DateTime.fromMillisecondsSinceEpoch(map['date'], isUtc: true),
    );
  }

  Map toJson() {
    return {
      'token': token,
      'userId': userId,
      'password': password,
      'passwordConfirmation': passwordConfirmation,
      'passwordOld': passwordOld,
      if (date != null) 'date': date?.millisecondsSinceEpoch
    };
  }

  @override
  String toString() {
    return 'ResetPasswordModel(token: $token, userId: $userId, password: $password, passwordConfirmation: $passwordConfirmation, passwordOld: $passwordOld, date: $date)';
  }
}
