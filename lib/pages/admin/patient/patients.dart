import 'dart:convert';

import 'package:client_android_app/auth/http_request.dart';
import 'package:client_android_app/models/paginated_list.dart';
import 'package:client_android_app/models/patient.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class Patients extends StatefulWidget {
  Patients({super.key, required this.payload});

  final Map<String, dynamic> payload;

  @override
  State<StatefulWidget> createState() => PatientsState();
}

class PatientsState extends State<Patients> {

  late Map<String, dynamic> payload;
  late String sortOrder, searchString, currentFilter, doctor;
  late int pageNumber, pageSize;

  TextEditingController searchController = TextEditingController();

  Future<PaginatedList<Patient>?> get patients async {
    return await HttpRequests.getPatients(sortOrder, searchString, currentFilter, pageNumber, pageSize, doctor);
  }

  @override
  void initState() {
    super.initState();
    payload = widget.payload;
    sortOrder = "";
    searchString = "";
    currentFilter = "";
    doctor = "";
    pageNumber = 1;
    pageSize = 10;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Patients"),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: patients,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 150,
                        height: 50,
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
                            minimumSize: Size(100, 50),
                            backgroundColor: Colors.deepPurple,
                            foregroundColor: Colors.white,
                          ),
                          child: Icon(Icons.search)
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height - 242,
                  child: SingleChildScrollView(
                    child: Table(
                      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                      columnWidths: <int, TableColumnWidth>{
                        0: snapshot.data!.items.isEmpty ? FixedColumnWidth(MediaQuery.of(context).size.width - 32) : FixedColumnWidth(32),
                        1: FixedColumnWidth(200),
                        2: FixedColumnWidth(64),
                        3: FixedColumnWidth(64),
                      },
                      children: [
                        if(snapshot.data!.items.isNotEmpty)... [
                          for(int i = 0; i < snapshot.data!.items.length; i++)... [
                            TableRow(
                                children: [
                                  TableCell(child: Text("${i + 1}", textAlign: TextAlign.center,)),
                                  TableCell(child: Text("${snapshot.data!.items[i].firstName} ${snapshot.data!.items[i].middleName[0]}. ${snapshot.data!.items[i].lastName}", textAlign: TextAlign.center)),
                                  Container(
                                      margin: EdgeInsets.all(9),
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            padding: EdgeInsets.all(10),
                                            backgroundColor: Colors.green,
                                            foregroundColor: Colors.white
                                        ),
                                        child: const Icon(Icons.info, ),

                                        onPressed: () { //TODO: Patient details

                                        },
                                      )
                                  ),
                                  Container(
                                      margin: EdgeInsets.all(9),
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            padding: EdgeInsets.all(10),
                                            backgroundColor: Colors.orangeAccent,
                                            foregroundColor: Colors.white
                                        ),
                                        child: const Icon(Icons.edit, ),

                                        onPressed: () { //TODO: Patient details

                                        },
                                      )
                                  )
                                ]
                            ),
                          ]
                        ]
                        else... [
                          TableRow(
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
    );
  }

}