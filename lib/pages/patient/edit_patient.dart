import 'package:client_android_app/auth/http_request.dart';
import 'package:client_android_app/auth/validators.dart';
import 'package:client_android_app/models/doctor.dart';
import 'package:client_android_app/models/patient.dart';
import 'package:client_android_app/models/user_basic.dart';
import 'package:client_android_app/pages/patient/patients.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

class EditPatient extends StatefulWidget {
  const EditPatient(this.payload, this.patientUUID, {super.key});

  final Map<String, dynamic> payload;
  final String patientUUID;

  @override
  State<StatefulWidget> createState() => EditPatientState();

}

class EditPatientState extends State<EditPatient> {
  EditPatientState();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late Map<String, dynamic> payload;
  late String patientUUID;
  bool submitting = false;

  Patient? patientModel;

  List<Doctor>? doctorsList;

  Future<Patient> get patient async {
    patientModel = await HttpRequests.getPatient(patientUUID);
    return patientModel!;
  }

  Future<List<Doctor>> get doctors async {
    doctorsList = await HttpRequests.getAllDoctors();
    return doctorsList!;
  }

  @override
  void initState() {
    super.initState();
    payload = widget.payload;
    patientUUID = widget.patientUUID;
    setState(() {
      submitting = false;
    });
  }

  TextEditingController firstNameController = TextEditingController();
  TextEditingController middleNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController ssnController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController dateOfBirthController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController assignedDoctorController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Editing patient"),
        centerTitle: true,
      ),
      body: Center(
        child: FutureBuilder(
          future: patient,
          builder: (context, snapshot) {
            if (snapshot.hasData) {

              firstNameController.text = snapshot.data!.firstName;
              middleNameController.text = snapshot.data!.middleName;
              lastNameController.text = snapshot.data!.lastName;
              titleController.text = snapshot.data!.title == null ? "" : snapshot.data!.title!;
              usernameController.text = snapshot.data!.username!;
              genderController.text = snapshot.data!.gender;
              dateOfBirthController.text = "${snapshot.data!.dateOfBirth.day}/${snapshot.data!.dateOfBirth.month}/${snapshot.data!.dateOfBirth.year}";
              ssnController.text = snapshot.data!.ssn;
              emailController.text = snapshot.data!.email;
              phoneNumberController.text = snapshot.data!.phoneNumber;
              assignedDoctorController.text = snapshot.data!.assignedDoctor.uuid!;
              return Form(
                  key: formKey,
                  child: ListView(
                    padding: const EdgeInsets.only(top: 16),
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 8, left: 16.0, right: 16.0),
                        child: TextFormField(
                          enabled: !submitting,
                          validator: (value) => Validators.validateNotEmpty(value),
                          controller: firstNameController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "First name",
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 8, left: 16.0, right: 16.0),
                        child: TextFormField(
                          enabled: !submitting,
                          validator: (value) => Validators.validateNotEmpty(value),
                          controller: middleNameController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Middle name",
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 8, left: 16.0, right: 16.0),
                        child: TextFormField(
                          enabled: !submitting,
                          validator: (value) => Validators.validateNotEmpty(value),
                          controller: lastNameController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Last name",
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 8, left: 16.0, right: 16.0),
                        child: TextFormField(
                          enabled: !submitting,
                          validator: (value) => Validators.validateTitle(value),
                          controller: titleController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Title",
                          ),
                        ),
                      ),
                      const Divider(indent: 16, endIndent: 16,),
                      Container(
                        margin: const EdgeInsets.only(top: 8, left: 16.0, right: 16.0),
                        child: TextFormField(
                          enabled: !submitting,
                          controller: usernameController,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Username"
                          ),
                        ),
                      ),
                      const Divider(indent: 16, endIndent: 16,),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.only(top: 8, left: 16.0, right: 16.0),
                        child: DropdownButtonFormField(
                          value: snapshot.data!.gender,
                          validator: (value) => Validators.validateGender(value),
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Gender",
                          ),
                          items:  [
                            if (!submitting)... [
                              const DropdownMenuItem(value: "", enabled: false, child: Text("Select...")),
                              const DropdownMenuItem(value: "M", child: Text("Male")),
                              const DropdownMenuItem(value: "F", child: Text("Female"))
                            ]
                          ],
                          onChanged: (Object? value) {
                            genderController.text = value.toString();
                          },
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 8, left: 16.0, right: 16.0),
                        child: TextFormField(
                          enabled: !submitting,
                          validator: (value) => Validators.validateDateOfBirth(value),
                          readOnly: true,
                          onTap: () async {
                            DateTime? pickedDateTime = await showDatePicker(
                                context: context,
                                initialDate: snapshot.data!.dateOfBirth,
                                firstDate: DateTime(1901),
                                lastDate: DateTime.now()
                            );

                            if (pickedDateTime != null) {

                              dateOfBirthController.text = "${pickedDateTime.day}/${pickedDateTime.month}/${pickedDateTime.year}";
                            }
                          },
                          controller: dateOfBirthController,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Date of birth"
                          ),
                        ),
                      ),
                      const Divider(indent: 16, endIndent: 16,),
                      FutureBuilder(future: doctors, builder: (context, doctorSnapshot) {
                        if (doctorSnapshot.hasData) {
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
                              value: snapshot.data!.assignedDoctor.uuid,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: "Doctor",
                              ),
                              items:  [
                                const DropdownMenuItem(value: "", enabled: false, child: Text("Select...")),
                                const DropdownMenuItem(value: "00000000-0000-0000-0000-000000000000", enabled: false, child: Text("Don't assign yet")),
                                if (doctorSnapshot.data!.isNotEmpty)... [
                                  for(int i = 0; i < doctorSnapshot.data!.length; i++)... [
                                    DropdownMenuItem(value: doctorSnapshot.data![i].uuid, child: Text("Dr. ${doctorSnapshot.data![i].firstName} ${doctorSnapshot.data![i].lastName}")),
                                  ]
                                ]
                              ],
                              onChanged: (Object? value) {
                                assignedDoctorController.text = value.toString();
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
                      }),
                      Container(
                        margin: const EdgeInsets.only(top: 8, left: 16.0, right: 16.0),
                        child: TextFormField(
                          enabled: !submitting,
                          validator: (value) => Validators.validateSSN(value),
                          controller: ssnController,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "SSN"
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 8, left: 16.0, right: 16.0),
                        child: TextFormField(
                          enabled: !submitting,
                          validator: (value) => Validators.validateEmail(value),
                          controller: emailController,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Email"
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 8, left: 16.0, right: 16.0, bottom: 64),
                        child: TextFormField(
                          enabled: !submitting,
                          validator: (value) => Validators.validatePhoneNumber(value),
                          controller: phoneNumberController,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Phone Number"
                          ),
                        ),
                      ),
                    ],
                  )
              );
            }
            else {
              return const CircularProgressIndicator();
            }
          },
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

            DateFormat format = DateFormat("dd/MM/yyyy");

            Patient patient = Patient(
                patientModel!.uuid,
                firstNameController.text,
                middleNameController.text,
                lastNameController.text,
                titleController.text,
                usernameController.text,
                passwordController.text == "" ? null : passwordController.text,
                emailController.text,
                phoneNumberController.text,
                format.parse(dateOfBirthController.text),
                genderController.text,
                ssnController.text,
                patientModel!.passwordExpiryDate,
                patientModel!.isDisabled,
                patientModel!.isExpired,
                UserBasic(assignedDoctorController.text, "", "", "", "", "")
            );

            Response response = await HttpRequests.putPatient(patient);

            if (response.statusCode != 200) {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Failed to update patient!"))
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
                Navigator.push(context, MaterialPageRoute(builder: (context) => Patients(payload: payload)));
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