import 'package:flutter/cupertino.dart';

class AppointmentDetails extends StatefulWidget {
  const AppointmentDetails(this.payload, {super.key});

  final Map<String, dynamic> payload;

  @override
  State<StatefulWidget> createState() => AppointmentDetailsState();

}

class AppointmentDetailsState extends State<AppointmentDetails> {

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
