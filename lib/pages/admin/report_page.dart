import 'package:client_android_app/auth/http_requests.dart';
import 'package:client_android_app/auth/validators.dart';
import 'package:client_android_app/home.dart';
import 'package:flutter/material.dart';
import 'package:client_android_app/models/report.dart' as report;
import 'package:http/http.dart';

class Report extends StatefulWidget {
  const Report({super.key, required this.payload});

  final Map<String, dynamic> payload;

  @override
  State<StatefulWidget> createState() => ReportState();
}

class ReportState extends State<Report> {

  late Map<String, dynamic> payload;
  late bool isSubmitting;
  GlobalKey<FormState> key = GlobalKey<FormState>();

  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();

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
        title: const Text("Report a problem"),
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(payload)));
          },
          child: const Icon(Icons.arrow_back),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.all(16),
        alignment: Alignment.center,
        child: Form(
          key: key,
          child: Column(
            children: [
              TextFormField(
                validator: (value) => Validators.validateNotEmpty(value),
                enabled: !isSubmitting,
                controller: titleController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Report title",
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              TextFormField(
                validator: (value) => Validators.validateNotEmpty(value),
                enabled: !isSubmitting,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                controller: contentController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Report content",
                ),
              )
            ],
          ),
        )
      ),
      floatingActionButton: !isSubmitting ? FloatingActionButton.extended(

        isExtended: true,
        onPressed: () async {
          if (key.currentState!.validate()) {
            setState(() {
              isSubmitting = true;
            });


            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Processing..."))
            );

            report.Report reportModel = report.Report(
              "00000000-0000-0000-0000-000000000000",
              payload["jti"],
              titleController.text,
              contentController.text,
              DateTime.now()
            );

            Response response = await HttpRequests.report.post(reportModel);

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
              Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(payload)));

              setState(() {
                isSubmitting = false;
              });
            }
          }
        },
        label: const Text("Send a report"),
        icon: const Icon(Icons.send),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ) : const SizedBox.shrink(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}