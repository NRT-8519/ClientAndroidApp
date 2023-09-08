import 'package:client_android_app/auth/http_request.dart';
import 'package:client_android_app/auth/validators.dart';
import 'package:client_android_app/models/request.dart' as rqst;
import 'package:client_android_app/pages/request/requests.dart';
import 'package:client_android_app/widgets/text_info_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';

class RequestDetails extends StatefulWidget {

  final Map<String, dynamic> payload;
  final String requestUUID;

  const RequestDetails({super.key, required this.payload, required this.requestUUID});

  @override
  State<StatefulWidget> createState() => RequestDetailsState();

}

class RequestDetailsState extends State<RequestDetails> {

  late Map<String, dynamic> payload;
  late String requestUUID;
  late bool isAwaiting, isSubmitting;

  TextEditingController reasonController = TextEditingController();
  GlobalKey<FormState> key = GlobalKey<FormState>();

  Future<rqst.Request?> get request async {
    return await HttpRequests.request.get(requestUUID);
  }

  @override
  void initState() {
    super.initState();
    payload = widget.payload;
    requestUUID = widget.requestUUID;
    isAwaiting = false;
    isSubmitting = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Request details"),
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => Requests(payload: payload)));
          },
          child: const Icon(Icons.arrow_back),
        ),
      ),
      body: FutureBuilder(
        future: request,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            isAwaiting = snapshot.data!.status == "AWAITING";
            return Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.question_mark, size: 78, color: Colors.deepPurple),
                    const Divider(indent: 16, endIndent: 16),
                    GestureDetector(
                      onTap: () async {
                        await Clipboard.setData(ClipboardData(text: snapshot.data!.title));
                      },
                      child: Text(
                        snapshot.data!.title,
                        style: const TextStyle(fontSize: 24),
                      ),
                    ),
                    const Divider(indent: 16, endIndent: 16),
                    if(payload["role"] == "DOCTOR")... [
                      TextInfoCard(
                        width: MediaQuery.of(context).size.width,
                        title: Text("Patient", textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white)),
                        text: Text(
                          snapshot.data!.patient,
                          textAlign: TextAlign.center
                        ),
                        color: Colors.deepPurple,
                      )
                    ],
                    if(payload["role"] == "PATIENT")... [
                      TextInfoCard(
                        width: MediaQuery.of(context).size.width,
                        title: Text("Doctor", textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white)),
                        text: Text(snapshot.data!.doctor, textAlign: TextAlign.center),
                        color: Colors.deepPurple,
                      )
                    ],
                    TextInfoCard(
                      width: MediaQuery.of(context).size.width,
                      title: Text("Description", textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white)),
                      text: Text(snapshot.data!.description, textAlign: TextAlign.center),
                      color: Colors.deepPurple,
                    ),
                    TextInfoCard(
                      width: MediaQuery.of(context).size.width,
                      title: Text("Type", textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white)),
                      text: Text(getType(snapshot.data!.type), textAlign: TextAlign.center),
                      color: Colors.deepPurple,
                    ),
                    TextInfoCard(
                      width: MediaQuery.of(context).size.width,
                      title: Text("Status", textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white)),
                      color: Colors.deepPurple,
                      text: Text(
                        snapshot.data!.status,
                        style: TextStyle(
                          color: snapshot.data!.status == "AWAITING" ? Colors.orangeAccent :
                          snapshot.data!.status == "APPROVED" ? Colors.green :
                          snapshot.data!.status == "DENIED" ? Colors.red : Colors.black
                        ),
                        textAlign: TextAlign.center
                      ),
                    ),
                    TextInfoCard(
                      width: MediaQuery.of(context).size.width,
                      title: Text("Reason", textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white)),
                      color: Colors.deepPurple,
                      text: Text(snapshot.data!.reason == "" ? "Not yet reviewed" : snapshot.data!.reason, textAlign: TextAlign.center),
                    ),
                    if (payload["role"] == "DOCTOR" && isAwaiting)... [
                      Form(
                        key: key,
                        child: Column(
                          children: [
                            TextFormField(
                              validator: (value) => Validators.validateNotEmpty(value),
                              enabled: !isSubmitting,
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              controller: reasonController,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: "Reason",
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(16),
                              width: MediaQuery.of(context).size.width,
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  ElevatedButton(
                                      onPressed: () async {
                                        if (key.currentState!.validate()) {
                                          rqst.Request rq = rqst.Request(
                                              snapshot.data!.uuid,
                                              payload["jti"],
                                              snapshot.data!.patient,
                                              snapshot.data!.title,
                                              snapshot.data!.description,
                                              snapshot.data!.type,
                                              "DENIED",
                                              reasonController.text,
                                              snapshot.data!.requestDate
                                          );

                                          await HttpRequests.request.put(rq);
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                        minimumSize: Size(160, 40),
                                        backgroundColor: Colors.red,
                                        foregroundColor: Colors.white,
                                      ),
                                      child: Text("Deny")
                                  ),
                                  ElevatedButton(
                                      onPressed: () async {
                                        if (key.currentState!.validate()) {
                                          rqst.Request rq = rqst.Request(
                                              snapshot.data!.uuid,
                                              payload["jti"],
                                              snapshot.data!.patient,
                                              snapshot.data!.title,
                                              snapshot.data!.description,
                                              snapshot.data!.type,
                                              "APPROVED",
                                              reasonController.text,
                                              snapshot.data!.requestDate
                                          );

                                          Response response = await HttpRequests.request.put(rq);

                                          if (response.statusCode != 200) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(content: Text("Failed to send a report!"))
                                            );
                                            setState(() {
                                              isSubmitting = false;
                                            });
                                          }
                                          else {
                                            await Future.delayed(const Duration(seconds: 2));

                                            ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(content: Text("Success!"))
                                            );
                                            Navigator.push(context, MaterialPageRoute(builder: (context) => Requests(payload: payload)));

                                            setState(() {
                                              isSubmitting = false;
                                            });
                                          }
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                        minimumSize: Size(160, 40),
                                        backgroundColor: Colors.green,
                                        foregroundColor: Colors.white,
                                      ),
                                      child: Text("Approve")
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                    ]
                  ],
                ),
              ),
            );
          }
          else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        }
      ),
      
    );
  }

  String getType(String type) {
    switch (type) {
      case "APPOINTMENT_MOVE":
        return "Move an appointment";
      case "APPOINTMENT":
        return "Appointment request";
      case "APPOINTMENT_CANCEL":
        return "Cancel an appointment";
      case "PRESCRIPTION_EXTENSION":
        return "Extend a prescription";
      default:
        return "Unknown";
    }
  }
}