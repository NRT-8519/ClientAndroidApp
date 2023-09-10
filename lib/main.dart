import 'dart:io';

import 'package:client_android_app/auth/http_overrides.dart';
import 'package:client_android_app/auth/http_requests.dart';
import 'package:client_android_app/auth/login.dart';
import 'package:client_android_app/unsupported_role.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import 'auth/globals.dart';
import 'home.dart';

var storage = const FlutterSecureStorage();

void main() async {
  HttpOverrides.global = LocalHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ClientWebApp());
}

class ClientWebApp extends StatelessWidget {
  const ClientWebApp({super.key});

  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future<String> get jwtToken async {
    var jwt = await storage.read(key: "token");
    if(jwt == null) return "";
    return jwt;
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Client Web App',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: FutureBuilder(
        future: jwtToken,
        builder: (context, snapshot) {
          if(!snapshot.hasData) { return const CircularProgressIndicator();}
          if(snapshot.data != "") {
            var jwt = JwtDecoder.decode(snapshot.data!);

            if (JwtDecoder.isExpired(snapshot.data!)) {
              return LoginPage();
            }
            else {
              print(navigatorKey.currentState!.toString());
              Globals.isLoggedIn = true;
              Globals.keepSession();
              switch (jwt["role"].toString()) {
                case "ADMINISTRATOR":
                case "DOCTOR":
                case "PATIENT":
                  return HomePage(jwt);
                default:
                  return const UnsupportedRole();
              }
            }
          }
          else {
            return LoginPage();
          }
        },

      ),
    );
  }


}

