import 'package:client_android_app/models/doctor.dart';
import 'package:client_android_app/pages/doctor/doctors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

import '../../../auth/http_requests.dart';
import '../../../auth/validators.dart';
import '../../../models/user.dart';

class AddDoctor extends StatefulWidget {
  const AddDoctor(this.payload, {super.key});

  final Map<String, dynamic> payload;

  @override
  State<StatefulWidget> createState() => AddDoctorState();

}

class AddDoctorState extends State<AddDoctor> {

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late Map<String, dynamic> payload;
  bool submitting = false;

  Doctor? doctorModel;

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
  TextEditingController areaOfExpertiseController = TextEditingController();
  TextEditingController roomNumberController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    payload = widget.payload;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add new doctor"),
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
                    validator: (value) => Validators.validateNotEmpty(value),
                    controller: areaOfExpertiseController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Area of Expertise",
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 8, left: 16.0, right: 16.0),
                  child: TextFormField(
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    keyboardType: TextInputType.number,
                    enabled: !submitting,
                    validator: (value) => Validators.validateRoomNumber(value),
                    controller: roomNumberController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Room number",
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 8, left: 16.0, right: 16.0),
                  child: TextFormField(
                    enabled: !submitting,
                    validator: (value) => Validators.validateUsername(value),
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
                    value: "",
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
                          initialDate: DateTime.now(),
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

            Doctor doctor = Doctor(
                "00000000-0000-0000-0000-000000000000",
                firstNameController.text,
                middleNameController.text,
                lastNameController.text,
                titleController.text,
                usernameController.text,
                passwordController.text,
                emailController.text,
                phoneNumberController.text,
                format.parse(dateOfBirthController.text),
                genderController.text,
                ssnController.text,
                DateTime.now().add(Duration(days: 180)),
                false,
                false,
                areaOfExpertiseController.text,
                int.parse(roomNumberController.text),
                []
            );

            Response response = await HttpRequests.doctor.post(doctor);

            if (response.statusCode != 200) {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Failed to add doctor!"))
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
                Navigator.push(context, MaterialPageRoute(builder: (context) => Doctors(payload: payload,)));
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