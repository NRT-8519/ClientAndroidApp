import 'package:flutter/foundation.dart';

import 'user.dart';

@immutable
class Doctor extends User {

  final String areaOfExpertise;
  final int roomNumber;

  final List<String>? patients;

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
      this.patients);
}