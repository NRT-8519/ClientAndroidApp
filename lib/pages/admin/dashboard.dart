import 'package:client_android_app/pages/admin/company/companies.dart';
import 'package:client_android_app/pages/admin/patient/patients.dart';
import 'package:client_android_app/widgets/dashboard_info_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const storage = FlutterSecureStorage();

class Dashboard extends StatefulWidget {
  const Dashboard(this.payload, {super.key});

  final Map<String, dynamic> payload;

  @override
  State<Dashboard> createState() => DashboardState();
}

class DashboardState extends State<Dashboard> {
  DashboardState();

  late Map<String, dynamic> payload;

  @override
  void initState() {
    super.initState();
    payload = widget.payload;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Administrator dashboard"),
        centerTitle: true,
      ),
      body: Center(
        child: ListView(
          children: [
            DashboardInfoCard(
              callback: () async {
                Navigator.push(context, MaterialPageRoute(builder: (context) => Patients(payload: payload)));
              },
              icon: Icons.personal_injury,
              text: const Text("Patients", style: TextStyle(color: Colors.white)),
              descriptionText: const Text("Add, edit and view patient related data", style: TextStyle(color: Colors.black)),
              width: MediaQuery.of(context).size.width,
              color: Colors.deepPurple,
            ),
            DashboardInfoCard(
              callback: () async {

              },
              icon: Icons.person,
              text: const Text("Doctors", style: TextStyle(color: Colors.white)),
              descriptionText: const Text("Add, edit and view doctor related data", style: TextStyle(color: Colors.black)),
              width: MediaQuery.of(context).size.width,
              color: Colors.deepPurple,
            ),
            DashboardInfoCard(
              callback: () async {

              },
              icon: Icons.engineering,
              text: const Text("Administrators", style: TextStyle(color: Colors.white)),
              descriptionText: const Text("Add, edit and view administrator related data", style: TextStyle(color: Colors.black)),
              width: MediaQuery.of(context).size.width,
              color: Colors.red,
            ),
            const Divider(),
            DashboardInfoCard(
              callback: () async {

              },
              icon: Icons.medication,
              text: const Text("Medicine", style: TextStyle(color: Colors.white)),
              descriptionText: const Text("Add, edit and view Medicine related data", style: TextStyle(color: Colors.black)),
              width: MediaQuery.of(context).size.width,
              color: Colors.green,
            ),
            DashboardInfoCard(
              callback: () async {
                Navigator.push(context, MaterialPageRoute(builder: (context) => Companies(payload: payload)));
              },
              icon: Icons.business,
              text: const Text("Companies", style: TextStyle(color: Colors.white)),
              descriptionText: const Text("Add, edit and view company related data", style: TextStyle(color: Colors.black)),
              width: MediaQuery.of(context).size.width,
              color: Colors.green,
            ),
            DashboardInfoCard(
              callback: () async {

              },
              icon: Icons.work,
              text: const Text("Issuers", style: TextStyle(color: Colors.white)),
              descriptionText: const Text("Add, edit and view issuer related data", style: TextStyle(color: Colors.black)),
              width: MediaQuery.of(context).size.width,
              color: Colors.green,
            )
          ],
        ),
      ),
    );
  }
}