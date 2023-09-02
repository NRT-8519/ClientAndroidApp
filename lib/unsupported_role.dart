import 'dart:convert';
import 'package:client_android_app/auth/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import 'models/jwt.dart';

class UnsupportedRole extends StatelessWidget {
  const UnsupportedRole({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Not Found"),
          automaticallyImplyLeading: false),
      body: Center(
        child: Column(
          children: [
            const Text("Unsupported user role"),
            MaterialButton(
              color: Colors.deepPurple,
              textColor: Colors.white70,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              elevation: 4.0,
              padding: const EdgeInsets.all(8.0),
              onPressed: () async => {
                Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()))
              },
              child: const Text("Log Out"),
            ),
          ],
        ),

      ),
    );
  }}
