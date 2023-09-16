import 'package:client_android_app/home.dart';
import 'package:client_android_app/models/doctor.dart';
import 'package:client_android_app/pages/doctor/doctors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../auth/http_requests.dart';
import '../../../widgets/text_info_card.dart';

class DoctorDetails extends StatefulWidget {
  const DoctorDetails(this.payload, this.doctorUUID, {super.key});

  final Map<String, dynamic> payload;
  final String doctorUUID;
  @override
  State<StatefulWidget> createState() => DoctorDetailsState();
}

class DoctorDetailsState extends State<DoctorDetails> {

  late Map<String, dynamic> payload;
  late String doctorUUID;
  DateFormat expiryFormat = DateFormat("dd/MM/yyyy HH:mm");
  Future<Doctor> get doctor async {
    return await HttpRequests.doctor.get(doctorUUID);
  }
  @override
  void initState() {
    super.initState();
    payload = widget.payload;
    doctorUUID = widget.doctorUUID;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: doctor,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: AppBar(
                title: Text("Doctor: ${snapshot.data!.firstName} ${snapshot.data!.middleName[0]}. ${snapshot.data!.lastName}"),
                centerTitle: true,
                automaticallyImplyLeading: false,
                leading: GestureDetector(
                  onTap: () {
                    if (payload["role"] == "ADMINISTRATOR") {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Doctors(payload: payload)));
                    }
                    else {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(payload)));
                    }
                  },
                  child: const Icon(Icons.arrow_back),
                ),
              ),
              body: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.person, size: 78, color: Colors.deepPurple,),
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
                        if (payload["role"] == "ADMINISTRATOR" || payload["role"] == "DOCTOR")... [
                          TextInfoCard(
                            callback: () async {
                              await Clipboard.setData(ClipboardData(text: "${snapshot.data!.dateOfBirth.day}/${snapshot.data!.dateOfBirth.month}/${snapshot.data!.dateOfBirth.year}"));
                            },
                            color: Colors.deepPurple,
                            width: MediaQuery.of(context).size.width,
                            title: const Text("Date of Birth", textAlign: TextAlign.center, style: TextStyle(color: Colors.white)),
                            text: Text ("${snapshot.data!.dateOfBirth.day}/${snapshot.data!.dateOfBirth.month}/${snapshot.data!.dateOfBirth.year}", textAlign: TextAlign.center,),
                          ),
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
                              await Clipboard.setData(ClipboardData(text: snapshot.data!.username!));
                            },
                            color: Colors.deepPurple,
                            title: const Text("Username", textAlign: TextAlign.center, style: TextStyle(color: Colors.white)),
                            text: Text(snapshot.data!.username!, textAlign: TextAlign.center),
                            width: MediaQuery.of(context).size.width,
                          ),
                        ],
                        TextInfoCard(
                          callback: () async {
                            await Clipboard.setData(ClipboardData(text: snapshot.data!.ssn));
                          },
                          color: Colors.deepPurple,
                          width: MediaQuery.of(context).size.width,
                          title: const Text("Area of Expertise", textAlign: TextAlign.center, style: TextStyle(color: Colors.white)),
                          text: Text (snapshot.data!.areaOfExpertise, textAlign: TextAlign.center),
                        ),
                        TextInfoCard(
                          callback: () async {
                            await Clipboard.setData(ClipboardData(text: snapshot.data!.ssn));
                          },
                          color: Colors.deepPurple,
                          width: MediaQuery.of(context).size.width,
                          title: const Text("Room number", textAlign: TextAlign.center, style: TextStyle(color: Colors.white)),
                          text: Text ("${snapshot.data!.roomNumber}", textAlign: TextAlign.center),
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

                        if (payload["role"] == "ADMINISTRATOR")... [
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
                            title: const Text("Is Account disabled", textAlign: TextAlign.center, style: TextStyle(color: Colors.white)),
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
                          ),
                          Container(
                            padding: const EdgeInsets.all(16),
                            width: MediaQuery.of(context).size.width,
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                    onPressed: snapshot.data!.isExpired ? null : () async {

                                      Doctor doc = Doctor(
                                        snapshot.data!.uuid,
                                        snapshot.data!.firstName,
                                        snapshot.data!.middleName,
                                        snapshot.data!.lastName,
                                        snapshot.data!.title,
                                        snapshot.data!.username,
                                        snapshot.data!.password,
                                        snapshot.data!.email,
                                        snapshot.data!.phoneNumber,
                                        snapshot.data!.dateOfBirth,
                                        snapshot.data!.gender,
                                        snapshot.data!.ssn,
                                        DateTime.now(),
                                        snapshot.data!.isDisabled,
                                        true,
                                        snapshot.data!.areaOfExpertise,
                                        snapshot.data!.roomNumber,
                                        snapshot.data!.patients
                                      );

                                      await HttpRequests.doctor.put(doc);

                                      Navigator.push(context, MaterialPageRoute(builder: (context) => DoctorDetails(payload, doctorUUID)));
                                    },
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                      minimumSize: const Size(160, 40),
                                      backgroundColor: Colors.orange,
                                      foregroundColor: Colors.white,
                                    ),
                                    child: const Text("Force password expiry")
                                ),
                                if (!snapshot.data!.isDisabled)... [
                                  ElevatedButton(
                                      onPressed: () async {
                                        Doctor doc = Doctor(
                                            snapshot.data!.uuid,
                                            snapshot.data!.firstName,
                                            snapshot.data!.middleName,
                                            snapshot.data!.lastName,
                                            snapshot.data!.title,
                                            snapshot.data!.username,
                                            snapshot.data!.password,
                                            snapshot.data!.email,
                                            snapshot.data!.phoneNumber,
                                            snapshot.data!.dateOfBirth,
                                            snapshot.data!.gender,
                                            snapshot.data!.ssn,
                                            snapshot.data!.passwordExpiryDate,
                                            true,
                                            snapshot.data!.isExpired,
                                            snapshot.data!.areaOfExpertise,
                                            snapshot.data!.roomNumber,
                                            snapshot.data!.patients
                                        );

                                        await HttpRequests.doctor.put(doc);

                                        Navigator.push(context, MaterialPageRoute(builder: (context) => DoctorDetails(payload, doctorUUID)));
                                      },
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                        minimumSize: const Size(160, 40),
                                        backgroundColor: Colors.red,
                                        foregroundColor: Colors.white,
                                      ),
                                      child: const Text("Disable account")
                                  ),
                                ]
                                else... [
                                  ElevatedButton(
                                      onPressed: () async {
                                        Doctor doc = Doctor(
                                            snapshot.data!.uuid,
                                            snapshot.data!.firstName,
                                            snapshot.data!.middleName,
                                            snapshot.data!.lastName,
                                            snapshot.data!.title,
                                            snapshot.data!.username,
                                            snapshot.data!.password,
                                            snapshot.data!.email,
                                            snapshot.data!.phoneNumber,
                                            snapshot.data!.dateOfBirth,
                                            snapshot.data!.gender,
                                            snapshot.data!.ssn,
                                            snapshot.data!.passwordExpiryDate,
                                            true,
                                            snapshot.data!.isExpired,
                                            snapshot.data!.areaOfExpertise,
                                            snapshot.data!.roomNumber,
                                            snapshot.data!.patients
                                        );

                                        await HttpRequests.doctor.put(doc);

                                        Navigator.push(context, MaterialPageRoute(builder: (context) => DoctorDetails(payload, doctorUUID)));
                                      },
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                        minimumSize: const Size(160, 40),
                                        backgroundColor: Colors.green,
                                        foregroundColor: Colors.white,
                                      ),
                                      child: const Text("Enable account")
                                  ),
                                ]
                              ],
                            ),
                          )
                        ]
                      ],
                    ),
                  )
              ),
            );
          }
          else {
            return const CircularProgressIndicator();
          }
        }
    );
  }
}