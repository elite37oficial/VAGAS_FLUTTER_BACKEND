import 'dart:convert';

class StatusTO {
  final String? resourceId;
  final int? status;
  String? name;
  int? id;

  StatusTO({this.id, this.resourceId, this.status, this.name});

  factory StatusTO.fromRequest(String body) {
    final Map map = jsonDecode(body);
    return StatusTO(resourceId: map['id'], status: map['status']);
  }

  factory StatusTO.fromJson(Map map) {
    return StatusTO(id: map['id'], status: map['status'], name: map['name']);
  }
}
