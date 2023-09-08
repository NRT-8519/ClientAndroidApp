import 'package:client_android_app/models/patient.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../auth/http_request.dart';
import '../../../widgets/text_info_card.dart';
import '../doctor/doctor_details.dart';

class PatientDetails extends StatefulWidget {
  const PatientDetails(this.payload, this.patientUUID, {super.key});

  final Map<String, dynamic> payload;
  final String patientUUID;
  @override
  State<StatefulWidget> createState() => PatientDetailsState();
}

class PatientDetailsState extends State<PatientDetails> {

  late Map<String, dynamic> payload;
  late String patientUUID;
  DateFormat expiryFormat = DateFormat("dd/MM/yyyy HH:mm");
  Future<Patient?> get patient async {
    return await HttpRequests.patient.get(patientUUID);
  }
  @override
  void initState() {
    super.initState();
    payload = widget.payload;
    patientUUID = widget.patientUUID;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Patient details"),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: patient,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.personal_injury, size: 78, color: Colors.deepPurple,),
                      const Divider(indent: 16, endIndent: 16,),
                      GestureDetector(
                        onTap: () async {
                          await Clipboard.setData(ClipboardData(text: "${snapshot.data!.firstName} ${snapshot.data!.middleName[0]}. ${snapshot.data!.lastName}"));
                        },
                        child: Text(
                          "${snapshot.data!.firstName} ${snapshot.data!.middleName[0]}. ${snapshot.data!.lastName}",
                          style: const TextStyle(fontSize: 24),
                          textAlign: TextAlign.center,

                        ),
                      ),
                      Text("${snapshot.data!.title}", style: const TextStyle(fontSize: 14),),
                      const Divider(indent: 16, endIndent: 16,),
                      TextInfoCard(
                        callback: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: snapshot.data!.gender == "M" ? const Text("Male") : const Text("Female"))
                          );
                        },
                        color: Colors.deepPurple,
                        width: MediaQuery.of(context).size.width,
                        title: const Text("Gender", textAlign: TextAlign.center, style: TextStyle(color: Colors.white),),
                        text: Container(
                          child: snapshot.data!.gender == "M" ?
                          const Icon(Icons.male, size: 36, color: Colors.lightBlue,) :
                          snapshot.data!.gender == "F" ?
                          const Icon(Icons.female, size: 36, color: Colors.pinkAccent) :
                          const Icon(Icons.device_unknown, size: 36, color: Colors.deepPurple),
                        ),
                      ),
                      TextInfoCard(
                        callback: () async {
                          await Clipboard.setData(ClipboardData(text: "${snapshot.data!.dateOfBirth.day}/${snapshot.data!.dateOfBirth.month}/${snapshot.data!.dateOfBirth.year}"));
                        },
                        color: Colors.deepPurple,
                        width: MediaQuery.of(context).size.width,
                        title: const Text("Date of Birth", textAlign: TextAlign.center, style: TextStyle(color: Colors.white)),
                        text: Text ("${snapshot.data!.dateOfBirth.day}/${snapshot.data!.dateOfBirth.month}/${snapshot.data!.dateOfBirth.year}", textAlign: TextAlign.center,),
                      ),
                      if(payload["jti"] == "ADMINISTRATOR")... [

                        TextInfoCard(
                          callback: () async {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => DoctorDetails(payload, snapshot.data!.assignedDoctor.uuid!)));
                          },
                          color: Colors.deepPurple,
                          width: MediaQuery.of(context).size.width,
                          title: const Text("Assigned Doctor", textAlign: TextAlign.center, style: TextStyle(color: Colors.white)),
                          text: Text (snapshot.data!.assignedDoctor.uuid! == "00000000-0000-0000-0000-000000000000" ? "Not yet assigned" : "Dr. ${snapshot.data!.assignedDoctor.firstName} ${snapshot.data!.assignedDoctor.middleName[0]}. ${snapshot.data!.assignedDoctor.lastName}", textAlign: TextAlign.center),
                        ),
                      ],
                      TextInfoCard(
                        callback: () async {
                          await Clipboard.setData(ClipboardData(text: snapshot.data!.ssn));
                        },
                        color: Colors.deepPurple,
                        width: MediaQuery.of(context).size.width,
                        title: const Text("Social Security Number", textAlign: TextAlign.center, style: TextStyle(color: Colors.white)),
                        text: Text (snapshot.data!.ssn, textAlign: TextAlign.center),
                      ),
                      TextInfoCard(
                        callback: () async {
                          await launchUrl(Uri.parse("mailto://${snapshot.data!.email}"));
                        },
                        color: Colors.deepPurple,
                        width: MediaQuery.of(context).size.width,
                        title: const Text("Email", textAlign: TextAlign.center, style: TextStyle(color: Colors.white)),
                        text: Text (snapshot.data!.email, textAlign: TextAlign.center),
                      ),
                      TextInfoCard(
                        callback: () async {
                          await launchUrl(Uri.parse("tel://${snapshot.data!.phoneNumber}"));
                        },
                        color: Colors.deepPurple,
                        width: MediaQuery.of(context).size.width,
                        title: const Text("Phone Number", textAlign: TextAlign.center, style: TextStyle(color: Colors.white)),
                        text: Text (snapshot.data!.phoneNumber, textAlign: TextAlign.center),
                      ),
                      if(payload["jti"] == "ADMINISTRATOR")... [
                        TextInfoCard(
                          callback: () async {
                            await Clipboard.setData(ClipboardData(text: snapshot.data!.username!));
                          },
                          color: Colors.deepPurple,
                          title: const Text("Username", textAlign: TextAlign.center, style: TextStyle(color: Colors.white)),
                          text: Text(snapshot.data!.username!, textAlign: TextAlign.center),
                          width: MediaQuery.of(context).size.width,
                        ),
                        TextInfoCard(
                          callback: () async {
                            await Clipboard.setData(ClipboardData(text: expiryFormat.format(snapshot.data!.passwordExpiryDate)));
                          },
                          color: Colors.deepPurple,
                          width: MediaQuery.of(context).size.width,
                          title: const Text("Password Expiry", textAlign: TextAlign.center, style: TextStyle(color: Colors.white)),
                          text: Text (expiryFormat.format(snapshot.data!.passwordExpiryDate), textAlign: TextAlign.center,),
                        ),
                        TextInfoCard(
                          color: Colors.deepPurple,
                          width: MediaQuery.of(context).size.width,
                          title: const Text("Is Password expired", textAlign: TextAlign.center, style: TextStyle(color: Colors.white)),
                          text: Text (snapshot.data!.isExpired ? "Yes" : "No", textAlign: TextAlign.center,),
                        ),
                        TextInfoCard(
                          color: Colors.deepPurple,
                          width: MediaQuery.of(context).size.width,
                          title: const Text("Is Account expired", textAlign: TextAlign.center, style: TextStyle(color: Colors.white)),
                          text: Text (snapshot.data!.isDisabled ? "Yes" : "No", textAlign: TextAlign.center,),
                        ),
                        TextInfoCard(
                          callback: () async {
                            await Clipboard.setData(ClipboardData(text: snapshot.data!.uuid!));
                          },
                          color: Colors.deepPurple,
                          title: const Text("UUID", textAlign: TextAlign.center, style: TextStyle(color: Colors.white)),
                          text: Text(snapshot.data!.uuid!, textAlign: TextAlign.center),
                          width: MediaQuery.of(context).size.width,
                        )
                      ]
                    ],
                  ),
                )
            );
          }
          else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        }
    ),

    );

  }
}