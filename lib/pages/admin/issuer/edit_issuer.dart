import 'package:client_android_app/models/issuer.dart';
import 'package:client_android_app/pages/admin/company/companies.dart';
import 'package:client_android_app/pages/admin/issuer/issuers.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../../../auth/http_request.dart';
import '../../../auth/validators.dart';

class EditIssuer extends StatefulWidget {
  const EditIssuer(this.payload, this.issuerUUID, {super.key});

  final Map<String, dynamic> payload;
  final String issuerUUID;
  @override
  State<StatefulWidget> createState() => EditIssuerState();

}

class EditIssuerState extends State<EditIssuer> {

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late Map<String, dynamic> payload;
  late String issuerUUID;
  bool submitting = false;

  Issuer? issuerModel;

  TextEditingController nameController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController areaController = TextEditingController();

  Future<Issuer?> get issuer async {
    issuerModel = await HttpRequests.getIssuer(issuerUUID);
    return issuerModel;
  }

  @override
  void initState() {
    super.initState();
    payload = widget.payload;
    issuerUUID = widget.issuerUUID;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Editing issuer"),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: issuer,
        builder: (context, snapshot) {
          if (snapshot.hasData) {

            nameController.text = snapshot.data!.name;
            cityController.text = snapshot.data!.city;
            areaController.text = snapshot.data!.area;

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
                          controller: nameController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Issuer name",
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 8, left: 16.0, right: 16.0),
                        child: TextFormField(
                          enabled: !submitting,
                          validator: (value) => Validators.validateNotEmpty(value),
                          controller: cityController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "City",
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 8, left: 16.0, right: 16.0),
                        child: TextFormField(
                          enabled: !submitting,
                          validator: (value) => Validators.validateNotEmpty(value),
                          controller: areaController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Area",
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
        },
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

            Issuer issuer = Issuer(
                issuerModel!.uuid,
                nameController.text,
                cityController.text,
                areaController.text
            );

            Response response = await HttpRequests.putIssuer(issuer);

            if (response.statusCode != 200) {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Failed to update issuer!"))
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
                Navigator.push(context, MaterialPageRoute(builder: (context) => Issuers(payload: payload,)));
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