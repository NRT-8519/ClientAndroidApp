import 'dart:io';
import 'dart:typed_data';

import 'package:client_android_app/auth/http_overrides.dart';
import 'package:client_android_app/auth/login.dart';
import 'package:client_android_app/models/jwt.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert' show json, base64, ascii;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';

import 'home.dart';



void main() async {
  HttpOverrides.global = new LocalHttpOverrides();
  runApp(const ClientWebApp());
}

var storage = FlutterSecureStorage();

class ClientWebApp extends StatelessWidget {
  const ClientWebApp({super.key});

  Future<String> get jwtToken async {
    var jwt = await storage.read(key: "token");
    print(jwt);
    if(jwt == null) return "";
    return jwt;
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
          if(!snapshot.hasData) { return CircularProgressIndicator();}
          if(snapshot.data != "") {
            var jwt = JwtDecoder.decode(snapshot.data!);
            print(jwt.toString());
            if (JwtDecoder.isExpired(snapshot.data!)) {
              return LoginPage();
            }
            else {
              return HomePage(jwt);
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
