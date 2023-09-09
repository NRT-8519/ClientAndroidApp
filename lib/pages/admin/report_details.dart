import 'package:client_android_app/auth/http_requests.dart';
import 'package:client_android_app/home.dart';
import 'package:client_android_app/models/report.dart';
import 'package:client_android_app/models/user.dart';
import 'package:client_android_app/pages/admin/service_reports.dart';
import 'package:client_android_app/widgets/text_info_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class ReportDetails extends StatefulWidget {

  final Map<String, dynamic> payload;
  final String reportUUID;

  const ReportDetails(this.payload, this.reportUUID, {super.key});

  @override
  State<StatefulWidget> createState() => ReportDetailsState();
}

class ReportDetailsState extends State<ReportDetails> {

  late Map<String, dynamic> payload;
  late String reportUUID;

  DateFormat format = DateFormat("dd/MM/yyyy HH:mm");

  Report? reportModel;
  User? userModel;

  Future<Report?> get report async {
    reportModel = await HttpRequests.report.get(reportUUID);

    return reportModel;
  }

  Future<User?> get user async {
    userModel = await HttpRequests.administrator.get(reportModel!.reportedBy);

    return userModel;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    payload = widget.payload;
    reportUUID = widget.reportUUID;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Report details"),
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: GestureDetector(
          child: Icon(Icons.arrow_back),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => ServiceReports(payload)));
          },
        ),
      ),
      body: FutureBuilder(
        future: report,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.bug_report, size: 78, color: Colors.lightBlue),
                      const Divider(indent: 16, endIndent: 16,),
                      GestureDetector(
                        onTap: () async {
                          await Clipboard.setData(ClipboardData(text: snapshot.data!.title));
                        },
                        child: Text(
                          snapshot.data!.title,
                          style: const TextStyle(fontSize: 24),
                          textAlign: TextAlign.center,

                        ),
                      ),
                      const Divider(indent: 16, endIndent: 16,),
                      TextInfoCard(
                        callback: () async {
                          await Clipboard.setData(ClipboardData(text: snapshot.data!.description));
                        },
                        color: Colors.lightBlue,
                        title: const Text("Description", textAlign: TextAlign.center, style: TextStyle(color: Colors.white)),
                        text: Text(snapshot.data!.description, textAlign: TextAlign.center),
                        width: MediaQuery.of(context).size.width,
                      ),
                      TextInfoCard(
                        callback: () async {
                          await Clipboard.setData(ClipboardData(text: format.format(snapshot.data!.date)));
                        },
                        color: Colors.lightBlue,
                        title: const Text("Date reported", textAlign: TextAlign.center, style: TextStyle(color: Colors.white)),
                        text: Text(format.format(snapshot.data!.date), textAlign: TextAlign.center),
                        width: MediaQuery.of(context).size.width,
                      ),
                      FutureBuilder(
                          future: user,
                          builder: (context, userSnapshot) {
                            if (userSnapshot.hasData) {
                              return TextInfoCard(
                                callback: () async {
                                  await Clipboard.setData(ClipboardData(text: "${userSnapshot.data!.firstName} ${userSnapshot.data!.middleName[0]}. ${userSnapshot.data!.lastName}"));
                                },
                                color: Colors.lightBlue,
                                title: const Text("Reported By", textAlign: TextAlign.center, style: TextStyle(color: Colors.white)),
                                text: Text("${userSnapshot.data!.firstName} ${userSnapshot.data!.middleName[0]}. ${userSnapshot.data!.lastName}"  , textAlign: TextAlign.center),
                                width: MediaQuery.of(context).size.width,
                              );
                            }
                            else {
                              return Container(
                                alignment: Alignment.center,
                                width: 60,
                                height: 60,
                                child: const CircularProgressIndicator(),
                              );
                            }
                          }
                      ),
                      TextInfoCard(
                        callback: () async {
                          await Clipboard.setData(ClipboardData(text: snapshot.data!.reportedBy));
                        },
                        color: Colors.lightBlue,
                        title: const Text("Reported By (UUID)", textAlign: TextAlign.center, style: TextStyle(color: Colors.white)),
                        text: Text(snapshot.data!.reportedBy, textAlign: TextAlign.center),
                        width: MediaQuery.of(context).size.width,
                      )
                    ],
                  ),
                )
            );
          }
          else {
            return Container(
              alignment: Alignment.center,
              width: 60,
              height: 60,
              child: const CircularProgressIndicator(),
            );
          }
        },
      )
    );
  }
}