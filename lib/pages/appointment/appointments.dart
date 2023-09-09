import 'package:client_android_app/auth/http_requests.dart';
import 'package:client_android_app/home.dart';
import 'package:client_android_app/models/appointment.dart';
import 'package:client_android_app/models/paginated_list.dart';
import 'package:client_android_app/models/patient.dart';
import 'package:client_android_app/pages/appointment/add_appointment.dart';
import 'package:client_android_app/pages/appointment/appointment_details.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Appointments extends StatefulWidget {
  const Appointments({super.key, required this.payload});

  final Map<String, dynamic> payload;

  @override
  State<StatefulWidget> createState() => AppointmentsState();
}

class AppointmentsState extends State<Appointments> {

  late Map<String, dynamic> payload;
  late String sortOrder, searchString, currentFilter;
  late int pageNumber, pageSize;

  @override
  void initState() {
    super.initState();
    payload = widget.payload;
    sortOrder = "";
    searchString = "";
    currentFilter = "";
    pageNumber = 1;
    pageSize = 10;
  }

  DateFormat format = DateFormat("dd/MM HH:mm");
  
  TextEditingController searchController = TextEditingController();



  Future<PaginatedList<Appointment?>> get appointments async {
    if (payload["role"] == "DOCTOR") {
      return await HttpRequests.appointment.getPaged(sortOrder, searchString, currentFilter, pageNumber, pageSize, payload["jti"], "", dateTime: null);
    }
    else {
      return await HttpRequests.appointment.getPaged(sortOrder, searchString, currentFilter, pageNumber, pageSize, "", payload["jti"], dateTime: null);
    }
  }

  Future<Patient?> getPatient(String uuid) async {
    if (payload["role"] == "DOCTOR") {
      return await HttpRequests.patient.get(uuid);
    }
    else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Appointments"),
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(payload)));
          },
          child: const Icon(Icons.arrow_back),
        ),
        actions: [
          if(payload["role"] == "DOCTOR")... [
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AddAppointment(payload)));
                },
                child: const Icon(Icons.add_circle_outline),
              ),
            )
          ]
        ],
      ),
      body: FutureBuilder(
        future: appointments,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 150,
                        height: 60,
                        child: TextField(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Search",
                          ),
                          controller: searchController,
                        ),
                      ),
                      ElevatedButton(
                          onPressed: () {
                            searchString = currentFilter = searchController.text;
                            setState(() {

                            });
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                            minimumSize: const Size(100, 60),
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                          ),
                          child: const Icon(Icons.search)
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height - 252,
                  child: SingleChildScrollView(
                    child: Table(
                      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                      columnWidths: <int, TableColumnWidth>{
                        0: snapshot.data!.items.isEmpty ? FixedColumnWidth(MediaQuery.of(context).size.width - 32) : const FixedColumnWidth(32),
                        1: const FixedColumnWidth(175),
                        2: const FixedColumnWidth(64),
                        3: const FixedColumnWidth(64),
                        4: const FixedColumnWidth(64),
                      },
                      children: [
                        if(snapshot.data!.items.isNotEmpty)... [
                          for(int i = 0; i < snapshot.data!.items.length; i++)... [
                            TableRow(
                                children: [
                                  TableCell(child: Text("${i + 1}", textAlign: TextAlign.center,)),
                                  TableCell(child: Text(snapshot.data!.items[i]!.event, textAlign: TextAlign.center)),
                                  if(payload["role"] == "DOCTOR")... [
                                    FutureBuilder(
                                      future: getPatient(snapshot.data!.items[i]!.patientUUID),
                                      builder: (context, patientSnapshot) {
                                        if (patientSnapshot.hasData) {
                                          return TableCell(child: Text("${patientSnapshot.data!.firstName} ${patientSnapshot.data!.lastName}", textAlign: TextAlign.center));
                                        }
                                        else {
                                          return Container(
                                            alignment: Alignment.center,
                                            width: 60,
                                            height: 60,
                                            child: const CircularProgressIndicator(),
                                          );
                                        }
                                      }
                                    )
                                  ],
                                  TableCell(child: Text(format.format(snapshot.data!.items[i]!.scheduledDateTime), textAlign: TextAlign.center)),
                                  Container(
                                    margin: const EdgeInsets.all(9),
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => AppointmentDetails(payload, snapshot.data!.items[i]!.id)));
                                      },
                                      child: const Icon(Icons.info, color: Colors.blue, size: 32),
                                    ),
                                  )
                                ]
                            ),
                          ]
                        ]
                        else... [
                          const TableRow(
                              children: [
                                Text(
                                  "No Content",
                                  textAlign: TextAlign.center,
                                )
                              ]
                          )
                        ]
                      ],
                    ),
                  ),
                ),
                Container(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                            onPressed: snapshot.data!.hasPrevious ? () {
                              pageNumber -= 1;
                              setState(() {

                              });
                            } : null,
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                              minimumSize: const Size(160, 40),
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text("Previous")
                        ),
                        ElevatedButton(
                            onPressed: snapshot.data!.hasNext ? () {
                              pageNumber += 1;
                              setState(() {

                              });
                            } : null,
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                              minimumSize: const Size(160, 40),
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text("Next")
                        ),
                      ],
                    )
                ),
              ],
            );
          }
          else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}