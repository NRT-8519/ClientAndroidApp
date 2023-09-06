import 'package:client_android_app/auth/http_request.dart';
import 'package:client_android_app/auth/login.dart';
import 'package:client_android_app/pages/administrator/administrators.dart';
import 'package:client_android_app/pages/appointment/appointment_details.dart';
import 'package:client_android_app/pages/appointment/appointments.dart';
import 'package:client_android_app/pages/company/companies.dart';
import 'package:client_android_app/pages/admin/dashboard.dart';
import 'package:client_android_app/pages/doctor/doctor_details.dart';
import 'package:client_android_app/pages/doctor/doctors.dart';
import 'package:client_android_app/pages/issuer/issuers.dart';
import 'package:client_android_app/pages/medicine/medicines.dart';
import 'package:client_android_app/pages/patient/patients.dart';
import 'package:client_android_app/pages/admin/service_reports.dart';
import 'package:client_android_app/pages/my_profile.dart';
import 'package:client_android_app/widgets/appointment_info_card.dart';
import 'package:client_android_app/widgets/dashboard_info_card.dart';
import 'package:client_android_app/widgets/home_info_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';

import 'models/appointment.dart';
import 'models/doctor.dart';
import 'models/paginated_list.dart';
import 'models/patient.dart';

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
  DateTime? currentBackPressTime = DateTime.now();

  void logOut() {
    storage.delete(key: "token");
    Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage()));
  }

  @override
  void initState() {
    super.initState();
    payload = widget.payload;
  }

  Future<int?> get adminCount async { return await HttpRequests.administrator.getCount(); }
  Future<int?> get doctorCount async { return await HttpRequests.doctor.getCount(); }
  Future<int?> get patientCount async { return await HttpRequests.patient.getCount(); }
  Future<int?> get medicineCount async { return await HttpRequests.medicine.getCount(); }
  Future<int?> get companyCount async { return await HttpRequests.company.getCount(); }
  Future<int?> get issuerCount async { return await HttpRequests.issuer.getCount(); }
  Future<int?> get reportCount async { return await HttpRequests.report.getCount(); }
  Future<int?> get requestCount async { return await HttpRequests.request.getCount(payload["jti"].toString()); }
  Future<int?> get prescriptionCount async { return await HttpRequests.prescription.getCount(payload["jti"].toString()); }

  Future<Doctor?> getDoctor(String uuid) async { return await HttpRequests.doctor.get(uuid); }
  Future<Patient?> get patient async { return await HttpRequests.patient.get(payload["jti"].toString()); }

  static DateFormat timeFormat = DateFormat("HH:mm");
  static DateFormat dateFormat = DateFormat("dd/MM/yyyy");

  Future<PaginatedList<Appointment?>> get appointments async {
    if (payload["role"] == "DOCTOR") {
      return await HttpRequests.appointment.getPaged("", "", "", 1, 25, payload["jti"], "", dateTime: DateTime.now());
    }
    else if (payload["role"] == "PATIENT") {
      return await HttpRequests.appointment.getPaged("", "", "", 1, 25, "", payload["jti"], dateTime: DateTime.now());
    }
    else {
      return await HttpRequests.appointment.getPaged("", "", "", 1, 25, "", "", dateTime: DateTime.now());
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: onWillPop,
        child: Scaffold(
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
                          Navigator.push(context, MaterialPageRoute(builder: (context) => ServiceReports(payload)));
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.admin_panel_settings),
                        title: const Text("Administrator Dashboard"),
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
                          Navigator.push(context, MaterialPageRoute(builder: (context) => Patients(payload: payload, doctor: payload["jti"])));
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
                          Navigator.push(context, MaterialPageRoute(builder: (context) => Appointments(payload: payload)));
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
                      FutureBuilder(future: patient, builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return ListTile(
                            leading: const Icon(Icons.person),
                            title: const Text("My Doctor"),
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.push(context, MaterialPageRoute(builder: (context) => DoctorDetails(payload, snapshot.data!.assignedDoctor.uuid!)));
                            },
                          );
                        }
                        else {
                          return ListTile(
                            enabled: false,
                            leading: const Icon(Icons.person),
                            title: const Text("My Doctor"),
                            onTap: () {

                              Navigator.pop(context);
                            },
                          );
                        }
                      }),
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
                          Navigator.push(context, MaterialPageRoute(builder: (context) => Appointments(payload: payload)));
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
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => Doctors(payload: payload)));
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
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => Patients(payload: payload)));
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
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => Administrators(payload: payload)));
                                      },
                                      color:  Colors.red,
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
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => Medicines(payload: payload)));
                                      },
                                      color:  Colors.green,
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
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => Companies(payload: payload)));
                                      },
                                      color:  Colors.green,
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
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => Issuers(payload: payload)));
                                      },
                                      color:  Colors.green,
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
                              FutureBuilder(future: getDoctor(payload["jti"].toString()), builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return HomeInfoCard(
                                      callback: () async {
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => Patients(payload: payload, doctor: payload["jti"])));
                                      },
                                      color: Colors.deepPurple,
                                      icon: Icons.person,
                                      text: const Text("My Patients", style: TextStyle(color: Colors.white)),
                                      count: snapshot.data!.patients.length
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
                              FutureBuilder(
                                  future: requestCount,
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return HomeInfoCard(
                                        callback: () async {

                                        },
                                        color:  Colors.deepPurple,
                                        icon: Icons.question_mark,
                                        text: const Text("Requests", style: TextStyle(color: Colors.white)),
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
                                  }
                              ),
                            ],
                            if (payload["role"].toString() == "PATIENT")... [
                              FutureBuilder(
                                  future: patient,
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return HomeInfoCard(
                                        callback: () async {
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => DoctorDetails(payload, snapshot.data!.assignedDoctor.uuid!)));
                                        },
                                        color: Colors.deepPurple,
                                        icon: Icons.person,
                                        text: const Text("My Doctor", style: TextStyle(color: Colors.white)),
                                        countVisible: false,
                                        countText: "Dr. ${snapshot.data!.assignedDoctor.firstName} ${snapshot.data!.assignedDoctor.lastName}",
                                      );
                                    }
                                    else {
                                      return Container(
                                        padding: const EdgeInsets.all(25),
                                        width: 110,
                                        child: const CircularProgressIndicator(),
                                      );
                                    }
                                  }
                              ),
                              FutureBuilder(
                                  future: prescriptionCount,
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return HomeInfoCard(
                                        callback: () async {

                                        },
                                        color:  Colors.deepPurple,
                                        icon: Icons.receipt_long,
                                        text: const Text("My Prescriptions", style: TextStyle(color: Colors.white)),
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
                                  }
                              ),
                              FutureBuilder(
                                  future: requestCount,
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return HomeInfoCard(
                                          callback: () async {

                                          },
                                          color:  Colors.deepPurple,
                                          icon: Icons.question_mark,
                                          text: const Text("My Requests", style: TextStyle(color: Colors.white)),
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
                                  }

                              )
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
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => ServiceReports(payload)));
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
                      ],
                      if (payload["role"] == "DOCTOR" || payload["role"] == "PATIENT")... [
                        FutureBuilder(
                            future: appointments,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Container(
                                  margin: const EdgeInsets.only(left: 32, right: 32),
                                  child: AppointmentInfoCard(
                                    callback: () async {
                                      await appointments;
                                      setState(() {});
                                    },
                                    width: MediaQuery.of(context).size.width,
                                    height: MediaQuery.of(context).size.height - 376 - 32, //Screen size - above widgets height - margin
                                    icon: Icons.calendar_today,
                                    text: const Text("Appointments for today", style: TextStyle(color: Colors.white),),
                                    color: Colors.blue,
                                    children: [
                                      if(snapshot.data!.items.isNotEmpty)... [
                                        for(int i = 0; i < snapshot.data!.items.length; i++)... [
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.push(context, MaterialPageRoute(builder: (context) => AppointmentDetails(payload, snapshot.data!.items[i]!.id)));
                                            },
                                            child: Container(
                                              margin: const EdgeInsets.only(left: 8, right: 8),
                                              child: HomeInfoCard(
                                                text: Text(snapshot.data!.items[i]!.event, style: const TextStyle(color: Colors.white),),
                                                countText: timeFormat.format(snapshot.data!.items[i]!.scheduledDateTime),
                                                icon: Icons.access_time,
                                                width: MediaQuery.of(context).size.width,
                                                color: Colors.blue,
                                                countVisible: false,
                                              ),
                                            ),
                                          )
                                        ]
                                      ]
                                      else... [
                                        Container(
                                          margin: const EdgeInsets.only(left: 8, right: 8),
                                          child: DashboardInfoCard(
                                            color: Colors.white,
                                            iconColor: Colors.deepPurple,
                                            icon: Icons.done_all,
                                            descriptionText: const Text("No Appointments for today!"),
                                            width: MediaQuery.of(context).size.width,
                                          ),
                                        )
                                      ]
                                    ],
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
                            }
                        )
                      ],
                      if (payload["role"] == "PATIENT")... [

                      ]
                    ],
                  )
                ],
              ),
            )
        ));
  }

  Future<bool> onWillPop() {

    if (!key.currentState!.isDrawerOpen) {
      DateTime now = DateTime.now();
      if (now.difference(currentBackPressTime!) > Duration(seconds: 2)) {
        currentBackPressTime = now;
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Back again to exit."), duration: Duration(seconds: 2),)
        );
        return Future.value(false);
      }
    }
    return Future.value(true);
  }
}