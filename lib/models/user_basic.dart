import 'dart:convert';

import 'package:intl/intl.dart';

class UserBasic {
  final String? uuid;
  final String firstName, middleName, lastName;
  final String? username;
  final String email;

  UserBasic(this.uuid, this.firstName, this.middleName, this.lastName, this.username, this.email);

  factory UserBasic.fromJson(Map<String, dynamic> parsedJson) {
    return UserBasic(
        parsedJson["uuid"],
        parsedJson["firstName"],
        parsedJson["middleName"],
        parsedJson["lastName"],
        parsedJson["username"],
        parsedJson["email"]
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "uuid": uuid,
      "firstName": firstName,
      "middleName": middleName,
      "lastName": lastName,
      "username": username,
      "email": email
    };
  }
}