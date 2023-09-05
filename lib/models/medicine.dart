import 'dart:convert';

import 'package:client_android_app/models/company.dart';
import 'package:client_android_app/models/issuer.dart';

import 'clearance.dart';

class Medicine {
  final String uuid;
  final String name;
  final String type;
  final String dosage;
  final String dosageType;
  final String ean;
  final String atc;
  final String uniqueClassification;
  final String inn;
  final String prescriptionType;

  final Company company;
  final Issuer issuer;
  final Clearance clearance;

  Medicine(
      this.uuid,
      this.name,
      this.type,
      this.dosage,
      this.dosageType,
      this.ean,
      this.atc,
      this.uniqueClassification,
      this.inn,
      this.prescriptionType,
      this.company,
      this.issuer,
      this.clearance
      );

  factory Medicine.fromJson(Map<String, dynamic> parsedJson) {
    return Medicine(
      parsedJson["uuid"],
      parsedJson["name"],
      parsedJson["type"],
      parsedJson["dosage"],
      parsedJson["dosageType"],
      parsedJson["ean"],
      parsedJson["atc"],
      parsedJson["uniqueClassification"],
      parsedJson["inn"],
      parsedJson["prescriptionType"],
      Company.fromJson(parsedJson["company"]),
      Issuer.fromJson(parsedJson["issuer"]),
      Clearance.fromJson(parsedJson["clearance"])
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "uuid": uuid,
      "name": name,
      "type": type,
      "dosage": dosage,
      "dosageType": dosageType,
      "ean": ean,
      "atc": atc,
      "uniqueClassification": uniqueClassification,
      "inn": inn,
      "prescriptionType": prescriptionType,
      "company": company,
      "issuer": issuer,
      "clearance": clearance
    };
  }

  String asJson() {
    return json.encode(toJson());
  }
}