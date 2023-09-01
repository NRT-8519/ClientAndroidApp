import 'dart:convert';

import 'package:client_android_app/auth/http_request.dart';
import 'package:client_android_app/home.dart';
import 'package:client_android_app/models/jwt.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final storage = const FlutterSecureStorage();

  void displayDialog(context, title, text) => showDialog(
    context: context,
    builder: (context) =>
        AlertDialog(
            title: Text(title),
            content: Text(text)
        ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Log In"), automaticallyImplyLeading: false),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        alignment: Alignment.center,
        child: Column(

          children: [
            Container(
              margin: EdgeInsets.only(top: 165.0, left: 16.0, right: 16.0),
              child: TextField(
                controller: usernameController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Username",
                    errorText: "Username is required!"
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(16),
              child: TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Password",
                    errorText: "Password is required!"
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 16.0, right: 16.0, top: 0.0),
              height: 50.0,
              width: MediaQuery.of(context).size.width,
              child: MaterialButton(

                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                color: Colors.deepPurple,
                textColor: Colors.white,
                child: const Text("Log In"),
                onPressed: () async {
                  var username = usernameController.text;
                  var password = passwordController.text;

                  if (username != "" && password != "") {
                    Response authResponse = await HttpRequests.authenticate(username, password);
                    var jwt = jsonDecode(authResponse.body);
                    JWT jwtToken = JWT(jwt["token"], jwt["referenceToken"], jwt["isAuthSuccessful"], jwt["errorMessage"]);

                    if(jwtToken.isAuthSuccessful) {
                      storage.write(key: "token", value: jwtToken.token);
                      Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(JwtDecoder.decode(jwtToken.token))));
                    }
                    else {
                      displayDialog(context, "An Error Occured", jwt.errorMessage);
                    }
                  }
                },

              ),
            ),
          ],
        ),
      )
    );
  }

}