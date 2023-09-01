import 'dart:convert';

import 'package:http/http.dart';

class HttpRequests {
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
}