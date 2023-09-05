import 'package:client_android_app/models/company.dart';
import 'package:client_android_app/models/issuer.dart';
import 'package:client_android_app/models/medicine.dart';
import 'package:client_android_app/pages/admin/company/companies.dart';
import 'package:client_android_app/pages/admin/medicine/medicines.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

import '../../../auth/http_request.dart';
import '../../../auth/validators.dart';
import '../../../models/clearance.dart';

class AddMedicine extends StatefulWidget {
  const AddMedicine(this.payload, {super.key});

  final Map<String, dynamic> payload;

  @override
  State<StatefulWidget> createState() => AddMedicineState();

}

class AddMedicineState extends State<AddMedicine> {

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late Map<String, dynamic> payload;
  bool submitting = false;

  Medicine? medicineModel;

  DateFormat format = DateFormat("dd/MM/yyyy");

  late List<Company?> companiesList;
  late List<Issuer?> issuersList;

  Future<List<Company?>> get companies async {
    companiesList = await HttpRequests.getAllCompanies();

    return companiesList;
  }

  Future<List<Issuer?>> get issuers async {
    issuersList = await HttpRequests.getAllIssuers();

    return issuersList;
  }

  TextEditingController nameController = TextEditingController();
  TextEditingController typeController = TextEditingController();
  TextEditingController dosageController = TextEditingController();
  TextEditingController dosageTypeController = TextEditingController();
  TextEditingController eanController = TextEditingController();
  TextEditingController atcController = TextEditingController();
  TextEditingController uniqueClassificationController = TextEditingController();
  TextEditingController innController = TextEditingController();
  TextEditingController prescriptionTypeController = TextEditingController();
  TextEditingController companyController = TextEditingController();
  TextEditingController issuerController = TextEditingController();
  TextEditingController clearanceController = TextEditingController();
  TextEditingController clearanceDateBeginController = TextEditingController();
  TextEditingController clearanceDateExpiryController = TextEditingController();
  @override
  void initState() {
    super.initState();
    payload = widget.payload;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add new medicine"),
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
                      labelText: "Medicine name",
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.only(top: 8, left: 16.0, right: 16.0),
                  child: DropdownButtonFormField<String>(
                    isExpanded: true,
                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                    validator: (value) {
                      if (typeController.text.isEmpty) {
                        return "Select a type!";
                      }
                      return null;
                    },
                    value: "",
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Type",
                    ),
                    items: [
                      if(!submitting)... [
                        const DropdownMenuItem(value: "", enabled: false, child: Text("Select...")),
                        const DropdownMenuItem(value: "VACCINE", child: Text("Vaccine")),
                        const DropdownMenuItem(value: "RADIOPHARMACEUTICAL", child: Text("Radio-pharmaceutical")),
                        const DropdownMenuItem(value: "HUMANE", child: Text("Humane medicine")),
                        const DropdownMenuItem(value: "HOMEOPATHIC", child: Text("Homeopathic")),
                        const DropdownMenuItem(value: "BIOLOGICAL", child: Text("Biological")),
                        const DropdownMenuItem(value: "BLOOD", child: Text("Blood")),
                        const DropdownMenuItem(value: "TRADITIONAL", child: Text("Traditional")),
                        const DropdownMenuItem(value: "PLANT_BASED", child: Text("Plant based"))
                      ]
                    ],
                    onChanged: (Object? value) {
                      setState(() {
                        typeController.text = value.toString();
                      });
                    },
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 8, left: 16.0, right: 16.0),
                  child: TextFormField(
                    enabled: !submitting,
                    validator: (value) => Validators.validateNotEmpty(value),
                    controller: dosageController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Dosage",
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 8, left: 16.0, right: 16.0),
                  child: TextFormField(
                    enabled: !submitting,
                    validator: (value) => Validators.validateNotEmpty(value),
                    controller: dosageTypeController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Dosage Type",
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 8, left: 16.0, right: 16.0),
                  child: TextFormField(
                    enabled: !submitting,
                    validator: (value) => Validators.validateEAN(value),
                    controller: eanController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "EAN",
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 8, left: 16.0, right: 16.0),
                  child: TextFormField(
                    enabled: !submitting,
                    validator: (value) => Validators.validateATC(value),
                    controller: atcController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "ATC",
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 8, left: 16.0, right: 16.0),
                  child: TextFormField(
                    enabled: !submitting,
                    controller: uniqueClassificationController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Unique Classification",
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 8, left: 16.0, right: 16.0),
                  child: TextFormField(
                    enabled: !submitting,
                    validator: (value) => Validators.validateNotEmpty(value),
                    controller: innController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "INN",
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.only(top: 8, left: 16.0, right: 16.0),
                  child: DropdownButtonFormField<String>(
                    isExpanded: true,
                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                    validator: (value) {
                      if (prescriptionTypeController.text.isEmpty) {
                        return "Select a prescription type!";
                      }
                      return null;
                    },
                    value: "",
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Prescription type",
                    ),
                    items: [
                      if(!submitting)... [
                        const DropdownMenuItem(value: "", enabled: false, child: Text("Select...")),
                        const DropdownMenuItem(value: "Z", child: Text("Admission with special care (Z)")),
                        const DropdownMenuItem(value: "SZ", child: Text("In-hospital addmision only (SZ)")),
                        const DropdownMenuItem(value: "SZR", child: Text("Diagnostic use (SZR)")),
                        const DropdownMenuItem(value: "SZN", child: Text("Opoid (SZN)")),
                        const DropdownMenuItem(value: "BR", child: Text("Without prescription (BR)")),
                        const DropdownMenuItem(value: "R", child: Text("Requires Prescription (R)"))
                      ]
                    ],
                    onChanged: (Object? value) {
                      setState(() {
                        prescriptionTypeController.text = value.toString();
                      });
                    },
                  ),
                ),
                FutureBuilder(future: companies, builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.only(top: 8, left: 16.0, right: 16.0),
                      child: DropdownButtonFormField<String>(
                        isExpanded: true,
                        isDense: true,
                        borderRadius: const BorderRadius.all(Radius.circular(15)),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Select a company!";
                          }
                          return null;
                        },
                        value: "",
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Company",
                        ),
                        items:  [
                          if(!submitting)... [
                            const DropdownMenuItem(value: "", enabled: false, child: Text("Select...")),
                            if (snapshot.data!.isNotEmpty)... [
                              for(int i = 0; i < snapshot.data!.length; i++)... [
                                DropdownMenuItem(value: snapshot.data![i]!.uuid, child: Text(snapshot.data![i]!.name)),
                              ]
                            ]
                          ]
                        ],
                        onChanged: (Object? value) {
                          setState(() {
                            companyController.text = value.toString();
                          });
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
                FutureBuilder(future: issuers, builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.only(top: 8, left: 16.0, right: 16.0),
                      child: DropdownButtonFormField<String>(
                        isDense: true,
                        isExpanded: true,
                        borderRadius: const BorderRadius.all(Radius.circular(15)),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Select an issuer!";
                          }
                          return null;
                        },
                        value: "",
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Issuer",
                        ),
                        items:  [
                          if(!submitting)... [
                            const DropdownMenuItem(value: "", enabled: false, child: Text("Select...")),
                            if (snapshot.data!.isNotEmpty)... [
                              for(int i = 0; i < snapshot.data!.length; i++)... [
                                DropdownMenuItem(value: snapshot.data![i]!.uuid, child: Text(snapshot.data![i]!.name)),
                              ]
                            ]
                          ]
                        ],
                        onChanged: (Object? value) {
                          setState(() {
                            issuerController.text = value.toString();
                          });
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
                    validator: (value) => Validators.validateClearanceNumber(value),
                    controller: clearanceController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Clearance Number",
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 8, left: 16.0, right: 16.0),
                  child: TextFormField(
                    enabled: !submitting,
                    validator: (value) => Validators.validateBeginDate(value),
                    readOnly: true,
                    onTap: () async {
                      DateTime? pickedDateTime = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1901),
                          lastDate: DateTime.now()
                      );

                      if (pickedDateTime != null) {

                        setState(() {
                          clearanceDateBeginController.text = "${pickedDateTime.day}/${pickedDateTime.month}/${pickedDateTime.year}";
                        });
                      }
                    },
                    controller: clearanceDateBeginController,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Begin date"
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 8, left: 16.0, right: 16.0, bottom: 64),
                  child: TextFormField(
                    enabled: !submitting,
                    validator: (value) => Validators.validateExpiryDate(value),
                    readOnly: true,
                    onTap: () async {
                      DateTime? pickedDateTime = await showDatePicker(
                          context: context,
                          initialDate: clearanceDateBeginController.text.isEmpty ? DateTime.now() : format.parse(clearanceDateBeginController.text),
                          firstDate: clearanceDateBeginController.text.isEmpty ? DateTime(1950) : format.parse(clearanceDateBeginController.text),
                          lastDate: DateTime.now().add(const Duration(days: 100 * 365))
                      );

                      if (pickedDateTime != null) {
                        setState(() {
                          clearanceDateExpiryController.text = "${pickedDateTime.day}/${pickedDateTime.month}/${pickedDateTime.year}";
                        });
                      }
                    },
                    controller: clearanceDateExpiryController,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Expiry date"
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

            Medicine medicine = Medicine(
              "00000000-0000-0000-0000-000000000000",
              nameController.text,
              typeController.text,
              dosageController.text,
              dosageTypeController.text,
              eanController.text,
              atcController.text,
              uniqueClassificationController.text,
              innController.text,
              prescriptionTypeController.text,
              await HttpRequests.getCompany(companyController.text),
              await HttpRequests.getIssuer(issuerController.text),
              Clearance("00000000-0000-0000-0000-000000000000", clearanceController.text, format.parse(clearanceDateBeginController.text), format.parse(clearanceDateExpiryController.text))
            );

            Response response = await HttpRequests.postMedicine(medicine);

            if (response.statusCode != 200) {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Failed to add medicine!"))
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
                Navigator.push(context, MaterialPageRoute(builder: (context) => Medicines(payload: payload,)));
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