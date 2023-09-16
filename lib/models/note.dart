import 'dart:convert';

import 'package:intl/intl.dart';

class Note {
  final int id;
  final String doctorUUID;
  final String patientUUID;
  final String noteTitle;
  final String note;
  final DateTime noteDate;

  Note(this.id, this.doctorUUID, this.patientUUID, this.noteTitle, this.note,
      this.noteDate);

  factory Note.fromJson(Map<String, dynamic> parsedJson) {

    DateFormat format = DateFormat("yyyy-MM-ddTHH:mm:ss");

    return Note(
        parsedJson["id"],
        parsedJson["doctorUUID"],
        parsedJson["patientUUID"],
        parsedJson["noteTitle"],
        parsedJson["note"],
        format.parse("${parsedJson["noteDate"]}")
    );
  }

  Map<String, dynamic> toJson() {
    DateFormat format = DateFormat("yyyy-MM-ddTHH:mm:ss");

    return {
      "id": id,
      "doctorUUID": doctorUUID,
      "patientUUID": patientUUID,
      "noteTitle": noteTitle,
      "note": note,
      "noteDate": format.format(noteDate)
    };
  }

  String asJson() {
    return json.encode(toJson());
  }
}