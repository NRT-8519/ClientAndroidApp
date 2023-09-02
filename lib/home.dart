import 'dart:convert';
import 'package:client_android_app/auth/login.dart';
import 'package:client_android_app/models/doctor.dart';
import 'package:client_android_app/widgets/home_info_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import 'models/jwt.dart';

const storage = FlutterSecureStorage();

class HomePage extends StatefulWidget {
  const HomePage(this.payload, {super.key});

  final Map<String, dynamic> payload;

  @override
  State<HomePage> createState() => HomePageState(payload);

}

class HomePageState extends State<HomePage> {
  HomePageState(this.payload);

  final Map<String, dynamic> payload;
  final GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();

  void logOut() {
    storage.delete(key: "token");
    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: key,
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () => key.currentState!.openDrawer(),
        ),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            ListTile(
              leading: Icon(Icons.home),
              contentPadding: const EdgeInsets.only(top: 32.0, left: 16),
              selected: true,
              selectedTileColor: Colors.white,
              title: const Text("Home"),
              onTap: () {

                Navigator.pop(context);
              },
            ),
            if (payload["role"].toString() == "ADMINISTRATOR")... [
              ListTile(
                leading: Icon(Icons.bug_report),
                title: const Text("Service Reports"),
                onTap: () {

                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.admin_panel_settings),
                title: const Text("Administrator Dashboard"),
                onTap: () {

                  Navigator.pop(context);
                },
              ),
            ],
            if (payload["role"].toString() == "DOCTOR")... [
              ListTile(
                leading: Icon(Icons.summarize),
                title: const Text("Notes"),
                onTap: () {

                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.personal_injury),
                title: const Text("Patients"),
                onTap: () {

                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.receipt_long),
                title: const Text("My Prescriptions"),
                onTap: () {

                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.calendar_month),
                title: const Text("Appointments"),
                onTap: () {

                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.question_mark),
                title: const Text("My Requests"),
                onTap: () {

                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.report_problem),
                title: const Text("Report"),
                onTap: () {

                  Navigator.pop(context);
                },
              ),
            ],
            if (payload["role"].toString() == "PATIENT")... [
              ListTile(
                leading: Icon(Icons.person),
                title: const Text("My Doctor"),
                onTap: () {

                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.receipt_long),
                title: const Text("My Prescriptions"),
                onTap: () {

                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.calendar_month),
                title: const Text("Appointments"),
                onTap: () {

                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.question_mark),
                title: const Text("My Requests"),
                onTap: () {

                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.report_problem),
                title: const Text("Report"),
                onTap: () {

                  Navigator.pop(context);
                },
              )
            ],
            Spacer(),
            Divider(),
            ListTile(
              leading: Icon(Icons.manage_accounts),
              title: const Text("My Profile"),
              onTap: () {

                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: const Text("Log Out", style: TextStyle(color: Colors.red),),
              onTap: () {

                logOut();
              },
            )
          ],
        )
      ),
      body: Center(
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 32),
              child: Text("Hello, ${payload["nameid"].toString().split(" ")[0]}!",
                style: TextStyle(
                  fontSize: 28,

                ),
                textAlign: TextAlign.left,
              ),
            ),
            Container(
              height: 172,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.all(32),
                children: [

                  if (payload["role"].toString() == "ADMINISTRATOR")... [
                    HomeInfoCard(
                      callback: () async {

                      },
                      color: const Color.fromARGB(255, 25, 116, 210),
                      icon: Icons.person,
                      text: "Hospital staff",
                    ),
                    HomeInfoCard(
                      callback: () async {

                      },
                      color:  Colors.deepPurpleAccent,
                      icon: Icons.personal_injury,
                      text: "Patients",
                    ),
                    HomeInfoCard(
                      callback: () async {

                      },
                      color:  Colors.greenAccent,
                      icon: Icons.engineering,
                      text: "Administrators",
                    ),
                    HomeInfoCard(
                      callback: () async {

                      },
                      color: const Color.fromARGB(255, 25, 116, 210),
                      icon: Icons.medication,
                      text: "Medicines",
                    ),
                    HomeInfoCard(
                      callback: () async {

                      },
                      color:  Colors.deepPurpleAccent,
                      icon: Icons.business,
                      text: "Companies",
                    ),
                    HomeInfoCard(
                      callback: () async {

                      },
                      color:  Colors.greenAccent,
                      icon: Icons.work,
                      text: "Issuers",
                    ),
                  ],
                  if (payload["role"].toString() == "DOCTOR")... [
                    HomeInfoCard(
                      callback: () async {

                      },
                      color: const Color.fromARGB(255, 25, 116, 210),
                      icon: Icons.person,
                      text: "Patients",
                    ),
                    HomeInfoCard(
                      callback: () async {

                      },
                      color:  Colors.deepOrangeAccent,
                      icon: Icons.question_mark,
                      text: "Requests",
                    ),
                  ],
                  if (payload["role"].toString() == "PATIENT")... [
                    HomeInfoCard(
                      callback: () async {

                      },
                      color: const Color.fromARGB(255, 25, 116, 210),
                      icon: Icons.person,
                      text: "My Doctor",
                    ),
                    HomeInfoCard(
                      callback: () async {

                      },
                      color:  Colors.deepPurpleAccent,
                      icon: Icons.receipt_long,
                      text: "My Prescriptions",
                    ),
                    HomeInfoCard(
                      callback: () async {

                      },
                      color:  Colors.greenAccent,
                      icon: Icons.question_mark,
                      text: "My Requests",
                    ),
                  ]
                ],
              ),
            )
          ],
        ),
      )
    );
  }
}