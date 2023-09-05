import 'package:client_android_app/models/company.dart';
import 'package:client_android_app/pages/admin/company/companies.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../../../auth/http_request.dart';
import '../../../auth/validators.dart';

class AddCompany extends StatefulWidget {
  const AddCompany(this.payload, {super.key});

  final Map<String, dynamic> payload;

  @override
  State<StatefulWidget> createState() => AddCompanyState();

}

class AddCompanyState extends State<AddCompany> {

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late Map<String, dynamic> payload;
  bool submitting = false;

  Company? companyModel;

  TextEditingController nameController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    payload = widget.payload;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add new company"),
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
                "00000000-0000-0000-0000-000000000000",
                nameController.text,
                countryController.text,
                cityController.text,
                addressController.text
            );

            Response response = await HttpRequests.postCompany(company);

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
        child: const Icon(Icons.add),
      ),
    );
  }

}