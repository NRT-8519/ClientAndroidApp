import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:client_android_app/models/Note.dart';
import 'package:client_android_app/models/appointment.dart';
import 'package:client_android_app/models/issuer.dart';
import 'package:client_android_app/models/paginated_list.dart';
import 'package:client_android_app/models/patient.dart';
import 'package:client_android_app/models/medicine.dart';
import 'package:client_android_app/models/prescription.dart';
import 'package:client_android_app/models/report.dart';
import 'package:client_android_app/models/request.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../models/company.dart';
import '../models/doctor.dart';
import '../models/user.dart';

const SERVER = "https://10.0.2.2:7215";
const STORAGE = FlutterSecureStorage();

class HttpRequests {

  static var authentication = const __Authentication();
  static var administrator = const __Administrator();
  static var doctor = const __Doctor();
  static var patient = const __Patient();
  static var medicine = const __Medicine();
  static var company = const __Company();
  static var issuer = const __Issuer();
  static var report = const __Report();
  static var request = const __Request();
  static var prescription = const __Prescription();
  static var appointment = const __Appointment();
  static var notes = const __Notes();
}

class __Authentication {
  const __Authentication();

  Future<http.Response?> authenticate(String username, String password) async {
    final body = json.encode({
      "username": username,
      "password": password
    });

    try {
      http.Response result = await http.post(
          Uri.parse("$SERVER/api/users/authenticate/"),
          headers: {
            "accept": "*/*",
            "content-type": "application/json; charset=utf-8",
          },
          body: body).timeout(const Duration(seconds: 10));

      return result;
    } on TimeoutException catch (_) {
      return null;
    } on SocketException catch (_) {
      return null;
    }
  }
}

class __Administrator {
  const __Administrator();
  Future<PaginatedList<User>?> getPaged(String? sortOrder, String searchString, String currentFilter, int? pageNumber, int pageSize) async {
    Map<String, String> headers = HashMap<String, String>();
    headers.addAll({
      "accept": "*/*",
      "Authorization": "Bearer ${await STORAGE.read(key: "token")}"
    });
    http.Response result = await http.get(Uri.parse("$SERVER/api/users/all/basic?sortOrder=$sortOrder&searchString=$searchString&currentFilter=$currentFilter&pageNumber=$pageNumber&pageSize=$pageSize"), headers: headers);

    if (result.statusCode == 200) {
      Map<String, dynamic> body = json.decode(result.body);
      List<dynamic> dynamicList = body["items"];
      List<User> list = [];
      if (dynamicList.isNotEmpty) {
        for (dynamic i in dynamicList) {
          User user = User.fromJson(i);
          list.add(user);
        }
      }
      return PaginatedList(list, body["pageNumber"], body["pageSize"], body["totalPages"], body["totalItems"], body["hasPrevious"], body["hasNext"]);
    }
    else {
      List<User> list = [];
      return PaginatedList(list, 1, 10, 0, 0, false, false);
    }
  }
  
  Future<int> getCount() async {
    Map<String, String> headers = HashMap<String, String>();
    headers.addAll({
      "accept": "*/*",
      "Authorization": "Bearer ${await STORAGE.read(key: "token")}"
    });

    http.Response result = await http.get(
        Uri.parse("$SERVER/api/users/administrators/count/"),
        headers: headers
    );

    if (result.statusCode == 200) {
      int count = int.parse(result.body);
      return count;
    }
    else {
      return -1;
    }
  }

  Future<User> get(String uuid) async {
    Map<String, String> headers = HashMap<String, String>();
    headers.addAll({
      "accept": "*/*",
      "Authorization": "Bearer ${await STORAGE.read(key: "token")}"
    });
    http.Response result = await http.get(
        Uri.parse("$SERVER/api/users/$uuid"),
        headers: headers
    );

    final Map<String, dynamic> parsed = json.decode(result.body);

    final User user = User.fromJson(parsed);

    return user;
  }

  Future<http.Response> post(User user) async {
    Map<String, String> headers = HashMap<String, String>();
    headers.addAll({
      "accept": "*/*",
      "Content-Type": "application/json",
      "Authorization": "Bearer ${await STORAGE.read(key: "token")}"
    });
    http.Response result = await http.post(
        Uri.parse("$SERVER/api/users/add/"),
        headers: headers,
        body: user.asJson()
    );

    return result;
  }

  Future<http.Response> put(User user) async {
    Map<String, String> headers = HashMap<String, String>();
    headers.addAll({
      "accept": "*/*",
      "Content-Type": "application/json",
      "Authorization": "Bearer ${await STORAGE.read(key: "token")}"
    });
    http.Response result = await http.put(
        Uri.parse("$SERVER/api/users/edit/"),
        headers: headers,
        body: user.asJson()
    );

    return result;
  }
}

class __Doctor {
  const __Doctor();

  Future<PaginatedList<Doctor>?> getPaged(String? sortOrder, String searchString, String currentFilter, int? pageNumber, int pageSize) async {
    Map<String, String> headers = HashMap<String, String>();
    headers.addAll({
      "accept": "*/*",
      "Authorization": "Bearer ${await STORAGE.read(key: "token")}"
    });
    http.Response result = await http.get(Uri.parse("$SERVER/api/users/doctors/all/basic?sortOrder=$sortOrder&searchString=$searchString&currentFilter=$currentFilter&pageNumber=$pageNumber&pageSize=$pageSize"), headers: headers);

    if (result.statusCode == 200) {
      Map<String, dynamic> body = json.decode(result.body);
      List<dynamic> dynamicList = body["items"];
      List<Doctor> list = [];
      if (dynamicList.isNotEmpty) {
        for (dynamic i in dynamicList) {
          Doctor doctor = Doctor.fromJson(i);
          list.add(doctor);
        }
      }
      return PaginatedList(list, body["pageNumber"], body["pageSize"], body["totalPages"], body["totalItems"], body["hasPrevious"], body["hasNext"]);
    }
    else {
      List<Doctor> list = [];
      return PaginatedList(list, 1, 10, 0, 0, false, false);
    }
  }

  Future<List<Doctor>?> getAll() async {
    Map<String, String> headers = HashMap<String, String>();
    headers.addAll({
      "accept": "*/*",
      "Authorization": "Bearer ${await STORAGE.read(key: "token")}"
    });
    http.Response result = await http.get(Uri.parse("$SERVER/api/users/doctors/all/"), headers: headers);

    if (result.statusCode == 200) {
      List<dynamic> dynamicList = json.decode(result.body);
      List<Doctor> list = [];
      if (dynamicList.isNotEmpty) {
        for (dynamic i in dynamicList) {
          Doctor doctor = Doctor.fromJson(i);
          list.add(doctor);
        }
      }
      return list;
    }
    else {
      List<Doctor> list = [];
      return list;
    }
  }
  
  Future<int> getCount() async {
    Map<String, String> headers = HashMap<String, String>();
    headers.addAll({
      "accept": "*/*",
      "Authorization": "Bearer ${await STORAGE.read(key: "token")}"
    });

    http.Response result = await http.get(
        Uri.parse("$SERVER/api/users/doctors/count/"),
        headers: headers
    );

    if (result.statusCode == 200) {
      int count = int.parse(result.body);
      return count;
    }
    else {
      return -1;
    }
  }

  Future<Doctor> get(String uuid) async {
    Map<String, String> headers = HashMap<String, String>();
    headers.addAll({
      "accept": "*/*",
      "Authorization": "Bearer ${await STORAGE.read(key: "token")}"
    });
    http.Response result = await http.get(
        Uri.parse("$SERVER/api/users/doctors/$uuid"),
        headers: headers
    );

    final Map<String, dynamic> parsed = json.decode(result.body);

    final Doctor doctor = Doctor.fromJson(parsed);

    return doctor;
  }

  Future<http.Response> post(Doctor doctor) async {
    Map<String, String> headers = HashMap<String, String>();
    headers.addAll({
      "accept": "*/*",
      "Content-Type": "application/json",
      "Authorization": "Bearer ${await STORAGE.read(key: "token")}"
    });
    http.Response result = await http.post(
        Uri.parse("$SERVER/api/users/doctors/add/"),
        headers: headers,
        body: doctor.asJson()
    );

    return result;
  }

  Future<http.Response> put(Doctor doctor) async {
    Map<String, String> headers = HashMap<String, String>();
    headers.addAll({
      "accept": "*/*",
      "Content-Type": "application/json",
      "Authorization": "Bearer ${await STORAGE.read(key: "token")}"
    });
    http.Response result = await http.put(
        Uri.parse("$SERVER/api/users/doctors/edit/"),
        headers: headers,
        body: doctor.asJson()
    );

    return result;
  }
}

class __Patient {
  const __Patient();

  Future<List<Patient>?> getAll() async {
    Map<String, String> headers = HashMap<String, String>();
    headers.addAll({
      "accept": "*/*",
      "Authorization": "Bearer ${await STORAGE.read(key: "token")}"
    });
    http.Response result = await http.get(Uri.parse("$SERVER/api/users/patients/all/"), headers: headers);

    if (result.statusCode == 200) {
      List<dynamic> dynamicList = json.decode(result.body);
      List<Patient> list = [];
      if (dynamicList.isNotEmpty) {
        for (dynamic i in dynamicList) {
          Patient patient = Patient.fromJson(i);
          list.add(patient);
        }
      }
      return list;
    }
    else {
      List<Patient> list = [];
      return list;
    }
  }

  Future<PaginatedList<Patient>?> getPaged(String? sortOrder, String searchString, String currentFilter, int? pageNumber, int pageSize, String doctor) async {
    Map<String, String> headers = HashMap<String, String>();
    headers.addAll({
      "accept": "*/*",
      "Authorization": "Bearer ${await STORAGE.read(key: "token")}"
    });
    http.Response result = await http.get(Uri.parse("$SERVER/api/users/patients/all/basic?sortOrder=$sortOrder&searchString=$searchString&currentFilter=$currentFilter&pageNumber=$pageNumber&pageSize=$pageSize&doctor=$doctor"), headers: headers);

    if (result.statusCode == 200) {
      Map<String, dynamic> body = json.decode(result.body);
      List<dynamic> dynamicList = body["items"];
      List<Patient> list = [];
      if (dynamicList.isNotEmpty) {
        for (dynamic p in dynamicList) {
          Patient patient = Patient.fromJson(p);
          list.add(patient);
        }
      }
      return PaginatedList(list, body["pageNumber"], body["pageSize"], body["totalPages"], body["totalItems"], body["hasPrevious"], body["hasNext"]);
    }
    else {
      List<Patient> list = [];
      return PaginatedList(list, 1, 10, 0, 0, false, false);
    }
  }
  
  Future<int> getCount() async {
    Map<String, String> headers = HashMap<String, String>();
    headers.addAll({
      "accept": "*/*",
      "Authorization": "Bearer ${await STORAGE.read(key: "token")}"
    });

    http.Response result = await http.get(
        Uri.parse("$SERVER/api/users/patients/count/"),
        headers: headers
    );

    if (result.statusCode == 200) {
      int count = int.parse(result.body);
      return count;
    }
    else {
      return -1;
    }
  }

  Future<Patient?> get(String uuid) async {
    Map<String, String> headers = HashMap<String, String>();
    headers.addAll({
      "accept": "*/*",
      "Authorization": "Bearer ${await STORAGE.read(key: "token")}"
    });
    http.Response result = await http.get(
        Uri.parse("$SERVER/api/users/patients/$uuid"),
        headers: headers
    );

    if (result.statusCode == 200) {
      final Map<String, dynamic> parsed = json.decode(result.body);

      final Patient patient = Patient.fromJson(parsed);

      return patient;
    }
    else {
      return null;
    }
  }

  Future<http.Response> post(Patient patient) async {
    Map<String, String> headers = HashMap<String, String>();
    headers.addAll({
      "accept": "*/*",
      "Content-Type": "application/json",
      "Authorization": "Bearer ${await STORAGE.read(key: "token")}"
    });
    http.Response result = await http.post(
        Uri.parse("$SERVER/api/users/patients/add/"),
        headers: headers,
        body: patient.asJson()
    );

    return result;
  }

  Future<http.Response> put(Patient patient) async {
    Map<String, String> headers = HashMap<String, String>();
    headers.addAll({
      "accept": "*/*",
      "Content-Type": "application/json",
      "Authorization": "Bearer ${await STORAGE.read(key: "token")}"
    });
    http.Response result = await http.put(
        Uri.parse("$SERVER/api/users/patients/edit/"),
        headers: headers,
        body: patient.asJson()
    );

    return result;
  }
}

class __Medicine {
  const __Medicine();

  Future<List<Medicine>?> getAll() async {
    Map<String, String> headers = HashMap<String, String>();
    headers.addAll({
      "accept": "*/*",
      "Authorization": "Bearer ${await STORAGE.read(key: "token")}"
    });
    http.Response result = await http.get(Uri.parse("$SERVER/api/medicine/all/all/"), headers: headers);

    if (result.statusCode == 200) {
      List<dynamic> dynamicList = json.decode(result.body);
      List<Medicine> list = [];
      if (dynamicList.isNotEmpty) {
        for (dynamic i in dynamicList) {
          Medicine medicine = Medicine.fromJson(i);
          list.add(medicine);
        }
      }
      return list;
    }
    else {
      List<Medicine> list = [];
      return list;
    }
  }

  Future<PaginatedList<Medicine>?> getPaged(String? sortOrder, String searchString, String currentFilter, int? pageNumber, int pageSize, String company, String issuer) async {
    Map<String, String> headers = HashMap<String, String>();
    headers.addAll({
      "accept": "*/*",
      "Authorization": "Bearer ${await STORAGE.read(key: "token")}"
    });
    http.Response result = await http.get(Uri.parse("$SERVER/api/medicine/all?sortOrder=$sortOrder&searchString=$searchString&currentFilter=$currentFilter&pageNumber=$pageNumber&pageSize=$pageSize&company=$company&issuer=$issuer"), headers: headers);

    if (result.statusCode == 200) {
      Map<String, dynamic> body = json.decode(result.body);
      List<dynamic> dynamicList = body["items"];
      List<Medicine> list = [];
      if (dynamicList.isNotEmpty) {
        for (dynamic i in dynamicList) {
          Medicine medicine = Medicine.fromJson(i);
          list.add(medicine);
        }
      }
      return PaginatedList(list, body["pageNumber"], body["pageSize"], body["totalPages"], body["totalItems"], body["hasPrevious"], body["hasNext"]);
    }
    else {
      List<Medicine> list = [];
      return PaginatedList(list, 1, 10, 0, 0, false, false);
    }
  }
  
  Future<int> getCount() async {
    Map<String, String> headers = HashMap<String, String>();
    headers.addAll({
      "accept": "*/*",
      "Authorization": "Bearer ${await STORAGE.read(key: "token")}"
    });

    http.Response result = await http.get(
        Uri.parse("$SERVER/api/medicine/count/"),
        headers: headers
    );

    if (result.statusCode == 200) {
      int count = int.parse(result.body);
      return count;
    }
    else {
      return -1;
    }
  }

  Future<Medicine> get(String uuid) async {
    Map<String, String> headers = HashMap<String, String>();
    headers.addAll({
      "accept": "*/*",
      "Authorization": "Bearer ${await STORAGE.read(key: "token")}"
    });
    http.Response result = await http.get(
        Uri.parse("$SERVER/api/medicine/$uuid"),
        headers: headers
    );

    final Map<String, dynamic> parsed = json.decode(result.body);

    final Medicine medicine = Medicine.fromJson(parsed);

    return medicine;
  }

  Future<http.Response> post(Medicine medicine) async {
    Map<String, String> headers = HashMap<String, String>();
    headers.addAll({
      "accept": "*/*",
      "Content-Type": "application/json",
      "Authorization": "Bearer ${await STORAGE.read(key: "token")}"
    });
    http.Response result = await http.post(
        Uri.parse("$SERVER/api/medicine/add/"),
        headers: headers,
        body: medicine.asJson()
    );

    return result;
  }

  Future<http.Response> put(Medicine medicine) async {
    Map<String, String> headers = HashMap<String, String>();
    headers.addAll({
      "accept": "*/*",
      "Content-Type": "application/json",
      "Authorization": "Bearer ${await STORAGE.read(key: "token")}"
    });
    http.Response result = await http.put(
        Uri.parse("$SERVER/api/medicine/edit/"),
        headers: headers,
        body: medicine.asJson()
    );

    return result;
  }
}

class __Company {
  const __Company();

  Future<PaginatedList<Company>?> getPaged(String? sortOrder, String searchString, String currentFilter, int? pageNumber, int pageSize) async {
    Map<String, String> headers = HashMap<String, String>();
    headers.addAll({
      "accept": "*/*",
      "Authorization": "Bearer ${await STORAGE.read(key: "token")}"
    });
    http.Response result = await http.get(Uri.parse("$SERVER/api/company/all?sortOrder=$sortOrder&searchString=$searchString&currentFilter=$currentFilter&pageNumber=$pageNumber&pageSize=$pageSize"), headers: headers);

    if (result.statusCode == 200) {
      Map<String, dynamic> body = json.decode(result.body);
      List<dynamic> dynamicList = body["items"];
      List<Company> list = [];
      if (dynamicList.isNotEmpty) {
        for (dynamic c in dynamicList) {
          Company company = Company.fromJson(c);
          list.add(company);
        }
      }
      return PaginatedList(list, body["pageNumber"], body["pageSize"], body["totalPages"], body["totalItems"], body["hasPrevious"], body["hasNext"]);
    }
    else {
      List<Company> list = [];
      return PaginatedList(list, 1, 10, 0, 0, false, false);
    }
  }
  
  Future<List<Company?>> getAll() async {
    Map<String, String> headers = HashMap<String, String>();
    headers.addAll({
      "accept": "*/*",
      "Authorization": "Bearer ${await STORAGE.read(key: "token")}"
    });
    http.Response result = await http.get(Uri.parse("$SERVER/api/company/all/all/"), headers: headers);

    if (result.statusCode == 200) {
      List<dynamic> dynamicList = json.decode(result.body);
      List<Company> list = [];
      if (dynamicList.isNotEmpty) {
        for (dynamic i in dynamicList) {
          Company company = Company.fromJson(i);
          list.add(company);
        }
      }
      return list;
    }
    else {
      List<Company> list = [];
      return list;
    }
  }
  
  Future<int> getCount() async {
    Map<String, String> headers = HashMap<String, String>();
    headers.addAll({
      "accept": "*/*",
      "Authorization": "Bearer ${await STORAGE.read(key: "token")}"
    });

    http.Response result = await http.get(
        Uri.parse("$SERVER/api/company/count/"),
        headers: headers
    );

    if (result.statusCode == 200) {
      int count = int.parse(result.body);
      return count;
    }
    else {
      return -1;
    }
  }

  Future<Company> get(String uuid) async {
    Map<String, String> headers = HashMap<String, String>();
    headers.addAll({
      "accept": "*/*",
      "Authorization": "Bearer ${await STORAGE.read(key: "token")}"
    });
    http.Response result = await http.get(
        Uri.parse("$SERVER/api/company/$uuid"),
        headers: headers
    );

    final Map<String, dynamic> parsed = json.decode(result.body);

    final Company company = Company.fromJson(parsed);

    return company;
  }

  Future<http.Response> post(Company company) async {
    Map<String, String> headers = HashMap<String, String>();
    headers.addAll({
      "accept": "*/*",
      "Content-Type": "application/json",
      "Authorization": "Bearer ${await STORAGE.read(key: "token")}"
    });
    http.Response result = await http.post(
        Uri.parse("$SERVER/api/company/add/"),
        headers: headers,
        body: company.asJson()
    );

    return result;
  }

  Future<http.Response> put(Company company) async {
    Map<String, String> headers = HashMap<String, String>();
    headers.addAll({
      "accept": "*/*",
      "Content-Type": "application/json",
      "Authorization": "Bearer ${await STORAGE.read(key: "token")}"
    });
    http.Response result = await http.put(
        Uri.parse("$SERVER/api/company/edit/"),
        headers: headers,
        body: company.asJson()
    );

    return result;
  }
}

class __Issuer {
  const __Issuer();

   Future<PaginatedList<Issuer>?> getPaged(String? sortOrder, String searchString, String currentFilter, int? pageNumber, int pageSize) async {
    Map<String, String> headers = HashMap<String, String>();
    headers.addAll({
      "accept": "*/*",
      "Authorization": "Bearer ${await STORAGE.read(key: "token")}"
    });
    http.Response result = await http.get(Uri.parse("$SERVER/api/issuer/all?sortOrder=$sortOrder&searchString=$searchString&currentFilter=$currentFilter&pageNumber=$pageNumber&pageSize=$pageSize"), headers: headers);

    if (result.statusCode == 200) {
      Map<String, dynamic> body = json.decode(result.body);
      List<dynamic> dynamicList = body["items"];
      List<Issuer> list = [];
      if (dynamicList.isNotEmpty) {
        for (dynamic i in dynamicList) {
          Issuer issuer = Issuer.fromJson(i);
          list.add(issuer);
        }
      }
      return PaginatedList(list, body["pageNumber"], body["pageSize"], body["totalPages"], body["totalItems"], body["hasPrevious"], body["hasNext"]);
    }
    else {
      List<Issuer> list = [];
      return PaginatedList(list, 1, 10, 0, 0, false, false);
    }
  }
  
  Future<List<Issuer?>> getAll() async {
    Map<String, String> headers = HashMap<String, String>();
    headers.addAll({
      "accept": "*/*",
      "Authorization": "Bearer ${await STORAGE.read(key: "token")}"
    });
    http.Response result = await http.get(Uri.parse("$SERVER/api/issuer/all/all/"), headers: headers);

    if (result.statusCode == 200) {
      List<dynamic> dynamicList = json.decode(result.body);
      List<Issuer> list = [];
      if (dynamicList.isNotEmpty) {
        for (dynamic i in dynamicList) {
          Issuer issuer = Issuer.fromJson(i);
          list.add(issuer);
        }
      }
      return list;
    }
    else {
      List<Issuer> list = [];
      return list;
    }
  }
  
  Future<int> getCount() async {
    Map<String, String> headers = HashMap<String, String>();
    headers.addAll({
      "accept": "*/*",
      "Authorization": "Bearer ${await STORAGE.read(key: "token")}"
    });

    http.Response result = await http.get(
        Uri.parse("$SERVER/api/issuer/count/"),
        headers: headers
    );

    if (result.statusCode == 200) {
      int count = int.parse(result.body);
      return count;
    }
    else {
      return -1;
    }
  }
  
  Future<Issuer> get(String uuid) async {
    Map<String, String> headers = HashMap<String, String>();
    headers.addAll({
      "accept": "*/*",
      "Authorization": "Bearer ${await STORAGE.read(key: "token")}"
    });
    http.Response result = await http.get(
        Uri.parse("$SERVER/api/issuer/$uuid"),
        headers: headers
    );

    final Map<String, dynamic> parsed = json.decode(result.body);

    final Issuer issuer = Issuer.fromJson(parsed);

    return issuer;
  }

  Future<http.Response> post(Issuer issuer) async {
    Map<String, String> headers = HashMap<String, String>();
    headers.addAll({
      "accept": "*/*",
      "Content-Type": "application/json",
      "Authorization": "Bearer ${await STORAGE.read(key: "token")}"
    });
    http.Response result = await http.post(
        Uri.parse("$SERVER/api/issuer/add/"),
        headers: headers,
        body: issuer.asJson()
    );

    return result;
  }

  Future<http.Response> put(Issuer issuer) async {
    Map<String, String> headers = HashMap<String, String>();
    headers.addAll({
      "accept": "*/*",
      "Content-Type": "application/json",
      "Authorization": "Bearer ${await STORAGE.read(key: "token")}"
    });
    http.Response result = await http.put(
        Uri.parse("$SERVER/api/issuer/edit/"),
        headers: headers,
        body: issuer.asJson()
    );

    return result;
  }

  
}

class __Report {
  const __Report();

  Future<PaginatedList<Report?>> getPaged(String? sortOrder, int? pageNumber, int pageSize, String user) async {
    Map<String, String> headers = HashMap<String, String>();
    headers.addAll({
      "accept": "*/*",
      "Authorization": "Bearer ${await STORAGE.read(key: "token")}"
    });
    http.Response result = await http.get(Uri.parse("$SERVER/api/report/all?sortOrder=$sortOrder&pageNumber=$pageNumber&pageSize=$pageSize&user=$user"), headers: headers);

    if (result.statusCode == 200) {
      Map<String, dynamic> body = json.decode(result.body);
      List<dynamic> dynamicList = body["items"];
      List<Report> list = [];
      if (dynamicList.isNotEmpty) {
        for (dynamic p in dynamicList) {
          Report report = Report.fromJson(p);
          list.add(report);
        }
      }
      return PaginatedList(list, body["pageNumber"], body["pageSize"], body["totalPages"], body["totalItems"], body["hasPrevious"], body["hasNext"]);
    }
    else {
      List<Report> list = [];
      return PaginatedList(list, 1, 10, 0, 0, false, false);
    }
  }
  
  Future<int> getCount() async {
    Map<String, String> headers = HashMap<String, String>();
    headers.addAll({
      "accept": "*/*",
      "Authorization": "Bearer ${await STORAGE.read(key: "token")}"
    });

    http.Response result = await http.get(
        Uri.parse("$SERVER/api/report/count/"),
        headers: headers
    );

    if (result.statusCode == 200) {
      int count = int.parse(result.body);
      return count;
    }
    else {
      return -1;
    }
  }

  Future<Report?> get(String uuid) async {
    Map<String, String> headers = HashMap<String, String>();
    headers.addAll({
      "accept": "*/*",
      "Authorization": "Bearer ${await STORAGE.read(key: "token")}"
    });
    http.Response result = await http.get(
        Uri.parse("$SERVER/api/report/$uuid"),
        headers: headers
    );

    final Map<String, dynamic> parsed = json.decode(result.body);

    final Report report = Report.fromJson(parsed);

    return report;
  }

  Future<http.Response> post(Report report) async {
    Map<String, String> headers = HashMap<String, String>();
    headers.addAll({
      "accept": "*/*",
      "Content-Type": "application/json",
      "Authorization": "Bearer ${await STORAGE.read(key: "token")}"
    });
    http.Response result = await http.post(
        Uri.parse("$SERVER/api/report/add/"),
        headers: headers,
        body: report.asJson()
    );

    return result;
  }

  Future<int> delete(String uuid) async {
    Map<String, String> headers = HashMap<String, String>();
    headers.addAll({
      "accept": "*/*",
      "Authorization": "Bearer ${await STORAGE.read(key: "token")}"
    });

    http.Response result = await http.delete(Uri.parse("$SERVER/api/report/remove/$uuid"), headers: headers);

    if (result.statusCode == 200) {
      return 1;
    }
    else {
      return 0;
    }
  }
}

class __Request {
  const __Request();

  Future<PaginatedList<Request?>> getPaged(String? sortOrder, int? pageNumber, int pageSize, String patient, String doctor) async {
    Map<String, String> headers = HashMap<String, String>();
    headers.addAll({
      "accept": "*/*",
      "Authorization": "Bearer ${await STORAGE.read(key: "token")}"
    });
    http.Response result = await http.get(Uri.parse("$SERVER/api/request/all?sortOrder=$sortOrder&pageNumber=$pageNumber&pageSize=$pageSize&patient=$patient&doctor=$doctor"), headers: headers);

    if (result.statusCode == 200) {
      Map<String, dynamic> body = json.decode(result.body);
      List<dynamic> dynamicList = body["items"];
      List<Request> list = [];
      if (dynamicList.isNotEmpty) {
        for (dynamic p in dynamicList) {
          Request request = Request.fromJson(p);
          list.add(request);
        }
      }
      return PaginatedList(list, body["pageNumber"], body["pageSize"], body["totalPages"], body["totalItems"], body["hasPrevious"], body["hasNext"]);
    }
    else {
      List<Request> list = [];
      return PaginatedList(list, 1, 10, 0, 0, false, false);
    }
  }

  Future<int> getCount(String uuid) async {
    Map<String, String> headers = HashMap<String, String>();
    headers.addAll({
      "accept": "*/*",
      "Authorization": "Bearer ${await STORAGE.read(key: "token")}"
    });

    http.Response result = await http.get(
        Uri.parse("$SERVER/api/request/count/$uuid/AWAITING"),
        headers: headers
    );

    if (result.statusCode == 200) {
      int count = int.parse(result.body);
      return count;
    }
    else {
      return -1;
    }
  }

  Future<Request?> get(String uuid) async {
    Map<String, String> headers = HashMap<String, String>();
    headers.addAll({
      "accept": "*/*",
      "Authorization": "Bearer ${await STORAGE.read(key: "token")}"
    });
    http.Response result = await http.get(
        Uri.parse("$SERVER/api/request/$uuid"),
        headers: headers
    );

    final Map<String, dynamic> parsed = json.decode(result.body);

    final Request request = Request.fromJson(parsed);

    return request;
  }

  Future<http.Response> post(Request request) async {
    Map<String, String> headers = HashMap<String, String>();
    headers.addAll({
      "accept": "*/*",
      "Content-Type": "application/json",
      "Authorization": "Bearer ${await STORAGE.read(key: "token")}"
    });
    http.Response result = await http.post(
        Uri.parse("$SERVER/api/request/add/"),
        headers: headers,
        body: request.asJson()
    );

    return result;
  }

  Future<http.Response> put(Request request) async {
    Map<String, String> headers = HashMap<String, String>();
    headers.addAll({
      "accept": "*/*",
      "Content-Type": "application/json",
      "Authorization": "Bearer ${await STORAGE.read(key: "token")}"
    });
    http.Response result = await http.put(
        Uri.parse("$SERVER/api/request/edit/"),
        headers: headers,
        body: request.asJson()
    );

    return result;
  }
}

class __Prescription {
  const __Prescription();

  Future<PaginatedList<Prescription?>> getPaged(String? sortOrder, int? pageNumber, int pageSize, String doctor, String patient) async {
    Map<String, String> headers = HashMap<String, String>();
    headers.addAll({
      "accept": "*/*",
      "Authorization": "Bearer ${await STORAGE.read(key: "token")}"
    });
    http.Response result= await http.get(Uri.parse("$SERVER/api/prescription/all?sortOrder=$sortOrder&pageNumber=$pageNumber&pageSize=$pageSize&doctor=$doctor&patient=$patient"), headers: headers);

    if (result.statusCode == 200) {
      Map<String, dynamic> body = json.decode(result.body);
      List<dynamic> dynamicList = body["items"];
      List<Prescription> list = [];
      if (dynamicList.isNotEmpty) {
        for (dynamic p in dynamicList) {
          Prescription prescription = Prescription.fromJson(p);
          list.add(prescription);
        }
      }
      return PaginatedList(list, body["pageNumber"], body["pageSize"], body["totalPages"], body["totalItems"], body["hasPrevious"], body["hasNext"]);
    }
    else {
      List<Prescription> list = [];
      return PaginatedList(list, 1, 10, 0, 0, false, false);
    }
  }

  Future<Prescription?> get(int id) async {
    Map<String, String> headers = HashMap<String, String>();
    headers.addAll({
      "accept": "*/*",
      "Authorization": "Bearer ${await STORAGE.read(key: "token")}"
    });
    http.Response result = await http.get(
        Uri.parse("$SERVER/api/prescription/$id"),
        headers: headers
    );

    final Map<String, dynamic> parsed = json.decode(result.body);

    final Prescription report = Prescription.fromJson(parsed);

    return report;
  }

  Future<http.Response> post(Prescription prescription) async {
    Map<String, String> headers = HashMap<String, String>();
    headers.addAll({
      "accept": "*/*",
      "Content-Type": "application/json",
      "Authorization": "Bearer ${await STORAGE.read(key: "token")}"
    });
    http.Response result = await http.post(
        Uri.parse("$SERVER/api/prescription/add/"),
        headers: headers,
        body: prescription.asJson()
    );

    return result;
  }

  Future<int> getCount(String uuid) async {
    Map<String, String> headers = HashMap<String, String>();
    headers.addAll({
      "accept": "*/*",
      "Authorization": "Bearer ${await STORAGE.read(key: "token")}"
    });

    http.Response result = await http.get(
        Uri.parse("$SERVER/api/prescription/count?UUID=$uuid"),
        headers: headers
    );

    if (result.statusCode == 200) {
      int count = int.parse(result.body);
      return count;
    }
    else {
      return -1;
    }
  }
}

class __Appointment {
  const __Appointment();

  Future<PaginatedList<Appointment?>> getPaged(String? sortOrder, String searchString, String currentFilter, int? pageNumber, int pageSize, String doctor, String patient,
      {DateTime? dateTime}) async {
    Map<String, String> headers = HashMap<String, String>();
    headers.addAll({
      "accept": "*/*",
      "Authorization": "Bearer ${await STORAGE.read(key: "token")}"
    });
    http.Response result;
    if (dateTime == null) {
      result = await http.get(Uri.parse("$SERVER/api/schedule/all?sortOrder=$sortOrder&searchString=$searchString&currentFilter=$currentFilter&pageNumber=$pageNumber&pageSize=$pageSize&doctor=$doctor&patient=$patient"), headers: headers);
    }
    else {
      DateFormat format = DateFormat("yyyy-MM-ddTHH:mm:ss");
      result  = await http.get(Uri.parse("$SERVER/api/schedule/all?sortOrder=$sortOrder&searchString=$searchString&currentFilter=$currentFilter&pageNumber=$pageNumber&pageSize=$pageSize&doctor=$doctor&patient=$patient&date=${format.format(dateTime)}"), headers: headers);
    }

    if (result.statusCode == 200) {
      Map<String, dynamic> body = json.decode(result.body);
      List<dynamic> dynamicList = body["items"];
      List<Appointment> list = [];
      if (dynamicList.isNotEmpty) {
        for (dynamic a in dynamicList) {
          Appointment appointment = Appointment.fromJson(a);
          list.add(appointment);
        }
      }
      return PaginatedList(list, body["pageNumber"], body["pageSize"], body["totalPages"], body["totalItems"], body["hasPrevious"], body["hasNext"]);
    }
    else {
      List<Appointment> list = [];
      return PaginatedList(list, 1, 10, 0, 0, false, false);
    }
  }

  Future<Appointment?> get(int id) async {
    Map<String, String> headers = HashMap<String, String>();
    headers.addAll({
      "accept": "*/*",
      "Authorization": "Bearer ${await STORAGE.read(key: "token")}"
    });
    http.Response result = await http.get(
        Uri.parse("$SERVER/api/schedule/$id"),
        headers: headers
    );

    final Map<String, dynamic> parsed = json.decode(result.body);

    final Appointment report = Appointment.fromJson(parsed);

    return report;
  }

  Future<http.Response> post(Appointment appointment) async {
    Map<String, String> headers = HashMap<String, String>();
    headers.addAll({
      "accept": "*/*",
      "Content-Type": "application/json",
      "Authorization": "Bearer ${await STORAGE.read(key: "token")}"
    });
    http.Response result = await http.post(
        Uri.parse("$SERVER/api/schedule/add/"),
        headers: headers,
        body: appointment.asJson()
    );

    return result;
  }

  Future<http.Response> put(Appointment appointment) async {
    Map<String, String> headers = HashMap<String, String>();
    headers.addAll({
      "accept": "*/*",
      "Content-Type": "application/json",
      "Authorization": "Bearer ${await STORAGE.read(key: "token")}"
    });
    http.Response result = await http.put(
        Uri.parse("$SERVER/api/schedule/edit/"),
        headers: headers,
        body: appointment.asJson()
    );

    return result;
  }
}

class __Notes {
  const __Notes();

  Future<PaginatedList<Note?>> getPaged(String? sortOrder, int? pageNumber, int pageSize, String doctor, String patient) async {
    Map<String, String> headers = HashMap<String, String>();
    headers.addAll({
      "accept": "*/*",
      "Authorization": "Bearer ${await STORAGE.read(key: "token")}"
    });
    http.Response result = await http.get(Uri.parse("$SERVER/api/notes/all?sortOrder=$sortOrder&pageNumber=$pageNumber&pageSize=$pageSize&doctor=$doctor&patient=$patient"), headers: headers);


    if (result.statusCode == 200) {
      Map<String, dynamic> body = json.decode(result.body);
      List<dynamic> dynamicList = body["items"];
      List<Note> list = [];
      if (dynamicList.isNotEmpty) {
        for (dynamic a in dynamicList) {
          Note note = Note.fromJson(a);
          list.add(note);
        }
      }
      return PaginatedList(list, body["pageNumber"], body["pageSize"], body["totalPages"], body["totalItems"], body["hasPrevious"], body["hasNext"]);
    }
    else {
      List<Note> list = [];
      return PaginatedList(list, 1, 10, 0, 0, false, false);
    }
  }

  Future<Note?> get(int id) async {
    Map<String, String> headers = HashMap<String, String>();
    headers.addAll({
      "accept": "*/*",
      "Authorization": "Bearer ${await STORAGE.read(key: "token")}"
    });
    http.Response result = await http.get(
        Uri.parse("$SERVER/api/notes/$id"),
        headers: headers
    );

    final Map<String, dynamic> parsed = json.decode(result.body);

    final Note note = Note.fromJson(parsed);

    return note;
  }

  Future<http.Response> post(Note note) async {
    Map<String, String> headers = HashMap<String, String>();
    headers.addAll({
      "accept": "*/*",
      "Content-Type": "application/json",
      "Authorization": "Bearer ${await STORAGE.read(key: "token")}"
    });
    http.Response result = await http.post(
        Uri.parse("$SERVER/api/notes/add/"),
        headers: headers,
        body: note.asJson()
    );

    return result;
  }

  Future<http.Response> put(Note note) async {
    Map<String, String> headers = HashMap<String, String>();
    headers.addAll({
      "accept": "*/*",
      "Content-Type": "application/json",
      "Authorization": "Bearer ${await STORAGE.read(key: "token")}"
    });
    http.Response result = await http.put(
        Uri.parse("$SERVER/api/notes/edit/"),
        headers: headers,
        body: note.asJson()
    );

    return result;
  }

  Future<int> delete(int id) async {
    Map<String, String> headers = HashMap<String, String>();
    headers.addAll({
      "accept": "*/*",
      "Authorization": "Bearer ${await STORAGE.read(key: "token")}"
    });

    http.Response result = await http.delete(Uri.parse("$SERVER/api/notes/remove/$id"), headers: headers);

    if (result.statusCode == 200) {
      return 1;
    }
    else {
      return 0;
    }
  }
}