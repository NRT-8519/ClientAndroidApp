import 'dart:ffi';

import 'package:flutter/foundation.dart';

@immutable
class User {
  final String? uuid;
  final String firstName, middleName, lastName;
  final String? title;
  final String? username, password;
  final String email;
  final String phoneNumber;
  final DateTime dateOfBirth;
  final Char gender;
  final String ssn;
  final DateTime passwordExpiryDate;
  final bool isDisabled;
  final bool isExpired;

  const User(this.uuid, this.firstName, this.middleName, this.lastName, this.title, this.username, this.password, this.email, this.phoneNumber, this.dateOfBirth, this.gender, this.ssn, this.passwordExpiryDate, this.isDisabled, this.isExpired);
}