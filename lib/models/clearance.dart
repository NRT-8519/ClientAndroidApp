import 'dart:convert';

import 'package:intl/intl.dart';

class Clearance {
  final String uuid;
  final String clearanceNumber;
  final DateTime beginDate;
  final DateTime expiryDate;

  Clearance(this.uuid, this.clearanceNumber, this.beginDate, this.expiryDate);

  factory Clearance.fromJson(Map<String, dynamic> parsedJson) {
    DateFormat format = DateFormat("yyyy-MM-dd");
    return Clearance(
        parsedJson["uuid"],
        parsedJson["clearanceNumber"],
        format.parse(parsedJson["beginDate"]),
        format.parse(parsedJson["expiryDate"])
    );
  }

  Map<String, dynamic> toJson() {

    DateFormat format = DateFormat("yyyy-MM-dd");

    return {
      "uuid": uuid,
      "clearanceNumber": clearanceNumber,
      "beginDate": format.format(beginDate),
      "expiryDate": format.format(expiryDate)
    };
  }

  String asJson() {
    return json.encode(toJson());
  }
}