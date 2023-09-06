import 'package:client_android_app/models/appointment.dart';
import 'package:client_android_app/models/issuer.dart';
import 'package:client_android_app/models/patient.dart';
import 'package:client_android_app/pages/appointment/appointment_details.dart';
import 'package:client_android_app/pages/appointment/appointments.dart';
import 'package:client_android_app/pages/company/companies.dart';
import 'package:client_android_app/pages/issuer/issuers.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

import '../../../auth/http_request.dart';
import '../../../auth/validators.dart';

class EditAppointment extends StatefulWidget {
  const EditAppointment(this.payload, this.id, {super.key});

  final Map<String, dynamic> payload;
  final int id;

  @override
  State<StatefulWidget> createState() => EditAppointmentState();

}

class EditAppointmentState extends State<EditAppointment> {

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late Map<String, dynamic> payload;
  late int id;

  bool submitting = false;

  TextEditingController eventController = TextEditingController();
  TextEditingController patientController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  DateFormat dateFormat = DateFormat("dd/MM/yyyy");
  DateFormat timeFormat = DateFormat("HH:mm");
  Appointment? appointmentModel;

  Future<Appointment?> get appointment async {
    appointmentModel = await HttpRequests.appointment.get(id);

    return appointmentModel;
  }

  @override
  void initState() {
    super.initState();
    payload = widget.payload;
    id = widget.id;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Editing Appointment"),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: appointment,
        builder: (context, snapshot) {
          if (snapshot.hasData) {

            eventController.text = snapshot.data!.event;
            patientController.text = snapshot.data!.patientUUID;
            dateController.text = dateFormat.format(snapshot.data!.scheduledDateTime);
            timeController.text = timeFormat.format(snapshot.data!.scheduledDateTime);

            return Center(
              child: Form(
                  key: formKey,
                  child: ListView(
                    padding: const EdgeInsets.only(top: 16),
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 8, left: 16.0, right: 16.0),
                        child: TextFormField(
                          enabled: !submitting,
                          validator: (value) => Validators.validateNotEmpty(value),
                          controller: eventController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Event",
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 8, left: 16.0, right: 16.0),
                        child: TextFormField(
                          enabled: !submitting,
                          validator: (value) => Validators.validateAppointmentDate(value),
                          readOnly: true,
                          onTap: () async {
                            DateTime? pickedDateTime = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate: DateTime.now().add(const Duration(days: 180))
                            );

                            if (pickedDateTime != null) {

                              dateController.text = dateFormat.format(pickedDateTime);
                            }
                          },
                          controller: dateController,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Date"
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 8, left: 16.0, right: 16.0),
                        child: TextFormField(
                          enabled: !submitting,
                          validator: (value) => Validators.validateAppointmentTime(value),
                          readOnly: true,
                          onTap: () async {
                            TimeOfDay? pickedDateTime = await showTimePicker(
                              initialEntryMode: TimePickerEntryMode.dialOnly,
                              context: context,
                              initialTime: TimeOfDay.now(),
                              builder: (BuildContext context, Widget? child) {
                                return MediaQuery(
                                    data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
                                    child: child ?? Container()
                                );
                              },
                            );

                            if (pickedDateTime != null) {

                              timeController.text = "${pickedDateTime.hour}:${pickedDateTime.minute}";
                            }
                          },
                          controller: timeController,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Time of day"
                          ),
                        ),
                      )
                    ],
                  )
              ),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (formKey.currentState!.validate()) {
            setState(() {
              submitting = true;
            });
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Processing..."))
            );

            DateFormat format = DateFormat("dd/MM/yyyy HH:mm");

            Appointment appointment = Appointment(
              appointmentModel!.id,
              appointmentModel!.doctorUUID,
              patientController.text,
              format.parse("${dateController.text} ${timeController.text}"),
              eventController.text,
            );

            Response response = await HttpRequests.appointment.put(appointment);

            if (response.statusCode != 200) {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Failed to update appointment!"))
              );
              setState(() {
                submitting = false;
              });
            }
            else {
              await Future.delayed(const Duration(seconds: 2), () {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Success!"))
                );
                Navigator.push(context, MaterialPageRoute(builder: (context) => AppointmentDetails(payload, id)));
              });
            }
          }
        },
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        shape: const CircleBorder(),
        child: const Icon(Icons.done),
      ),
    );
  }

}