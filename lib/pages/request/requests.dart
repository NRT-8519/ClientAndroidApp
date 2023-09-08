import 'package:client_android_app/auth/http_request.dart';
import 'package:client_android_app/home.dart';
import 'package:client_android_app/models/doctor.dart';
import 'package:client_android_app/models/paginated_list.dart';
import 'package:client_android_app/models/request.dart';
import 'package:client_android_app/pages/request/request_details.dart';
import 'package:flutter/material.dart';

class Requests extends StatefulWidget {
  const Requests({super.key, required this.payload});

  final Map<String, dynamic> payload;

  @override
  State<StatefulWidget> createState() => RequestsState();

}

class RequestsState extends State<Requests> {
  late Map<String, dynamic> payload;

  late String sortOrder, doctor, patient;
  late int pageNumber, pageSize;

  late bool isRefreshing;

  Future<PaginatedList<Request?>> get requests async {
    return HttpRequests.request.getPaged(sortOrder, pageNumber, pageSize, patient, doctor);
  }

  Future<Doctor?> get doc async {
    return HttpRequests.doctor.get(payload["jti"]);
  }

  @override
  void initState() {
    super.initState();
    payload = widget.payload;
    sortOrder = "";
    pageNumber = 1;
    pageSize = 10;
    if (payload["role"] == "DOCTOR") {
      doctor = payload["jti"];
    }
    else {
      doctor = "";
    }
    if (payload["role"] == "PATIENT") {
      patient = payload["jti"];
    }
    else {
      patient = "";
    }
    isRefreshing = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Requests"),
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(payload)));
          },
          child: const Icon(Icons.arrow_back),
        ),
      ),
      body: Center(
        child: FutureBuilder(
          future: requests,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FutureBuilder(
                    future: doc,
                    builder: (context, patientSnapshot) {
                      if (patientSnapshot.hasData) {
                        return Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(16),
                            child: DropdownMenu<String>(
                              label: Text("Patient"),
                              enabled: !isRefreshing,
                              width: MediaQuery.of(context).size.width - 32,
                              initialSelection: patient,
                              dropdownMenuEntries: [
                                const DropdownMenuEntry(value: "", label: "Show all"),
                                for(int i = 0; i < patientSnapshot.data!.patients.length; i++)... [
                                  DropdownMenuEntry(value: patientSnapshot.data!.patients[i].uuid!, label: "${patientSnapshot.data!.patients[i].firstName} ${patientSnapshot.data!.patients[i].lastName}"),
                                ]
                              ],
                              onSelected: (String? value) async {
                                setState(() {
                                  patient = value!;
                                });
                              },
                            )
                        );
                      }
                      else {
                        return Center(
                          child: Container(
                            alignment: Alignment.center,
                            width: 60,
                            height: 60,
                            child: const CircularProgressIndicator(),
                          ),
                        );
                      }
                    }
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height - 252,
                    child: SingleChildScrollView(
                      child: Table(
                        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                        columnWidths: <int, TableColumnWidth>{
                          0: snapshot.data!.items.isEmpty ? FixedColumnWidth(MediaQuery.of(context).size.width - 32) : FixedColumnWidth(32),
                          1: FixedColumnWidth(160),
                          2: FixedColumnWidth(100),
                          3: FixedColumnWidth(120)
                        },
                        children: [
                          if(snapshot.data!.items.isNotEmpty)... [
                            for(int i = 0; i < snapshot.data!.items.length; i++)... [
                              TableRow(
                                  children: [
                                    TableCell(child: Text("${i + 1}", textAlign: TextAlign.center,)),
                                    TableCell(
                                      child: Text(
                                        snapshot.data!.items[i]!.title,
                                        textAlign: TextAlign.center,
                                        overflow: TextOverflow.ellipsis,
                                      )
                                    ),
                                    TableCell(
                                        child: Text(
                                          snapshot.data!.items[i]!.status,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: snapshot.data!.items[i]!.status == "AWAITING" ? Colors.orangeAccent :
                                                   snapshot.data!.items[i]!.status == "APPROVED" ? Colors.green :
                                                   snapshot.data!.items[i]!.status == "DENIED" ? Colors.red : Colors.black
                                          ),
                                        )
                                    ),
                                    Container(
                                      margin: EdgeInsets.all(9),
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => RequestDetails(payload: payload, requestUUID: snapshot.data!.items[i]!.uuid)));
                                        },
                                        child: const Icon(Icons.info, color: Colors.green, size: 32),
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
                      padding: EdgeInsets.all(16),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                              onPressed: snapshot.data!.hasPrevious ? () {} : null,
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                minimumSize: Size(160, 40),
                                backgroundColor: Colors.deepPurple,
                                foregroundColor: Colors.white,
                              ),
                              child: Text("Previous")
                          ),
                          ElevatedButton(
                              onPressed: snapshot.data!.hasNext ? () {} : null,
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                minimumSize: Size(160, 40),
                                backgroundColor: Colors.deepPurple,
                                foregroundColor: Colors.white,
                              ),
                              child: Text("Next")
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
      ),
    );
  }

}