import 'package:intl/intl.dart';

class Validators {
  static String? validateName(String? value) {
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
    if (value != null || !value!.isEmpty) {
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
    if (value != null || !value!.isEmpty) {
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
    if (value!.isNotEmpty) {
      if (value.length != 1) {
        return "Select a gender!";
      }
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

  static String? validatePasswordLogin(String? value) {
    if (value != null || !value!.isEmpty) {
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
}