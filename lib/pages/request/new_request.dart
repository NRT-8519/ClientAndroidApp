import 'package:client_android_app/auth/http_request.dart';
import 'package:client_android_app/auth/validators.dart';
import 'package:client_android_app/models/patient.dart';
import 'package:client_android_app/models/request.dart' as rqst;
import 'package:client_android_app/pages/request/requests.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class NewRequest extends StatefulWidget {

  final Map<String, dynamic> payload;

  const NewRequest({super.key, required this.payload});

  @override
  State<StatefulWidget> createState() => NewRequestState();

}

class NewRequestState extends State<NewRequest> {

  late Map<String, dynamic> payload;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late bool isSubmitting;

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController typeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    payload = widget.payload;
    isSubmitting = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New request"),
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => Requests(payload: payload)));
          },
          child: const Icon(Icons.arrow_back),
        ),
      ),
      body: Center(
        child: Form(
          key: formKey,
          child: SizedBox(
            width: MediaQuery.of(context).size.width - 64,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  enabled: !isSubmitting,
                  validator: (value) => Validators.validateNotEmpty(value),
                  controller: titleController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Title",
                  ),
                ),
                const SizedBox(height: 16),
                DropdownMenu(
                  label: const Text("Request type"),
                  enabled: !isSubmitting,
                  controller: typeController,
                  width: MediaQuery.of(context).size.width - 64,
                  dropdownMenuEntries: const [
                    DropdownMenuEntry(value: "", label: "Select a type..."),
                    DropdownMenuEntry(value: "APPOINTMENT", label: "Request an appointment"),
                    DropdownMenuEntry(value: "APPOINTMENT_MOVE", label: "Request to move an appointment"),
                    DropdownMenuEntry(value: "APPOINTMENT_CANCEL", label: "Cancel an appointment"),
                    DropdownMenuEntry(value: "PRESCRIPTION_EXTENSION", label: "Extend a prescription"),
                  ],
                  onSelected: (String? value) {
                    typeController.text = value!;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  enabled: !isSubmitting,
                  validator: (value) => Validators.validateNotEmpty(value),
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Request description",
                  ),
                ),
              ],
            ),
          )
        ),
      ),
      floatingActionButton: !isSubmitting ? FloatingActionButton.extended(

        isExtended: true,
        onPressed: () async {
          if (formKey.currentState!.validate()) {
            setState(() {
              isSubmitting = true;
            });


            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Processing..."))
            );

            Patient? patient = await HttpRequests.patient.get(payload["jti"]);

            rqst.Request request = rqst.Request(
                "00000000-0000-0000-0000-000000000000",
                patient!.assignedDoctor.uuid!,
                payload["jti"],
                titleController.text,
                descriptionController.text,
                typeController.text,
                "AWAITING",
                "",
                DateTime.now()
            );

            Response response = await HttpRequests.request.post(request);

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
        label: Text("Send a request"),
        icon: Icon(Icons.send),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ) : SizedBox.shrink(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

}