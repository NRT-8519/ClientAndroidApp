import 'package:client_android_app/auth/validators.dart';
import 'package:client_android_app/pages/my_profile.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

import '../auth/http_requests.dart';
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
  bool submitting = false;

  User? userModel;

  Future<User> get user async {
    userModel = await HttpRequests.administrator.get(payload["jti"].toString());
    return userModel!;
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

  @override
  void initState() {
    super.initState();
    payload = widget.payload;
    setState(() {
      submitting = false;
    });
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
              genderController.text = snapshot.data!.gender;
              dateOfBirthController.text = "${snapshot.data!.dateOfBirth.day}/${snapshot.data!.dateOfBirth.month}/${snapshot.data!.dateOfBirth.year}";
              ssnController.text = snapshot.data!.ssn;
              emailController.text = snapshot.data!.email;
              phoneNumberController.text = snapshot.data!.phoneNumber;

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
                    Container(
                      margin: const EdgeInsets.only(top: 8, left: 16.0, right: 16.0),
                      child: TextFormField(
                        enabled: !submitting,
                        validator: (value) => Validators.validatePassword(value),
                        controller: passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Password"
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

            User user = User(
              userModel!.uuid,
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
              userModel!.passwordExpiryDate,
              userModel!.isDisabled,
              userModel!.isExpired
            );

            Response response = await HttpRequests.administrator.put(user);

            if (response.statusCode != 200) {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Failed to update profile!"))
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
                Navigator.push(context, MaterialPageRoute(builder: (context) => MyProfile(payload)));
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