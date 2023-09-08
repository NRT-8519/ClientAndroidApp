import 'dart:convert';

import 'package:intl/intl.dart';

class Prescription {
  final int id;
  final String? doctor;
  final String? patient;
  final String? medicine;
  final DateTime? prescribed;
  final DateTime? administered;
  final String? notes;

  Prescription(this.id, this.doctor, this.patient, this.medicine, this.prescribed,
      this.administered, this.notes);

  factory Prescription.fromJson(Map<String, dynamic> parsedJson) {

    DateFormat format = DateFormat("yyyy-MM-dd");

    return Prescription(
      parsedJson["id"],
      parsedJson["doctor"],
      parsedJson["patient"],
      parsedJson["medicine"],
      parsedJson["prescribed"] == null ? null : format.parse("${parsedJson["prescribed"]}"),
      parsedJson["administered"] == null ? null : format.parse("${parsedJson["administered"]}"),
      parsedJson["notes"],
    );
  }

  Map<String, dynamic> toJson() {
    DateFormat format = DateFormat("yyyy-MM-dd");

    return {
      "id": id,
      "doctor": doctor,
      "patient": patient,
      "medicine": medicine,
      "prescribed": prescribed == null ? null : format.format(prescribed!),
      "administered": administered == null ? null : format.format(administered!),
      "notes" : notes
    };
  }

  String asJson() {
    return json.encode(toJson());
  }
}