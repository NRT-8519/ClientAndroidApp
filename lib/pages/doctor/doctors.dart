import 'dart:convert';

import 'package:client_android_app/auth/http_requests.dart';
import 'package:client_android_app/models/doctor.dart';
import 'package:client_android_app/models/paginated_list.dart';
import 'package:client_android_app/pages/admin/dashboard.dart';
import 'package:client_android_app/pages/doctor/add_doctor.dart';
import 'package:client_android_app/pages/doctor/doctor_details.dart';
import 'package:client_android_app/pages/doctor/edit_doctor.dart';
import 'package:flutter/material.dart';

class Doctors extends StatefulWidget {
  Doctors({super.key, required this.payload});

  final Map<String, dynamic> payload;

  @override
  State<StatefulWidget> createState() => DoctorsState();
}

class DoctorsState extends State<Doctors> {

  late Map<String, dynamic> payload;
  late String sortOrder, searchString, currentFilter;
  late int pageNumber, pageSize;

  TextEditingController searchController = TextEditingController();

  Future<PaginatedList<Doctor>?> get doctors async {
    return await HttpRequests.doctor.getPaged(sortOrder, searchString, currentFilter, pageNumber, pageSize);
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Doctors"),
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => Dashboard(payload)));
          },
          child: Icon(Icons.arrow_back),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => AddDoctor(payload)));
              },
              child: Icon(Icons.add_circle_outline),
            ),
          )
        ],
      ),
      body: FutureBuilder(
        future: doctors,
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
                                  TableCell(child: Text("${i + 1}", textAlign: TextAlign.center,)),
                                  TableCell(child: Text("${snapshot.data!.items[i].firstName} ${snapshot.data!.items[i].middleName[0]}. ${snapshot.data!.items[i].lastName}", textAlign: TextAlign.center)),
                                  Container(
                                    margin: EdgeInsets.all(9),
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => DoctorDetails(payload, snapshot.data!.items[i].uuid!)));
                                      },
                                      child: const Icon(Icons.info, color: Colors.green, size: 32),
                                    ),
                                    // child: ElevatedButton(
                                    //   style: ElevatedButton.styleFrom(
                                    //       padding: EdgeInsets.all(10),
                                    //       backgroundColor: Colors.green,
                                    //       foregroundColor: Colors.white
                                    //   ),
                                    //   child: const Icon(Icons.info, ),
                                    //
                                    //   onPressed: () { //TODO: Patient details
                                    //
                                    //   },
                                    //)
                                  ),
                                  Container(
                                      margin: EdgeInsets.all(9),
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => EditDoctor(payload, snapshot.data!.items[i].uuid!)));
                                        },
                                        child: const Icon(Icons.edit, color: Colors.orange, size: 32),
                                      )
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