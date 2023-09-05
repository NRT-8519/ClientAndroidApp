import 'package:client_android_app/auth/http_request.dart';
import 'package:client_android_app/pages/edit_profile.dart';
import 'package:client_android_app/widgets/text_info_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/user.dart';

class MyProfile extends StatefulWidget {
  const MyProfile(this.payload, {super.key});

  final Map<String, dynamic> payload;

  @override
  State<StatefulWidget> createState() => MyProfileState();

}

class MyProfileState extends State<MyProfile> {
  MyProfileState();

  late Map<String, dynamic> payload;

  Future<User> get user async {return await HttpRequests.getUser(payload["jti"].toString()); }

  @override
  void initState() {
    super.initState();
    payload = widget.payload;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Profile"),
        centerTitle: true,
      ),
      body: Center(
        child: FutureBuilder(
          future: user,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Container(
                margin: const EdgeInsets.only(left: 32, right: 32),
                child: ListView(
                  children: [
                    const Icon(Icons.account_circle, size: 78, color: Colors.deepPurple,),
                    Divider(indent: 16, endIndent: 16,),
                    Text(
                      "${snapshot.data!.firstName} ${snapshot.data!.middleName[0]}. ${snapshot.data!.lastName}",
                      style: const TextStyle(fontSize: 24),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      "${snapshot.data!.title}",
                      style: const TextStyle(fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                    Divider(indent: 16, endIndent: 16,),
                    TextInfoCard(
                      color: Colors.grey,
                      width: MediaQuery.of(context).size.width,
                      title: Text("Gender", textAlign: TextAlign.center),
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
                      color: Colors.grey,
                      width: MediaQuery.of(context).size.width,
                      title: Text("Date of Birth", textAlign: TextAlign.center),
                      text: Text ("${snapshot.data!.dateOfBirth.day}/${snapshot.data!.dateOfBirth.month}/${snapshot.data!.dateOfBirth.year}", textAlign: TextAlign.center,),
                    ),
                    TextInfoCard(
                      callback: () async {
                        await Clipboard.setData(ClipboardData(text: "${snapshot.data!.ssn}"));
                      },
                      color: Colors.grey,
                      width: MediaQuery.of(context).size.width,
                      title: Text("Social Security Number", textAlign: TextAlign.center),
                      text: Text ("${snapshot.data!.ssn}", textAlign: TextAlign.center),
                    ),
                    TextInfoCard(
                      callback: () async {
                        await launchUrl(Uri.parse("mailto://${snapshot.data!.email}"));
                      },
                      color: Colors.grey,
                      width: MediaQuery.of(context).size.width,
                      title: Text("Email", textAlign: TextAlign.center),
                      text: Text ("${snapshot.data!.email}", textAlign: TextAlign.center),
                    ),
                    TextInfoCard(
                      callback: () async {
                        await launchUrl(Uri.parse("tel://${snapshot.data!.phoneNumber}"));
                      },
                      color: Colors.grey,
                      width: MediaQuery.of(context).size.width,
                      title: Text("Phone Number", textAlign: TextAlign.center),
                      text: Text ("${snapshot.data!.phoneNumber}", textAlign: TextAlign.center),
                    ),
                    TextInfoCard(
                      callback: () async {
                        await Clipboard.setData(ClipboardData(text: "${snapshot.data!.username}"));
                      },
                      color: Colors.grey,
                      width: MediaQuery.of(context).size.width,
                      title: Text("Username", textAlign: TextAlign.center),
                      text: Text ("${snapshot.data!.username}", textAlign: TextAlign.center),
                    ),
                  ],
                ),
              );

            }
            else {
              return const CircularProgressIndicator();
            }
          }
        )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfile(payload)));
        },
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        shape: const CircleBorder(),
        child: const Icon(Icons.edit),
      ),
    );
  }

}