import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

@immutable
class User {
  final String? uuid;
  final String firstName, middleName, lastName;
  final String? title;
  final String? username;
  final String? password;
  final String email;
  final String phoneNumber;
  final DateTime dateOfBirth;
  final String gender; //Dart does not support char type
  final String ssn;
  final DateTime passwordExpiryDate;
  final bool isDisabled;
  final bool isExpired;

  const User(
      this.uuid,
      this.firstName,
      this.middleName,
      this.lastName,
      this.title,
      this.username,
      this.password,
      this.email,
      this.phoneNumber,
      this.dateOfBirth,
      this.gender,
      this.ssn,
      this.passwordExpiryDate,
      this.isDisabled,
      this.isExpired);


  factory User.fromJson(Map<String, dynamic> parsedJson) {
    return User(
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
      parsedJson["isExpired"]
    );
  }

  String asJson() {

    DateFormat dateOfBirthFormat = DateFormat("yyyy-MM-dd");
    DateFormat passwordExpiryDateFormat = DateFormat("yyyy-MM-ddTHH:mm:ss.SSS");

    return json.encode({
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
      "isExpired": isExpired
    });
  }
}