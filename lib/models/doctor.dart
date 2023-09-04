import 'dart:convert';

import 'package:client_android_app/models/patient.dart';
import 'package:client_android_app/models/user_basic.dart';
import 'package:flutter/foundation.dart';

import 'user.dart';

@immutable
class Doctor extends User {

  final String areaOfExpertise;
  final int roomNumber;

  final List<UserBasic> patients;

  const Doctor(
      super.uuid,
      super.firstName,
      super.middleName,
      super.lastName,
      super.title,
      super.username,
      super.password,
      super.email,
      super.phoneNumber,
      super.dateOfBirth,
      super.gender,
      super.ssn,
      super.passwordExpiryDate,
      super.isDisabled,
      super.isExpired,
      this.areaOfExpertise,
      this.roomNumber,
      this.patients
      );

  @override
  factory Doctor.fromJson(Map<String, dynamic> parsedJson) {
    List<dynamic> list = parsedJson["patients"];
    List<UserBasic> patients = [];
    if (list.isNotEmpty) {
      for (dynamic p in list) {
        UserBasic patient = UserBasic.fromJson(p);
        patients.add(patient);
      }
    }

    return Doctor(
        parsedJson["uuid"],
        parsedJson["firstName"],
        parsedJson["middleName"],
        parsedJson["lastName"],
        parsedJson["title"],
        parsedJson["username"],
        parsedJson["password"],
        parsedJson["email"],
        parsedJson["phoneNumber"],
        DateTime.parse(parsedJson["dateOfBirth"]),
        parsedJson["gender"][0],
        parsedJson["ssn"],
        DateTime.parse(parsedJson["passwordExpiryDate"]),
        parsedJson["isDisabled"],
        parsedJson["isExpired"],
        parsedJson["areaOfExpertise"],
        parsedJson["roomNumber"],
        patients
    );
  }
}