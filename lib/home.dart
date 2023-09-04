import 'package:client_android_app/auth/http_request.dart';
import 'package:client_android_app/auth/login.dart';
import 'package:client_android_app/pages/admin/dashboard.dart';
import 'package:client_android_app/pages/admin/service_reports.dart';
import 'package:client_android_app/pages/my_profile.dart';
import 'package:client_android_app/widgets/home_info_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const storage = FlutterSecureStorage();

class HomePage extends StatefulWidget {
  const HomePage(this.payload, {super.key});

  final Map<String, dynamic> payload;

  @override
  State<HomePage> createState() => HomePageState();

}

class HomePageState extends State<HomePage> {
  HomePageState();

  late Map<String, dynamic> payload;
  final GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();

  void logOut() {
    storage.delete(key: "token");
    Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage()));
  }

  @override
  void initState() {
    super.initState();
    payload = widget.payload;
  }

  Future<int?> get adminCount async { return await HttpRequests.getAdminCount(); }
  Future<int?> get doctorCount async { return await HttpRequests.getDoctorCount(); }
  Future<int?> get patientCount async { return await HttpRequests.getPatientCount(); }
  Future<int?> get medicineCount async { return await HttpRequests.getMedicineCount(); }
  Future<int?> get companyCount async { return await HttpRequests.getCompanyCount(); }
  Future<int?> get issuerCount async { return await HttpRequests.getIssuerCount(); }
  Future<int?> get reportCount async { return await HttpRequests.getReportCount(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: key,
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => key.currentState!.openDrawer(),
        ),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.home),
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
                leading: const Icon(Icons.bug_report),
                title: const Text("Service Reports"),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ServiceReports()));
                },
              ),
              ListTile(
                leading: const Icon(Icons.admin_panel_settings),
                title: Text("Administrator Dashboard"),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Dashboard(payload)));
                },
              ),
            ],
            if (payload["role"].toString() == "DOCTOR")... [
              ListTile(
                leading: const Icon(Icons.summarize),
                title: const Text("Notes"),
                onTap: () {

                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.personal_injury),
                title: const Text("Patients"),
                onTap: () {

                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.receipt_long),
                title: const Text("My Prescriptions"),
                onTap: () {

                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.calendar_month),
                title: const Text("Appointments"),
                onTap: () {

                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.question_mark),
                title: const Text("My Requests"),
                onTap: () {

                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.report_problem),
                title: const Text("Report"),
                onTap: () {

                  Navigator.pop(context);
                },
              ),
            ],
            if (payload["role"].toString() == "PATIENT")... [
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text("My Doctor"),
                onTap: () {

                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.receipt_long),
                title: const Text("My Prescriptions"),
                onTap: () {

                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.calendar_month),
                title: const Text("Appointments"),
                onTap: () {

                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.question_mark),
                title: const Text("My Requests"),
                onTap: () {

                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.report_problem),
                title: const Text("Report"),
                onTap: () {

                  Navigator.pop(context);
                },
              )
            ],
            const Spacer(),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.manage_accounts),
              title: const Text("My Profile"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => MyProfile(payload)));
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Log Out", style: TextStyle(color: Colors.red),),
              onTap: () {

                logOut();
              },
            )
          ],
        )
      ),
      body: Center(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 32),
                child: Text("Hello, ${payload["nameid"].toString().split(" ")[0]}!",
                  style: const TextStyle(
                    fontSize: 28,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
            ),
            Column(
              children: [
                SizedBox(
                  height: 172,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.all(32),
                    children: [

                      if (payload["role"].toString() == "ADMINISTRATOR")... [
                        FutureBuilder(future: doctorCount, builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return HomeInfoCard(
                              callback: () async {

                              },
                              color: Colors.deepPurple,
                              icon: Icons.person,
                              text: const Text("Hospital staff", style: TextStyle(color: Colors.white)),
                              count: snapshot.data!,
                            );
                          }
                          else {
                            return Container(
                              padding: const EdgeInsets.all(25),
                              width: 110,
                              child: const CircularProgressIndicator(),
                            );
                          }
                        }),
                        FutureBuilder(future: patientCount, builder: (context, snapshot) {
                          if(snapshot.hasData) {
                            return HomeInfoCard(
                                callback: () async {

                                },
                                color:  Colors.deepPurple,
                                icon: Icons.personal_injury,
                                text: const Text("Patients", style: TextStyle(color: Colors.white)),
                                count: snapshot.data!
                            );
                          }
                          else {
                            return Container(
                              padding: const EdgeInsets.all(25),
                              width: 110,
                              child: const CircularProgressIndicator(),
                            );
                          }
                        }),
                        FutureBuilder(future: adminCount, builder: (context, snapshot) {
                          if(snapshot.hasData) {
                            return HomeInfoCard(
                                callback: () async {

                                },
                                color:  Colors.deepPurple,
                                icon: Icons.engineering,
                                text: const Text("Administrators", style: TextStyle(color: Colors.white)),
                                count: snapshot.data!
                            );
                          }
                          else {
                            return Container(
                              padding: const EdgeInsets.all(25),
                              width: 110,
                              child: const CircularProgressIndicator(),
                            );
                          }
                        }),
                        FutureBuilder(future: medicineCount, builder: (context, snapshot) {
                          if(snapshot.hasData) {
                            return HomeInfoCard(
                                callback: () async {

                                },
                                color:  Colors.deepPurple,
                                icon: Icons.medication,
                                text: const Text("Medicines", style: TextStyle(color: Colors.white)),
                                count: snapshot.data!
                            );
                          }
                          else {
                            return Container(
                              padding: const EdgeInsets.all(25),
                              width: 110,
                              child: const CircularProgressIndicator(),
                            );
                          }
                        }),
                        FutureBuilder(future: companyCount, builder: (context, snapshot) {
                          if(snapshot.hasData) {
                            return HomeInfoCard(
                                callback: () async {

                                },
                                color:  Colors.deepPurple,
                                icon: Icons.business,
                                text: const Text("Companies", style: TextStyle(color: Colors.white)),
                                count: snapshot.data!
                            );
                          }
                          else {
                            return Container(
                              padding: const EdgeInsets.all(25),
                              width: 110,
                              child: const CircularProgressIndicator(),
                            );
                          }
                        }),
                        FutureBuilder(future: issuerCount, builder: (context, snapshot) {
                          if(snapshot.hasData) {
                            return HomeInfoCard(
                                callback: () async {

                                },
                                color:  Colors.deepPurple,
                                icon: Icons.work,
                                text: const Text("Issuers", style: TextStyle(color: Colors.white)),
                                count: snapshot.data!
                            );
                          }
                          else {
                            return Container(
                              padding: const EdgeInsets.all(25),
                              width: 110,
                              child: const CircularProgressIndicator(),
                            );
                          }
                        }),
                      ],
                      if (payload["role"].toString() == "DOCTOR")... [
                        HomeInfoCard(
                          callback: () async {

                          },
                          color: Colors.deepPurple,
                          icon: Icons.person,
                          text: const Text("Patients", style: TextStyle(color: Colors.white)),
                        ),
                        HomeInfoCard(
                          callback: () async {

                          },
                          color:  Colors.deepPurple,
                          icon: Icons.question_mark,
                          text: const Text("Requests", style: TextStyle(color: Colors.white)),
                        ),
                      ],
                      if (payload["role"].toString() == "PATIENT")... [
                        HomeInfoCard(
                          callback: () async {

                          },
                          color: Colors.deepPurple,
                          icon: Icons.person,
                          text: const Text("My Doctor", style: TextStyle(color: Colors.white)),
                        ),
                        HomeInfoCard(
                          callback: () async {

                          },
                          color:  Colors.deepPurple,
                          icon: Icons.receipt_long,
                          text: const Text("My Prescriptions", style: TextStyle(color: Colors.white)),
                        ),
                        HomeInfoCard(
                          callback: () async {

                          },
                          color:  Colors.deepPurple,
                          icon: Icons.question_mark,
                          text: const Text("My Requests", style: TextStyle(color: Colors.white)),
                        ),
                      ]
                    ],
                  ),
                ),
                if(payload["role"].toString() == "ADMINISTRATOR")... [
                  FutureBuilder(future: reportCount, builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Container(
                        height: 140,
                        margin: const EdgeInsets.only(left: 32, right: 32),
                        child: HomeInfoCard(
                          callback: () async {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => ServiceReports()));
                          },
                          icon: Icons.bug_report,
                          text: const Text("Service Reports", style: TextStyle(color: Colors.white)),
                          width: MediaQuery.of(context).size.width,
                          count: snapshot.data!,
                        ),
                      );
                    }
                    else {
                      return Container(
                        padding: const EdgeInsets.all(25),
                        width: 88,
                        child: const CircularProgressIndicator(),
                      );
                    }
                  }),
                  Container(
                    height: 140,
                    margin: const EdgeInsets.only(left: 32, right: 32),
                    child: HomeInfoCard(
                      callback: () async {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Dashboard(payload)));
                      },
                      icon: Icons.admin_panel_settings,
                      text: const Text("Administrator Dashboard", style: TextStyle(color: Colors.white)),
                      width: MediaQuery.of(context).size.width,
                      color: Colors.deepOrange,
                      countVisible: false,
                    ),
                  )
                ]
              ],
            )
          ],
        ),
      )
    );
  }
}