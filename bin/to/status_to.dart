import 'dart:convert';

class StatusTO {
  final String id;
  final String status;

  StatusTO({required this.id, required this.status});

  factory StatusTO.fromRequest(String body) {
    final Map map = jsonDecode(body);
    return StatusTO(id: map['id'], status: map['status']);
  }
}
