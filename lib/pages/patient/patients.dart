import 'package:client_android_app/auth/http_requests.dart';
import 'package:client_android_app/home.dart';
import 'package:client_android_app/models/paginated_list.dart';
import 'package:client_android_app/models/patient.dart';
import 'package:client_android_app/pages/patient/add_patient.dart';
import 'package:client_android_app/pages/patient/edit_patient.dart';
import 'package:client_android_app/pages/patient/patient_details.dart';
import 'package:flutter/material.dart';

import 'package:client_android_app/pages/admin/dashboard.dart';

class Patients extends StatefulWidget {
  const Patients({super.key, required this.payload, this.doctor = ""});

  final Map<String, dynamic> payload;
  final String doctor;

  @override
  State<StatefulWidget> createState() => PatientsState();
}

class PatientsState extends State<Patients> {

  late Map<String, dynamic> payload;
  late String sortOrder, searchString, currentFilter, doctor;
  late int pageNumber, pageSize;

  TextEditingController searchController = TextEditingController();

  Future<PaginatedList<Patient>?> get patients async {
    return await HttpRequests.patient.getPaged(sortOrder, searchString, currentFilter, pageNumber, pageSize, doctor);
  }

  @override
  void initState() {
    super.initState();
    payload = widget.payload;
    doctor = widget.doctor;
    sortOrder = "";
    searchString = "";
    currentFilter = "";
    pageNumber = 1;
    pageSize = 10;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Patients"),
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: GestureDetector(
          onTap: () {
            if (payload["role"] == "ADMINISTRATOR") {
              Navigator.push(context, MaterialPageRoute(builder: (context) => Dashboard(payload)));
            }
            else {
              Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(payload)));
            }
          },
          child: const Icon(Icons.arrow_back),
        ),
        actions: [
          if(payload["role"] == "ADMINISTRATOR")... [
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AddPatient(payload)));
                },
                child: const Icon(Icons.add_circle_outline),
              ),
            )
          ]
        ],
      ),
      body: FutureBuilder(
        future: patients,
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
                            backgroundColor: Colors.deepPurple,
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
                        1: const FixedColumnWidth(200),
                        2: const FixedColumnWidth(64),
                        3: const FixedColumnWidth(64),
                      },
                      children: [
                        if(snapshot.data!.items.isNotEmpty)... [
                          for(int i = 0; i < snapshot.data!.items.length; i++)... [
                            TableRow(
                                children: [
                                  TableCell(child: Text("${(i + 1) + (pageNumber == 1 ? 0 : (pageNumber - 1) * pageSize)}", textAlign: TextAlign.center,)),
                                  TableCell(child: Text("${snapshot.data!.items[i].firstName} ${snapshot.data!.items[i].middleName[0]}. ${snapshot.data!.items[i].lastName}", textAlign: TextAlign.center)),
                                  Container(
                                      margin: const EdgeInsets.all(9),
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => PatientDetails(payload, snapshot.data!.items[i].uuid!)));
                                        },
                                        child: const Icon(Icons.info, color: Colors.green, size: 32),
                                      ),
                                  ),
                                  if(payload["role"] == "ADMINISTRATOR")... [
                                    Container(
                                        margin: const EdgeInsets.all(9),
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.push(context, MaterialPageRoute(builder: (context) => EditPatient(payload, snapshot.data!.items[i].uuid!)));
                                          },
                                          child: const Icon(Icons.edit, color: Colors.orange, size: 32),
                                        )
                                    )
                                  ]
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
                              backgroundColor: Colors.deepPurple,
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
                              backgroundColor: Colors.deepPurple,
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