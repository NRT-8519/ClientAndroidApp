import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:client_android_app/models/issuer.dart';
import 'package:client_android_app/models/paginated_list.dart';
import 'package:client_android_app/models/patient.dart';
import 'package:client_android_app/models/medicine.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../models/company.dart';
import '../models/doctor.dart';
import '../models/user.dart';

class HttpRequests {
  static const STORAGE = FlutterSecureStorage();
  static const SERVER = "https://10.0.2.2:7215";

  static Future<Response?> authenticate(String username, String password) async {
    final body = json.encode({
      "username": username,
      "password": password
    });

    try {
      Response result = await post(
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

  static Future<int> getAdminCount() async {
    Map<String, String> headers = HashMap<String, String>();
    headers.addAll({
      "accept": "*/*",
      "Authorization": "Bearer ${await STORAGE.read(key: "token")}"
    });

    Response result = await get(
        Uri.parse("$SERVER/api/users/administrators/count/"),
      headers: headers
    );

    int count = int.parse(result.body);
    return count;
  }

  static Future<int> getPatientCount() async {
    Map<String, String> headers = HashMap<String, String>();
    headers.addAll({
      "accept": "*/*",
      "Authorization": "Bearer ${await STORAGE.read(key: "token")}"
    });

    Response result = await get(
        Uri.parse("$SERVER/api/users/patients/count/"),
        headers: headers
    );

    int count = int.parse(result.body);
    return count;
  }

  static Future<int> getDoctorCount() async {
    Map<String, String> headers = HashMap<String, String>();
    headers.addAll({
      "accept": "*/*",
      "Authorization": "Bearer ${await STORAGE.read(key: "token")}"
    });

    Response result = await get(
        Uri.parse("$SERVER/api/users/doctors/count/"),
        headers: headers
    );

    int count = int.parse(result.body);
    return count;
  }

  static Future<int> getMedicineCount() async {
    Map<String, String> headers = HashMap<String, String>();
    headers.addAll({
      "accept": "*/*",
      "Authorization": "Bearer ${await STORAGE.read(key: "token")}"
    });

    Response result = await get(
        Uri.parse("$SERVER/api/medicine/count/"),
        headers: headers
    );

    int count = int.parse(result.body);
    return count;
  }

  static Future<int> getCompanyCount() async {
    Map<String, String> headers = HashMap<String, String>();
    headers.addAll({
      "accept": "*/*",
      "Authorization": "Bearer ${await STORAGE.read(key: "token")}"
    });

    Response result = await get(
        Uri.parse("$SERVER/api/company/count/"),
        headers: headers
    );

    int count = int.parse(result.body);
    return count;
  }

  static Future<int> getIssuerCount() async {
    Map<String, String> headers = HashMap<String, String>();
    headers.addAll({
      "accept": "*/*",
      "Authorization": "Bearer ${await STORAGE.read(key: "token")}"
    });

    Response result = await get(
        Uri.parse("$SERVER/api/issuer/count/"),
        headers: headers
    );

    int count = int.parse(result.body);
    return count;
  }

  static Future<int> getReportCount() async {
    Map<String, String> headers = HashMap<String, String>();
    headers.addAll({
      "accept": "*/*",
      "Authorization": "Bearer ${await STORAGE.read(key: "token")}"
    });

    Response result = await get(
        Uri.parse("$SERVER/api/report/count/"),
        headers: headers
    );

    int count = int.parse(result.body);
    return count;
  }

  static Future<User> getUser(String uuid) async {
    Map<String, String> headers = HashMap<String, String>();
    headers.addAll({
      "accept": "*/*",
      "Authorization": "Bearer ${await STORAGE.read(key: "token")}"
    });
    Response result = await get(
        Uri.parse("$SERVER/api/users/$uuid"),
        headers: headers
    );

    final Map<String, dynamic> parsed = json.decode(result.body);

    final User user = User.fromJson(parsed);

    return user;
  }

  static Future<Patient> getPatient(String uuid) async {
    Map<String, String> headers = HashMap<String, String>();
    headers.addAll({
      "accept": "*/*",
      "Authorization": "Bearer ${await STORAGE.read(key: "token")}"
    });
    Response result = await get(
        Uri.parse("$SERVER/api/users/patients/$uuid"),
        headers: headers
    );

    final Map<String, dynamic> parsed = json.decode(result.body);

    final Patient patient = Patient.fromJson(parsed);

    return patient;
  }

  static Future<Doctor> getDoctor(String uuid) async {
    Map<String, String> headers = HashMap<String, String>();
    headers.addAll({
      "accept": "*/*",
      "Authorization": "Bearer ${await STORAGE.read(key: "token")}"
    });
    Response result = await get(
        Uri.parse("$SERVER/api/users/doctors/$uuid"),
        headers: headers
    );

    final Map<String, dynamic> parsed = json.decode(result.body);

    final Doctor doctor = Doctor.fromJson(parsed);

    return doctor;
  }

  static Future<Company> getCompany(String uuid) async {
    Map<String, String> headers = HashMap<String, String>();
    headers.addAll({
      "accept": "*/*",
      "Authorization": "Bearer ${await STORAGE.read(key: "token")}"
    });
    Response result = await get(
        Uri.parse("$SERVER/api/company/$uuid"),
        headers: headers
    );

    final Map<String, dynamic> parsed = json.decode(result.body);

    final Company company = Company.fromJson(parsed);

    return company;
  }

  static Future<Issuer> getIssuer(String uuid) async {
    Map<String, String> headers = HashMap<String, String>();
    headers.addAll({
      "accept": "*/*",
      "Authorization": "Bearer ${await STORAGE.read(key: "token")}"
    });
    Response result = await get(
        Uri.parse("$SERVER/api/issuer/$uuid"),
        headers: headers
    );

    final Map<String, dynamic> parsed = json.decode(result.body);

    final Issuer issuer = Issuer.fromJson(parsed);

    return issuer;
  }

  static Future<Medicine> getMedicine(String uuid) async {
    Map<String, String> headers = HashMap<String, String>();
    headers.addAll({
      "accept": "*/*",
      "Authorization": "Bearer ${await STORAGE.read(key: "token")}"
    });
    Response result = await get(
        Uri.parse("$SERVER/api/medicine/$uuid"),
        headers: headers
    );

    final Map<String, dynamic> parsed = json.decode(result.body);

    final Medicine medicine = Medicine.fromJson(parsed);

    return medicine;
  }

  static Future<Response> putUser(User user) async {
    Map<String, String> headers = HashMap<String, String>();
    headers.addAll({
      "accept": "*/*",
      "Content-Type": "application/json",
      "Authorization": "Bearer ${await STORAGE.read(key: "token")}"
    });
    Response result = await put(
        Uri.parse("$SERVER/api/users/edit/"),
        headers: headers,
      body: user.asJson()
    );

    return result;
  }

  static Future<Response> putPatient(Patient patient) async {
    Map<String, String> headers = HashMap<String, String>();
    headers.addAll({
      "accept": "*/*",
      "Content-Type": "application/json",
      "Authorization": "Bearer ${await STORAGE.read(key: "token")}"
    });
    Response result = await put(
        Uri.parse("$SERVER/api/users/patients/edit/"),
        headers: headers,
        body: patient.asJson()
    );

    return result;
  }

  static Future<Response> putCompany(Company company) async {
    Map<String, String> headers = HashMap<String, String>();
    headers.addAll({
      "accept": "*/*",
      "Content-Type": "application/json",
      "Authorization": "Bearer ${await STORAGE.read(key: "token")}"
    });
    Response result = await put(
        Uri.parse("$SERVER/api/company/edit/"),
        headers: headers,
        body: company.asJson()
    );

    return result;
  }

  static Future<Response> putIssuer(Issuer issuer) async {
    Map<String, String> headers = HashMap<String, String>();
    headers.addAll({
      "accept": "*/*",
      "Content-Type": "application/json",
      "Authorization": "Bearer ${await STORAGE.read(key: "token")}"
    });
    Response result = await put(
        Uri.parse("$SERVER/api/issuer/edit/"),
        headers: headers,
        body: issuer.asJson()
    );

    return result;
  }

  static Future<Response> putMedicine(Medicine medicine) async {
    Map<String, String> headers = HashMap<String, String>();
    headers.addAll({
      "accept": "*/*",
      "Content-Type": "application/json",
      "Authorization": "Bearer ${await STORAGE.read(key: "token")}"
    });
    Response result = await put(
        Uri.parse("$SERVER/api/medicine/edit/"),
        headers: headers,
        body: medicine.asJson()
    );

    return result;
  }

  static Future<Response> putDoctor(Doctor doctor) async {
    Map<String, String> headers = HashMap<String, String>();
    headers.addAll({
      "accept": "*/*",
      "Content-Type": "application/json",
      "Authorization": "Bearer ${await STORAGE.read(key: "token")}"
    });
    Response result = await put(
        Uri.parse("$SERVER/api/users/doctors/edit/"),
        headers: headers,
        body: doctor.asJson()
    );

    return result;
  }

  static Future<Response> postUser(User user) async {
    Map<String, String> headers = HashMap<String, String>();
    headers.addAll({
      "accept": "*/*",
      "Content-Type": "application/json",
      "Authorization": "Bearer ${await STORAGE.read(key: "token")}"
    });
    Response result = await post(
        Uri.parse("$SERVER/api/users/add/"),
        headers: headers,
        body: user.asJson()
    );

    return result;
  }

  static Future<Response> postPatient(Patient patient) async {
    Map<String, String> headers = HashMap<String, String>();
    headers.addAll({
      "accept": "*/*",
      "Content-Type": "application/json",
      "Authorization": "Bearer ${await STORAGE.read(key: "token")}"
    });
    Response result = await post(
        Uri.parse("$SERVER/api/users/patients/add/"),
        headers: headers,
        body: patient.asJson()
    );

    return result;
  }

  static Future<Response> postDoctor(Doctor doctor) async {
    Map<String, String> headers = HashMap<String, String>();
    headers.addAll({
      "accept": "*/*",
      "Content-Type": "application/json",
      "Authorization": "Bearer ${await STORAGE.read(key: "token")}"
    });
    Response result = await post(
        Uri.parse("$SERVER/api/users/doctors/add/"),
        headers: headers,
        body: doctor.asJson()
    );

    return result;
  }

  static Future<Response> postCompany(Company company) async {
    Map<String, String> headers = HashMap<String, String>();
    headers.addAll({
      "accept": "*/*",
      "Content-Type": "application/json",
      "Authorization": "Bearer ${await STORAGE.read(key: "token")}"
    });
    Response result = await post(
        Uri.parse("$SERVER/api/company/add/"),
        headers: headers,
        body: company.asJson()
    );

    return result;
  }

  static Future<Response> postIssuer(Issuer issuer) async {
    Map<String, String> headers = HashMap<String, String>();
    headers.addAll({
      "accept": "*/*",
      "Content-Type": "application/json",
      "Authorization": "Bearer ${await STORAGE.read(key: "token")}"
    });
    Response result = await post(
        Uri.parse("$SERVER/api/issuer/add/"),
        headers: headers,
        body: issuer.asJson()
    );

    return result;
  }

  static Future<Response> postMedicine(Medicine medicine) async {
    Map<String, String> headers = HashMap<String, String>();
    headers.addAll({
      "accept": "*/*",
      "Content-Type": "application/json",
      "Authorization": "Bearer ${await STORAGE.read(key: "token")}"
    });
    Response result = await post(
        Uri.parse("$SERVER/api/medicine/add/"),
        headers: headers,
        body: medicine.asJson()
    );

    return result;
  }

  static Future<PaginatedList<Patient>?> getPatients(String? sortOrder, String searchString, String currentFilter, int? pageNumber, int pageSize, String doctor) async {
    Map<String, String> headers = HashMap<String, String>();
    headers.addAll({
      "accept": "*/*",
      "Authorization": "Bearer ${await STORAGE.read(key: "token")}"
    });
    Response result = await get(Uri.parse("$SERVER/api/users/patients/all/basic?sortOrder=$sortOrder&searchString=$searchString&currentFilter=$currentFilter&pageNumber=$pageNumber&pageSize=$pageSize&doctor=$doctor"), headers: headers);

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

  static Future<PaginatedList<Doctor>?> getDoctors(String? sortOrder, String searchString, String currentFilter, int? pageNumber, int pageSize) async {
    Map<String, String> headers = HashMap<String, String>();
    headers.addAll({
      "accept": "*/*",
      "Authorization": "Bearer ${await STORAGE.read(key: "token")}"
    });
    Response result = await get(Uri.parse("$SERVER/api/users/doctors/all/basic?sortOrder=$sortOrder&searchString=$searchString&currentFilter=$currentFilter&pageNumber=$pageNumber&pageSize=$pageSize"), headers: headers);

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

  static Future<List<Doctor>?> getAllDoctors() async {
    Map<String, String> headers = HashMap<String, String>();
    headers.addAll({
      "accept": "*/*",
      "Authorization": "Bearer ${await STORAGE.read(key: "token")}"
    });
    Response result = await get(Uri.parse("$SERVER/api/users/doctors/all/"), headers: headers);

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

  static Future<List<Company?>> getAllCompanies() async {
    Map<String, String> headers = HashMap<String, String>();
    headers.addAll({
      "accept": "*/*",
      "Authorization": "Bearer ${await STORAGE.read(key: "token")}"
    });
    Response result = await get(Uri.parse("$SERVER/api/company/all/all/"), headers: headers);

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

  static Future<List<Issuer?>> getAllIssuers() async {
    Map<String, String> headers = HashMap<String, String>();
    headers.addAll({
      "accept": "*/*",
      "Authorization": "Bearer ${await STORAGE.read(key: "token")}"
    });
    Response result = await get(Uri.parse("$SERVER/api/issuer/all/all/"), headers: headers);

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

  static Future<PaginatedList<User>?> getAdministrators(String? sortOrder, String searchString, String currentFilter, int? pageNumber, int pageSize) async {
    Map<String, String> headers = HashMap<String, String>();
    headers.addAll({
      "accept": "*/*",
      "Authorization": "Bearer ${await STORAGE.read(key: "token")}"
    });
    Response result = await get(Uri.parse("$SERVER/api/users/all/basic?sortOrder=$sortOrder&searchString=$searchString&currentFilter=$currentFilter&pageNumber=$pageNumber&pageSize=$pageSize"), headers: headers);

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

  static Future<PaginatedList<Company>?> getCompanies(String? sortOrder, String searchString, String currentFilter, int? pageNumber, int pageSize) async {
    Map<String, String> headers = HashMap<String, String>();
    headers.addAll({
      "accept": "*/*",
      "Authorization": "Bearer ${await STORAGE.read(key: "token")}"
    });
    Response result = await get(Uri.parse("$SERVER/api/company/all?sortOrder=$sortOrder&searchString=$searchString&currentFilter=$currentFilter&pageNumber=$pageNumber&pageSize=$pageSize"), headers: headers);

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

  static Future<PaginatedList<Issuer>?> getIssuers(String? sortOrder, String searchString, String currentFilter, int? pageNumber, int pageSize) async {
    Map<String, String> headers = HashMap<String, String>();
    headers.addAll({
      "accept": "*/*",
      "Authorization": "Bearer ${await STORAGE.read(key: "token")}"
    });
    Response result = await get(Uri.parse("$SERVER/api/issuer/all?sortOrder=$sortOrder&searchString=$searchString&currentFilter=$currentFilter&pageNumber=$pageNumber&pageSize=$pageSize"), headers: headers);

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

  static Future<PaginatedList<Medicine>?> getMedicines(String? sortOrder, String searchString, String currentFilter, int? pageNumber, int pageSize, String company, String issuer) async {
    Map<String, String> headers = HashMap<String, String>();
    headers.addAll({
      "accept": "*/*",
      "Authorization": "Bearer ${await STORAGE.read(key: "token")}"
    });
    Response result = await get(Uri.parse("$SERVER/api/medicine/all?sortOrder=$sortOrder&searchString=$searchString&currentFilter=$currentFilter&pageNumber=$pageNumber&pageSize=$pageSize&company=$company&issuer=$issuer"), headers: headers);

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
}