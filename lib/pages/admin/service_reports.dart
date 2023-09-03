import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const storage = FlutterSecureStorage();

class ServiceReports extends StatefulWidget {
  @override
  State<ServiceReports> createState() => ServiceReportsState();
}

class ServiceReportsState extends State<ServiceReports> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Service reports"),
        centerTitle: true,
      ),
    );
  }

}