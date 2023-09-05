import 'dart:convert';

import 'package:intl/intl.dart';

class Report {
  final String uuid;
  final String reportedBy;
  final String title;
  final String description;
  final DateTime date;

  Report(this.uuid, this.reportedBy, this.title, this.description, this.date);

  factory Report.fromJson(Map<String, dynamic> parsedJson) {

    DateFormat format = DateFormat("yyyy-MM-ddTHH:mm:ss");

    return Report(
        parsedJson["uuid"],
        parsedJson["reportedBy"],
        parsedJson["title"],
        parsedJson["description"],
        format.parse("${parsedJson["date"]}")
    );
  }

  Map<String, dynamic> toJson() {
    DateFormat format = DateFormat("yyyy-MM-dd");

    return {
      "uuid": uuid,
      "reportedBy": reportedBy,
      "title": title,
      "description": description,
      "date": format.format(date)
    };
  }

  String asJson() {
    return json.encode(toJson());
  }
}