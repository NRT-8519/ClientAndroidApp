import 'dart:convert';

import 'package:intl/intl.dart';

class Request {
  final String uuid;
  final String doctor;
  final String patient;
  final String title;
  final String description;
  final String type;
  final String status;
  final String reason;
  final DateTime requestDate;

  Request(this.uuid, this.doctor, this.patient, this.title, this.description, this.type, this.status, this.reason, this.requestDate);

  factory Request.fromJson(Map<String, dynamic> parsedJson) {

    DateFormat format = DateFormat("yyyy-MM-ddTHH:mm:ss");

    return Request(
        parsedJson["uuid"],
        parsedJson["doctor"],
        parsedJson["patient"],
        parsedJson["title"],
        parsedJson["description"],
        parsedJson["type"],
        parsedJson["status"],
        parsedJson["reason"],
        format.parse("${parsedJson["requestDate"]}")
    );
  }

  Map<String, dynamic> toJson() {
    DateFormat format = DateFormat("yyyy-MM-dd");

    return {
      "uuid": uuid,
      "doctor": doctor,
      "patient": patient,
      "title": title,
      "description": description,
      "type": type,
      "status": status,
      "reason": reason,
      "requestDate": format.format(requestDate)
    };
  }

  String asJson() {
    return json.encode(toJson());
  }
}