import 'package:client_android_app/auth/http_requests.dart';
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
  late String sortOrder, user;
  late int pageNumber, pageSize;

  Future<PaginatedList<Report?>> get reports async {
    return await HttpRequests.report.getPaged(sortOrder, pageNumber, pageSize, user);
  }


  @override
  void initState() {
    super.initState();
    payload = widget.payload;
    sortOrder = "";
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
                                  TableCell(child: Text("${(i + 1) + (pageNumber == 1 ? 0 : (pageNumber - 1) * pageSize)}", textAlign: TextAlign.center,)),
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