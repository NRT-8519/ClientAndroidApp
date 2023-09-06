import 'dart:convert';

import 'package:intl/intl.dart';

class Appointment {
  static DateFormat format = DateFormat("yyyy-MM-ddTHH:mm:ss");

  final int id;
  final String doctorUUID, patientUUID;
  final DateTime scheduledDateTime;
  final String event;

  Appointment(this.id, this.doctorUUID, this.patientUUID,
      this.scheduledDateTime, this.event);

  factory Appointment.fromJson(Map<String, dynamic> parsedJson) {
    return Appointment(
        parsedJson["id"],
        parsedJson["doctorUUID"],
        parsedJson["patientUUID"],
        format.parse(parsedJson["scheduledDateTime"]),
        parsedJson["event"]);
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "doctorUUID": doctorUUID,
      "patientUUID": patientUUID,
      "scheduledDateTime": scheduledDateTime,
      "event": event
    };
  }

  String asJson() {
    return json.encode(toJson());
  }
}