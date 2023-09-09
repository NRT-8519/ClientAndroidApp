import 'package:client_android_app/models/company.dart';
import 'package:client_android_app/pages/company/companies.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../../../auth/http_requests.dart';
import '../../../auth/validators.dart';

class EditCompany extends StatefulWidget {
  const EditCompany(this.payload, this.companyUUID, {super.key});

  final Map<String, dynamic> payload;
  final String companyUUID;
  @override
  State<StatefulWidget> createState() => EditCompanyState();

}

class EditCompanyState extends State<EditCompany> {

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late Map<String, dynamic> payload;
  late String companyUUID;
  bool submitting = false;

  Company? companyModel;

  Future<Company?> get company async {
    companyModel = await HttpRequests.company.get(companyUUID);
    return companyModel;
  }

  TextEditingController nameController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    payload = widget.payload;
    companyUUID = widget.companyUUID;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add new company"),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: company,
        builder: (context, snapshot) {
          if (snapshot.hasData) {

            nameController.text = snapshot.data!.name;
            countryController.text = snapshot.data!.country;
            cityController.text = snapshot.data!.city;
            addressController.text = snapshot.data!.address;


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
                          labelText: "Company name",
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 8, left: 16.0, right: 16.0),
                      child: TextFormField(
                        enabled: !submitting,
                        validator: (value) => Validators.validateNotEmpty(value),
                        controller: countryController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Country of origin",
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
                        validator: (value) => Validators.validateTitle(value),
                        controller: addressController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Address",
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

            Company company = Company(
                companyModel!.uuid,
                nameController.text,
                countryController.text,
                cityController.text,
                addressController.text
            );

            Response response = await HttpRequests.company.put(company);

            if (response.statusCode != 200) {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Failed to add company!"))
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
                Navigator.push(context, MaterialPageRoute(builder: (context) => Companies(payload: payload,)));
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