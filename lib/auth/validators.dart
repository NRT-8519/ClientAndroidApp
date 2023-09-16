import 'package:intl/intl.dart';

class Validators {
  static String? validateNotEmpty(String? value) {
    if (value == null || value.isEmpty) {
      return "Required";
    }
      return null;
  }

  static String? validateTitle(String? value) {
    if (value!.length > 30) {
      return "Maximum length for a title is 30 characters!";
    }
    return null;
  }

  static String? validateUsername(String? value) {
    if (value != null || value!.isNotEmpty) {
      if (value.length < 6 || value.length > 30) {
        return "Username length is between 6 and 30 characters!";
      }
    }
    else {
      return "Username is required!";
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value != null || value!.isNotEmpty) {
      if (value.length > 50) {
        return "Maximum length for an email is 50 characters!";
      }
      else {
        final RegExp emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
        if (!emailRegex.hasMatch(value)) {
          return "Please provide a valid email address!";
        }
      }
    }
    else {
      return "Email is required!";
    }
    return null;
  }

  static String? validatePhoneNumber(String? value) {
    if (value != null || value!.isNotEmpty) {
      if (value.length > 13) {
        return "Maximum length for an phone number is 13 characters!";
      }
      else {
        final RegExp phoneNumberRegex = RegExp(r"\+[1-9][0-9]{2}[0-9]{8,9}$");
        if (!phoneNumberRegex.hasMatch(value)) {
          return "Please provide a valid phone number!";
        }
      }
    }
    else {
      return "Phone number is required!";
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value!.isNotEmpty) {
      if (value.length < 8 || value.length > 45) {
        return "Password must be between 8 and 45 characters!";
      }
    }
    return null;
  }

  static String? validateGender(String? value) {
    if (value!.isEmpty) {
      return "Select a gender!";
    }
    return null;
  }

  static String? validateDateOfBirth(String? value) {
    if (value!.isNotEmpty) {
      DateFormat formatter = DateFormat("dd/MM/yyyy");
      DateTime date = formatter.parse(value);
      if (date.compareTo(DateTime.now()) > 0) {
        return "Date of birth cannot be later than today!";
      }
      else if (date.compareTo(DateTime(1901)) < 0) {
        return "Date of birth cannot be older than 1901!";
      }
    }
    else {
      return "Please provide a date of birth";
    }
    return null;
  }

  static String? validateBeginDate(String? value) {
    if (value!.isNotEmpty) {
      DateFormat formatter = DateFormat("dd/MM/yyyy");
      DateTime date = formatter.parse(value);
      if (date.compareTo(DateTime(1901)) < 0) {
        return "Date cannot be older than 1901!";
      }
    }
    else {
      return "Please provide a begin date";
    }
    return null;
  }

  static String? validateAppointmentDate(String? value) {
    if (value!.isNotEmpty) {
      DateFormat formatter = DateFormat("dd/MM/yyyy");
      DateTime date = formatter.parse(value);
      if (date.compareTo(DateTime(1901)) < 0) {
        return "Date cannot be older than today!";
      }
    }
    else {
      return "Please provide a date";
    }
    return null;
  }

  static String? validateAppointmentTime(String? value) {
    if (value!.isEmpty) {
      return "Please provide a date";
    }
    return null;
  }

  static String? validateExpiryDate(String? value) {
    if (value!.isNotEmpty) {
      DateFormat formatter = DateFormat("dd/MM/yyyy");
      DateTime date = formatter.parse(value);
      if (date.compareTo(DateTime(1901)) < 0) {
        return "Date cannot be older than 1901!";
      }
    }
    else {
      return "Please provide a expiry date";
    }
    return null;
  }

  static String? validatePasswordLogin(String? value) {
    if (value != null || value!.isNotEmpty) {
      if (value.length < 8 || value.length > 45) {
        return "Password must be between 8 and 45 characters!";
      }
    }
    else {
      return "Password is required!";
    }
    return null;
  }

  static String? validateSSN(String? value) {
    if (value != null || value!.isNotEmpty) {
      if (value.length != 13) {
        return "Social Security Number is 13 digits long!";
      }
      else {
        final digits = RegExp(r"[0-9]{13}");
        if(!digits.hasMatch(value)) {
          return "SSN Contains only digits!";
        }
      }
    }
    else {
      return "SSN is required!";
    }
    return null;
  }

  static String? validateClearanceNumber(String? value) {
    if (value != null || value!.isNotEmpty) {
      if (value.length != 19) {
        return "Clearance Number is 19 digits and dashes long!";
      }
      else {
        final digits = RegExp(r"515-01-0[0-9]{4}-[0-9]{2}-[0-9]{3}");
        if(!digits.hasMatch(value)) {
          return "Clearance Number starts with 515-01-0\nIt is in the following format: 515-01-01234-56-789!";
        }
      }
    }
    else {
      return "Clearance Number is required!";
    }
    return null;
  }

  static String? validateATC(String? value) {
    if (value != null || value!.isNotEmpty) {
      if (value.length != 7) {
        return "ATC is 7 characters long!";
      }
      else {
        final digits = RegExp(r"(^[ABCDGHJLMNPRSV][0-1][0-9][A-Z]{2}[0-9]{2})?");
        if(!digits.hasMatch(value)) {
          return "Invalid ATC.\nExample of a valid ATC: A10BA02 or empty";
        }
      }
    }
    else {
      return "ATC is required!";
    }
    return null;
  }

  static String? validateEAN(String? value) {
    if (value != null || value!.isNotEmpty) {
      if (value.length != 13) {
        return "EAN is 13 digits long!";
      }
      else {
        final digits = RegExp(r"^[0-9]{13}$");
        if(!digits.hasMatch(value)) {
          return "Invalid EAN.\nEAN is 13 digits long";
        }
      }
    }
    else {
      return "EAN is required!";
    }
    return null;
  }

  static String? validateRoomNumber(String? value) {
    if (value!.isNotEmpty) {
      if (int.parse(value) < 100 || int.parse(value) > 999) {
        return "Room number must be between 100 and 999";
      }
    }
    else if (value.isEmpty) {
      return "Room number is required!";
    }
    return null;
  }


}