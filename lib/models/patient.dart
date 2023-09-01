import 'package:client_android_app/models/user.dart';
import 'package:flutter/foundation.dart';

@immutable
class Patient extends User {

  final User assignedDoctor;

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
}