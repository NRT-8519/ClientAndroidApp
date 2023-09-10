import 'package:client_android_app/auth/login.dart';
import 'package:client_android_app/main.dart';
import 'package:flutter/material.dart';

import 'http_requests.dart';

class Globals {

  static bool isLoggedIn = false;

  static Future<void> keepSession() async {
    while(isLoggedIn) {

      bool isValid = await HttpRequests.authentication.validate();

      if (!isValid) {
        isLoggedIn = false;
        ClientWebApp.navigatorKey.currentState!.push(MaterialPageRoute(builder: (context) => const LoginPage()));
        ScaffoldMessenger.of(ClientWebApp.navigatorKey.currentState!.context).showSnackBar(
            const SnackBar(content: Text("You have been logged out"))
        );
      }
      await Future.delayed(const Duration(seconds: 10));
    }
  }
}