import 'package:client_android_app/auth/http_requests.dart';
import 'package:client_android_app/models/appointment.dart';
import 'package:client_android_app/models/doctor.dart';
import 'package:client_android_app/models/patient.dart';
import 'package:client_android_app/pages/appointment/appointments.dart';
import 'package:client_android_app/pages/appointment/edit_appointment.dart';
import 'package:client_android_app/widgets/text_info_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class AppointmentDetails extends StatefulWidget {
  const AppointmentDetails(this.payload, this.id);

  final Map<String, dynamic> payload;
  final int id;
  @override
  State<StatefulWidget> createState() => AppointmentDetailsState();

}

class AppointmentDetailsState extends State<AppointmentDetails> {

  late Map<String, dynamic> payload;
  late int id;
  @override
  void initState() {
    super.initState();
    payload = widget.payload;
    id = widget.id;
  }

  Appointment? appointmentModel;
  DateFormat format = DateFormat("dd/MM/yyyy HH:mm");
  Future<Appointment?> get appointment async {
    appointmentModel = await HttpRequests.appointment.get(id);

    return appointmentModel;
  }

  Future<Doctor?> get doctor async { return await HttpRequests.doctor.get(appointmentModel!.doctorUUID); }
  Future<Patient?> get patient async { return await HttpRequests.patient.get(appointmentModel!.patientUUID); }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Appointment Details"),
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => Appointments(payload: payload)));
          },
          child: Icon(Icons.arrow_back),
        ),
      ),
      body: FutureBuilder(
        future: appointment,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.calendar_today, size: 78, color: Colors.blue,),
                const Divider(indent: 16, endIndent: 16,),
                GestureDetector(
                  onTap: () async {
                    await Clipboard.setData(ClipboardData(text: snapshot.data!.event));
                  },
                  child: Text(
                    snapshot.data!.event,
                    style: const TextStyle(fontSize: 24),
                    textAlign: TextAlign.center,
                  ),
                ),
                const Divider(indent: 16, endIndent: 16,),
                if(payload["role"] == "PATIENT")... [
                  FutureBuilder(future: doctor, builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return TextInfoCard(
                        callback: () async {
                          await Clipboard.setData(ClipboardData(text: "Dr. ${snapshot.data!.firstName} ${snapshot.data!.middleName[0]}. ${snapshot.data!.lastName}"));
                        },
                        color: Colors.blue,
                        title: const Text("Doctor", textAlign: TextAlign.center, style: TextStyle(color: Colors.white)),
                        text: Text("Dr. ${snapshot.data!.firstName} ${snapshot.data!.middleName[0]}. ${snapshot.data!.lastName}", textAlign: TextAlign.center),
                        width: MediaQuery.of(context).size.width,
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
                ],
                if(payload["role"] == "DOCTOR")... [
                  FutureBuilder(future: patient, builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return TextInfoCard(
                        callback: () async {
                          await Clipboard.setData(ClipboardData(text: "${snapshot.data!.firstName} ${snapshot.data!.middleName[0]}. ${snapshot.data!.lastName}"));
                        },
                        color: Colors.blue,
                        title: const Text("Patient", textAlign: TextAlign.center, style: TextStyle(color: Colors.white)),
                        text: Text("${snapshot.data!.firstName} ${snapshot.data!.middleName[0]}. ${snapshot.data!.lastName}", textAlign: TextAlign.center),
                        width: MediaQuery.of(context).size.width,
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
                ],
                TextInfoCard(
                  callback: () async {
                    await Clipboard.setData(ClipboardData(text: format.format(snapshot.data!.scheduledDateTime)));
                  },
                  color: Colors.blue,
                  title: const Text("Scheduled date and time", textAlign: TextAlign.center, style: TextStyle(color: Colors.white)),
                  text: Text(format.format(snapshot.data!.scheduledDateTime), textAlign: TextAlign.center),
                  width: MediaQuery.of(context).size.width,
                )
              ],
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
      ),
      floatingActionButton: payload["role"] == "DOCTOR" ? FloatingActionButton(
        child: Icon(Icons.edit),
        foregroundColor: Colors.white,
        backgroundColor: Colors.blue,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => EditAppointment(payload, id)));
        }
      ) : null,
    );
  }
}
