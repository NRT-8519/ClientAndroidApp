import 'package:client_android_app/models/issuer.dart';
import 'package:client_android_app/widgets/text_info_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../auth/http_requests.dart';
import '../../../models/company.dart';
import '../../../models/paginated_list.dart';

class IssuerDetails extends StatefulWidget {
  const IssuerDetails(this.payload, this.issuerUUID, {super.key});

  final Map<String, dynamic> payload;
  final String issuerUUID;

  @override
  State<StatefulWidget> createState() => IssuerDetailsState();
}

class IssuerDetailsState extends State<IssuerDetails> {

  late Map<String, dynamic> payload;
  late String issuerUUID;

  Future<Issuer> get issuer async {
    return await HttpRequests.issuer.get(issuerUUID);
  }

  @override
  void initState() {
    super.initState();
    payload = widget.payload;
    issuerUUID = widget.issuerUUID;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: issuer,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              title: Text("Issuer: ${snapshot.data!.name}"),
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
                        await Clipboard.setData(ClipboardData(text: snapshot.data!.city));
                      },
                      color: Colors.green,
                      title: const Text("Country", textAlign: TextAlign.center, style: TextStyle(color: Colors.white)),
                      text: Text(snapshot.data!.city, textAlign: TextAlign.center),
                      width: MediaQuery.of(context).size.width,
                    ),
                    TextInfoCard(
                      callback: () async {
                        await Clipboard.setData(ClipboardData(text: snapshot.data!.area));
                      },
                      color: Colors.green,
                      title: const Text("City", textAlign: TextAlign.center, style: TextStyle(color: Colors.white)),
                      text: Text(snapshot.data!.area  , textAlign: TextAlign.center),
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