import 'package:client_android_app/models/appointment.dart';
import 'package:client_android_app/models/doctor.dart';
import 'package:client_android_app/models/issuer.dart';
import 'package:client_android_app/models/patient.dart';
import 'package:client_android_app/pages/appointment/appointments.dart';
import 'package:client_android_app/pages/company/companies.dart';
import 'package:client_android_app/pages/issuer/issuers.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

import '../../../auth/http_requests.dart';
import '../../../auth/validators.dart';

class AddAppointment extends StatefulWidget {
  const AddAppointment(this.payload, {super.key});

  final Map<String, dynamic> payload;

  @override
  State<StatefulWidget> createState() => AddAppointmentState();

}

class AddAppointmentState extends State<AddAppointment> {

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late Map<String, dynamic> payload;
  bool submitting = false;

  TextEditingController eventController = TextEditingController();
  TextEditingController patientController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  DateFormat dateFormat = DateFormat("dd/MM/yyyy");

  Future<Doctor?> get doctor async {
    return await HttpRequests.doctor.get(payload["jti"]);
  }

  @override
  void initState() {
    super.initState();
    payload = widget.payload;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create a new appointment"),
        centerTitle: true,
      ),
      body: Center(
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
                FutureBuilder(
                  future: doctor,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.only(top: 8, left: 16.0, right: 16.0),
                        child: DropdownButtonFormField<String>(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Select a doctor, or 'Don't assign yet'";
                            }
                            return null;
                          },
                          value: "",
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Patient",
                          ),
                          items:  [
                            const DropdownMenuItem(value: "", enabled: false, child: Text("Select...")),
                            if (snapshot.data!.patients.isNotEmpty)... [
                              for(int i = 0; i < snapshot.data!.patients.length; i++)... [
                                DropdownMenuItem(value: snapshot.data!.patients[i].uuid, child: Text("${snapshot.data!.patients[i].firstName} ${snapshot.data!.patients[i].lastName}")),
                              ]
                            ]
                          ],
                          onChanged: (Object? value) {
                            patientController.text = value.toString();
                          },
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
              0,
              payload["jti"],
              patientController.text,
              format.parse("${dateController.text} ${timeController.text}"),
              eventController.text,
            );

            Response response = await HttpRequests.appointment.post(appointment);

            if (response.statusCode != 200) {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Failed to create an appointment!"))
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
                Navigator.push(context, MaterialPageRoute(builder: (context) => Appointments(payload: payload,)));
              });
            }
          }
        },
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
    );
  }

}