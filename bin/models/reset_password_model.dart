class ResetPasswordModel {
  String? token;
  String? userId;
  DateTime? date;

  ResetPasswordModel({this.token, this.userId, this.date});

  factory ResetPasswordModel.fromJson(Map map) {
    return ResetPasswordModel(
      token: map['token'],
      userId: map['user_id'],
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
      if (date != null) 'date': date?.millisecondsSinceEpoch
    };
  }

  @override
  String toString() {
    return 'ResetPasswordModel(token: $token, userId: $userId, date: $date)';
  }
}
