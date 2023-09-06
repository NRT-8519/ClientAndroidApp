import 'package:client_android_app/auth/http_request.dart';
import 'package:client_android_app/home.dart';
import 'package:client_android_app/pages/admin/report_details.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../models/paginated_list.dart';
import '../../models/report.dart';

const storage = FlutterSecureStorage();

class ServiceReports extends StatefulWidget {
  const ServiceReports(this.payload, {super.key});

  final Map<String, dynamic> payload;

  @override
  State<ServiceReports> createState() => ServiceReportsState();
}

class ServiceReportsState extends State<ServiceReports> {

  late Map<String, dynamic> payload;
  late String sortOrder, searchString, currentFilter, user;
  late int pageNumber, pageSize;

  TextEditingController searchController = TextEditingController();

  Future<PaginatedList<Report?>> get reports async {
    return await HttpRequests.report.getPaged(sortOrder, searchString, currentFilter, pageNumber, pageSize, user);
  }


  @override
  void initState() {
    super.initState();
    payload = widget.payload;
    sortOrder = "";
    searchString = "";
    currentFilter = "";
    user = "";
    pageNumber = 1;
    pageSize = 10;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Service reports"),
        centerTitle: true,automaticallyImplyLeading: false,
        leading: GestureDetector(
          child: Icon(Icons.arrow_back),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(payload)));
          },
        ),
      ),
      body: FutureBuilder(
        future: reports,
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
                            minimumSize: Size(100, 60),
                            backgroundColor: Colors.lightBlue,
                            foregroundColor: Colors.white,
                          ),
                          child: Icon(Icons.search)
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
                                  TableCell(child: Text(snapshot.data!.items[i]!.title, textAlign: TextAlign.center)),
                                  Container(
                                    margin: EdgeInsets.all(9),
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => ReportDetails(payload, snapshot.data!.items[i]!.uuid)));
                                      },
                                      child: const Icon(Icons.info, color: Colors.green, size: 32),
                                    ),
                                  ),
                                  Container(
                                      margin: EdgeInsets.all(9),
                                      child: GestureDetector(
                                        onTap: () async {
                                          int result = await HttpRequests.report.delete(snapshot.data!.items[i]!.uuid);

                                          if (result == 1) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(content: Text("Report '${snapshot.data!.items[i]!.title}' removed."))
                                            );

                                            setState(() {

                                            });
                                          }
                                        },
                                        child: const Icon(Icons.delete, color: Colors.red, size: 32),
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
                              backgroundColor: Colors.lightBlue,
                              foregroundColor: Colors.white,
                            ),
                            child: Text("Previous")
                        ),
                        ElevatedButton(
                            onPressed: snapshot.data!.hasNext ? () {} : null,
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                              minimumSize: Size(160, 40),
                              backgroundColor: Colors.lightBlue,
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