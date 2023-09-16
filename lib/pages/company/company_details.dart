import 'package:client_android_app/widgets/text_info_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../auth/http_requests.dart';
import '../../../models/company.dart';

class CompanyDetails extends StatefulWidget {
  const CompanyDetails(this.payload, this.companyUUID, {super.key});

  final Map<String, dynamic> payload;
  final String companyUUID;

  @override
  State<StatefulWidget> createState() => CompanyDetailsState();
}

class CompanyDetailsState extends State<CompanyDetails> {

  late Map<String, dynamic> payload;
  late String companyUUID;

  Future<Company> get company async {
    return await HttpRequests.company.get(companyUUID);
  }

  @override
  void initState() {
    super.initState();
    payload = widget.payload;
    companyUUID = widget.companyUUID;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: company,
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
                        await Clipboard.setData(ClipboardData(text: snapshot.data!.country));
                      },
                      color: Colors.green,
                      title: const Text("Country", textAlign: TextAlign.center, style: TextStyle(color: Colors.white)),
                      text: Text(snapshot.data!.country, textAlign: TextAlign.center),
                      width: MediaQuery.of(context).size.width,
                    ),
                    TextInfoCard(
                      callback: () async {
                        await Clipboard.setData(ClipboardData(text: snapshot.data!.city));
                      },
                      color: Colors.green,
                      title: const Text("City", textAlign: TextAlign.center, style: TextStyle(color: Colors.white)),
                      text: Text(snapshot.data!.city  , textAlign: TextAlign.center),
                      width: MediaQuery.of(context).size.width,
                    ),
                    TextInfoCard(
                      callback: () async {
                        await Clipboard.setData(ClipboardData(text: snapshot.data!.address));
                      },
                      color: Colors.green,
                      title: const Text("Address", textAlign: TextAlign.center, style: TextStyle(color: Colors.white)),
                      text: Text(snapshot.data!.address, textAlign: TextAlign.center),
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