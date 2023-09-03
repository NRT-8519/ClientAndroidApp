import 'dart:collection';
import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';

class HttpRequests {
  static const STORAGE = FlutterSecureStorage();
  static const SERVER = "https://10.0.2.2:7215";

  static Future<Response> authenticate(String username, String password) async {
    final body = json.encode({
      "username": username,
      "password": password
    });

    Response result = await post(
        Uri.parse("$SERVER/api/users/authenticate/"),
        headers: {
          "accept": "*/*",
          "content-type": "application/json; charset=utf-8",
        },
        body: body);

    return result;
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
}