import 'package:client_android_app/models/user.dart';
import 'package:client_android_app/models/user_basic.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

@immutable
class Patient extends User {

  final UserBasic assignedDoctor;

  const Patient(
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
      this.assignedDoctor);

  @override
  factory Patient.fromJson(Map<String, dynamic> parsedJson) {
    return Patient(
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
        UserBasic.fromJson(parsedJson["assignedDoctor"])
    );
  }

  @override
  Map<String, dynamic> toJson() {

    DateFormat dateOfBirthFormat = DateFormat("yyyy-MM-dd");
    DateFormat passwordExpiryDateFormat = DateFormat("yyyy-MM-ddTHH:mm:ss.SSS");

    return {
      "uuid": uuid,
      "firstName": firstName,
      "middleName": middleName,
      "lastName": lastName,
      "title": title,
      "username": username,
      "password": password,
      "email": email,
      "phoneNumber": phoneNumber,
      "dateOfBirth": dateOfBirthFormat.format(dateOfBirth),
      "gender": gender,
      "ssn": ssn,
      "passwordExpiryDate": "${passwordExpiryDateFormat.format(passwordExpiryDate)}Z",
      "isDisabled": isDisabled,
      "isExpired": isExpired,
      "assignedDoctor": assignedDoctor
    };
  }
}