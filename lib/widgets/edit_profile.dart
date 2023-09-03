import 'dart:ffi';

import 'package:client_android_app/auth/validators.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../auth/http_request.dart';
import '../models/user.dart';

class EditProfile extends StatefulWidget {
  const EditProfile(this.payload, {super.key});

  final Map<String, dynamic> payload;

  @override
  State<StatefulWidget> createState() => EditProfileState();

}

class EditProfileState extends State<EditProfile> {
  EditProfileState();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late Map<String, dynamic> payload;

  Future<User> get user async {return await HttpRequests.getUser(payload["jti"].toString()); }

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

  @override
  void initState() {
    super.initState();
    payload = widget.payload;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit profile"),
        centerTitle: true,
      ),
      body: Center(
        child: FutureBuilder(
          future: user,
          builder: (context, snapshot) {
            if (snapshot.hasData) {

              firstNameController.text = snapshot.data!.firstName;
              middleNameController.text = snapshot.data!.middleName;
              lastNameController.text = snapshot.data!.lastName;
              titleController.text = snapshot.data!.title == null ? "" : snapshot.data!.title!;
              usernameController.text = snapshot.data!.username!;
              genderController.text = snapshot.data!.gender == "M" ? "Male" : "Female";
              dateOfBirthController.text = "${snapshot.data!.dateOfBirth.day}/${snapshot.data!.dateOfBirth.month}/${snapshot.data!.dateOfBirth.year}";
              ssnController.text = snapshot.data!.ssn;
              emailController.text = snapshot.data!.email;
              phoneNumberController.text = snapshot.data!.phoneNumber;

              return Form(
                key: formKey,
                child: ListView(
                  padding: EdgeInsets.only(top: 16),
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 8, left: 16.0, right: 16.0),
                      child: TextFormField(
                        validator: (value) => Validators.validateName(value),
                        controller: firstNameController,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "First name",
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 8, left: 16.0, right: 16.0),
                      child: TextFormField(
                        validator: (value) => Validators.validateName(value),
                        controller: middleNameController,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Middle name",
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 8, left: 16.0, right: 16.0),
                      child: TextFormField(
                        validator: (value) => Validators.validateName(value),
                        controller: lastNameController,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Last name",
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 8, left: 16.0, right: 16.0),
                      child: TextFormField(
                        validator: (value) => Validators.validateTitle(value),
                        controller: titleController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Title",
                        ),
                      ),
                    ),
                    Divider(indent: 16, endIndent: 16,),
                    Container(
                      margin: EdgeInsets.only(top: 8, left: 16.0, right: 16.0),
                      child: TextFormField(
                        controller: usernameController,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Username"
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 8, left: 16.0, right: 16.0),
                      child: TextFormField(
                        validator: (value) => Validators.validatePassword(value),
                        controller: passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Password"
                        ),
                      ),
                    ),
                    Divider(indent: 16, endIndent: 16,),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.only(top: 8, left: 16.0, right: 16.0),
                      child: DropdownButtonFormField(
                        value: snapshot.data!.gender,
                        validator: (value) => Validators.validateGender(value),
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Gender"
                        ),
                        items: const [
                          DropdownMenuItem(value: "", enabled: false, child: Text("Select...")),
                          DropdownMenuItem(value: "M", child: Text("Male")),
                          DropdownMenuItem(value: "F", child: Text("Female"))
                      ],
                        onChanged: (Object? value) {  },
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 8, left: 16.0, right: 16.0),
                      child: TextFormField(
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
                    Divider(indent: 16, endIndent: 16,),
                    Container(
                      margin: EdgeInsets.only(top: 8, left: 16.0, right: 16.0),
                      child: TextFormField(
                        validator: (value) => Validators.validateSSN(value),
                        controller: ssnController,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "SSN"
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 8, left: 16.0, right: 16.0),
                      child: TextFormField(
                        validator: (value) => Validators.validateEmail(value),
                        controller: emailController,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Email"
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 8, left: 16.0, right: 16.0, bottom: 64),
                      child: TextFormField(
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
        onPressed: () {
          if (formKey.currentState!.validate()) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Processing..."))
            );
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