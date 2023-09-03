import 'package:client_android_app/widgets/dashboard_info_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const storage = FlutterSecureStorage();

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => DashboardState();
}

class DashboardState extends State<Dashboard> {

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

              },
              icon: Icons.personal_injury,
              text: Text("Patients", style: TextStyle(color: Colors.white)),
              descriptionText: Text("Add, edit and view patient related data", style: TextStyle(color: Colors.black)),
              width: MediaQuery.of(context).size.width,
              color: Colors.deepPurple,
            ),
            DashboardInfoCard(
              callback: () async {

              },
              icon: Icons.person,
              text: Text("Doctors", style: TextStyle(color: Colors.white)),
              descriptionText: Text("Add, edit and view doctor related data", style: TextStyle(color: Colors.black)),
              width: MediaQuery.of(context).size.width,
              color: Colors.deepPurple,
            ),
            DashboardInfoCard(
              callback: () async {

              },
              icon: Icons.engineering,
              text: Text("Administrators", style: TextStyle(color: Colors.white)),
              descriptionText: Text("Add, edit and view administrator related data", style: TextStyle(color: Colors.black)),
              width: MediaQuery.of(context).size.width,
              color: Colors.red,
            ),
            Divider(),
            DashboardInfoCard(
              callback: () async {

              },
              icon: Icons.medication,
              text: Text("Medicine", style: TextStyle(color: Colors.white)),
              descriptionText: Text("Add, edit and view Medicine related data", style: TextStyle(color: Colors.black)),
              width: MediaQuery.of(context).size.width,
              color: Colors.green,
            ),
            DashboardInfoCard(
              callback: () async {

              },
              icon: Icons.business,
              text: Text("Companies", style: TextStyle(color: Colors.white)),
              descriptionText: Text("Add, edit and view company related data", style: TextStyle(color: Colors.black)),
              width: MediaQuery.of(context).size.width,
              color: Colors.green,
            ),
            DashboardInfoCard(
              callback: () async {

              },
              icon: Icons.work,
              text: Text("Issuers", style: TextStyle(color: Colors.white)),
              descriptionText: Text("Add, edit and view issuer related data", style: TextStyle(color: Colors.black)),
              width: MediaQuery.of(context).size.width,
              color: Colors.green,
            )
          ],
        ),
      ),
    );
  }

}