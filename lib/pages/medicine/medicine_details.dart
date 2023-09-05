import 'package:client_android_app/models/medicine.dart';
import 'package:client_android_app/pages/company/company_details.dart';
import 'package:client_android_app/pages/issuer/issuer_details.dart';
import 'package:client_android_app/widgets/text_info_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'package:client_android_app/auth/http_request.dart';

class MedicineDetails extends StatefulWidget {
  const MedicineDetails(this.payload, this.medicineUUID, {super.key});

  final Map<String, dynamic> payload;
  final String medicineUUID;

  @override
  State<StatefulWidget> createState() => MedicineDetailsState();
}

class MedicineDetailsState extends State<MedicineDetails> {

  late Map<String, dynamic> payload;
  late String medicineUUID;

  DateFormat dateFormat = DateFormat("dd/MM/yyyy");

  Future<Medicine> get medicine async {
    return await HttpRequests.getMedicine(medicineUUID);
  }

  @override
  void initState() {
    super.initState();
    payload = widget.payload;
    medicineUUID = widget.medicineUUID;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: medicine,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              title: Text("Company: ${snapshot.data!.name}"),
              centerTitle: true,
            ),
            body: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.business, size: 78, color: Colors.green,),
                    const Divider(indent: 16, endIndent: 16,),
                    GestureDetector(
                      onTap: () async {
                        await Clipboard.setData(ClipboardData(text: snapshot.data!.name));
                      },
                      child: Text(
                        snapshot.data!.name,
                        style: const TextStyle(fontSize: 24),
                        textAlign: TextAlign.center,

                      ),
                    ),
                    const Divider(indent: 16, endIndent: 16,),
                    TextInfoCard(
                      callback: () async {
                        await Clipboard.setData(ClipboardData(text: snapshot.data!.type));
                      },
                      color: Colors.green,
                      title: const Text("Type", textAlign: TextAlign.center, style: TextStyle(color: Colors.white)),
                      text: Text(snapshot.data!.type, textAlign: TextAlign.center),
                      width: MediaQuery.of(context).size.width,
                    ),
                    TextInfoCard(
                      callback: () async {
                        await Clipboard.setData(ClipboardData(text: snapshot.data!.dosage));
                      },
                      color: Colors.green,
                      title: const Text("Dosage", textAlign: TextAlign.center, style: TextStyle(color: Colors.white)),
                      text: Text(snapshot.data!.dosage  , textAlign: TextAlign.center),
                      width: MediaQuery.of(context).size.width,
                    ),
                    TextInfoCard(
                      callback: () async {
                        await Clipboard.setData(ClipboardData(text: snapshot.data!.dosageType));
                      },
                      color: Colors.green,
                      title: const Text("Dosage type", textAlign: TextAlign.center, style: TextStyle(color: Colors.white)),
                      text: Text(snapshot.data!.dosageType, textAlign: TextAlign.center),
                      width: MediaQuery.of(context).size.width,
                    ),
                    TextInfoCard(
                      callback: () async {
                        await Clipboard.setData(ClipboardData(text: snapshot.data!.ean));
                      },
                      color: Colors.green,
                      title: const Text("EAN", textAlign: TextAlign.center, style: TextStyle(color: Colors.white)),
                      text: Text(snapshot.data!.ean, textAlign: TextAlign.center),
                      width: MediaQuery.of(context).size.width,
                    ),
                    TextInfoCard(
                      callback: () async {
                        await Clipboard.setData(ClipboardData(text: snapshot.data!.atc));
                      },
                      color: Colors.green,
                      title: const Text("ATC", textAlign: TextAlign.center, style: TextStyle(color: Colors.white)),
                      text: Text(snapshot.data!.atc, textAlign: TextAlign.center),
                      width: MediaQuery.of(context).size.width,
                    ),
                    TextInfoCard(
                      callback: () async {
                        await Clipboard.setData(ClipboardData(text: snapshot.data!.uniqueClassification));
                      },
                      color: Colors.green,
                      title: const Text("Unique Classification", textAlign: TextAlign.center, style: TextStyle(color: Colors.white)),
                      text: Text(snapshot.data!.uniqueClassification, textAlign: TextAlign.center),
                      width: MediaQuery.of(context).size.width,
                    ),
                    TextInfoCard(
                      callback: () async {
                        await Clipboard.setData(ClipboardData(text: snapshot.data!.inn));
                      },
                      color: Colors.green,
                      title: const Text("INN", textAlign: TextAlign.center, style: TextStyle(color: Colors.white)),
                      text: Text(snapshot.data!.inn, textAlign: TextAlign.center),
                      width: MediaQuery.of(context).size.width,
                    ),
                    TextInfoCard(
                      callback: () async {
                        await Clipboard.setData(ClipboardData(text: snapshot.data!.prescriptionType));
                      },
                      color: Colors.green,
                      title: const Text("Prescription Type", textAlign: TextAlign.center, style: TextStyle(color: Colors.white)),
                      text: Text(snapshot.data!.prescriptionType, textAlign: TextAlign.center),
                      width: MediaQuery.of(context).size.width,
                    ),
                    TextInfoCard(
                      callback: () async {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => CompanyDetails(payload, snapshot.data!.company.uuid)));
                      },
                      color: Colors.green,
                      title: const Text("Company", textAlign: TextAlign.center, style: TextStyle(color: Colors.white)),
                      text: Text(snapshot.data!.company.name, textAlign: TextAlign.center),
                      width: MediaQuery.of(context).size.width,
                    ),TextInfoCard(
                      callback: () async {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => IssuerDetails(payload, snapshot.data!.issuer.uuid)));
                      },
                      color: Colors.green,
                      title: const Text("Issuer", textAlign: TextAlign.center, style: TextStyle(color: Colors.white)),
                      text: Text(snapshot.data!.issuer.name, textAlign: TextAlign.center),
                      width: MediaQuery.of(context).size.width,
                    ),
                    TextInfoCard(
                      callback: () async {
                        await Clipboard.setData(ClipboardData(text: snapshot.data!.clearance.clearanceNumber));
                      },
                      color: Colors.green,
                      title: const Text("Clearance Number", textAlign: TextAlign.center, style: TextStyle(color: Colors.white)),
                      text: Text(snapshot.data!.clearance.clearanceNumber, textAlign: TextAlign.center),
                      width: MediaQuery.of(context).size.width,
                    ),
                    TextInfoCard(
                      color: Colors.green,
                      title: const Text("Clearance validation", textAlign: TextAlign.center, style: TextStyle(color: Colors.white)),
                      text: Text("From ${dateFormat.format(snapshot.data!.clearance.beginDate)} to ${dateFormat.format(snapshot.data!.clearance.beginDate)}", textAlign: TextAlign.center),
                      width: MediaQuery.of(context).size.width,
                    ),
                    TextInfoCard(
                      callback: () async {
                        await Clipboard.setData(ClipboardData(text: snapshot.data!.uuid));
                      },
                      color: Colors.green,
                      title: const Text("UUID", textAlign: TextAlign.center, style: TextStyle(color: Colors.white)),
                      text: Text(snapshot.data!.uuid, textAlign: TextAlign.center),
                      width: MediaQuery.of(context).size.width,
                    )
                  ],
                ),
              )
            ),
          );
        }
        else {
          return const CircularProgressIndicator();
        }
      }
    );
  }

}