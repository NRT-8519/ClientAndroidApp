import 'package:flutter/cupertino.dart';

class PatientDetails extends StatefulWidget {
  const PatientDetails(this.payload, {super.key});

  final Map<String, dynamic> payload;

  @override
  State<StatefulWidget> createState() => PatientDetailsState();
}

class PatientDetailsState extends State<PatientDetails> {

  late Map<String, dynamic> payload;

  @override
  void initState() {
    super.initState();
    payload = widget.payload;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }

}