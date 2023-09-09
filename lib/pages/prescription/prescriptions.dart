import 'package:client_android_app/auth/http_requests.dart';
import 'package:client_android_app/home.dart';
import 'package:client_android_app/models/Note.dart';
import 'package:client_android_app/models/doctor.dart';
import 'package:client_android_app/models/medicine.dart';
import 'package:client_android_app/models/paginated_list.dart';
import 'package:client_android_app/models/patient.dart';
import 'package:client_android_app/models/prescription.dart';
import 'package:client_android_app/widgets/notes_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

class Prescriptions extends StatefulWidget {
  const Prescriptions(this.payload, {this.patientUUID = "", super.key});

  final Map<String, dynamic> payload;
  final String? patientUUID;

  @override
  State<StatefulWidget> createState() => PrescriptionsState();

}

class PrescriptionsState extends State<Prescriptions> {

  late Map<String, dynamic> payload;
  late String patientUUID;
  late String sortOrder, doctorUUID;
  late int pageNumber, pageSize;
  late bool isRefreshing = false;

  DateFormat format = DateFormat("dd/MM/yyyy");

  GlobalKey<FormState> key = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  bool isSubmitting = false;
  Future<Doctor?> get doctor async {
    return await HttpRequests.doctor.get(payload["jti"]);
  }

  Future<Patient?> get patient async {
    return await HttpRequests.patient.get(payload["jti"]);
  }

  Future<List<Medicine>?> get medicines async {
    return await HttpRequests.medicine.getAll();
  }

  late Future<PaginatedList<Prescription?>> prescriptionData;

  Future<PaginatedList<Prescription?>> getPrescriptions() async {
    return await HttpRequests.prescription.getPaged(sortOrder, pageNumber, pageSize, doctorUUID, patientUUID);
  }

  void refresh() {
    setState(() {
      prescriptionData = getPrescriptions();
    });
  }

  @override
  initState() {
    super.initState();
    payload = widget.payload;
    patientUUID = widget.patientUUID!;
    sortOrder = "";
    if (payload["role"] == "DOCTOR") {
      doctorUUID = payload["jti"];
    }
    else {
      doctorUUID = "";
    }
    patientUUID = widget.patientUUID!;
    pageNumber = 1;
    pageSize = 10;
    isSubmitting = false;
    isRefreshing = false;

    prescriptionData = getPrescriptions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Prescriptions"),
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
                onTap: () async {
                  await addPrescription();
                  setState(() {
                    isRefreshing = true;
                  });
                  String temp = doctorUUID;
                  doctorUUID = "";
                  refresh();
                  await Future.delayed(Duration(seconds: 1));
                  doctorUUID = temp;
                  refresh();

                  setState(() {
                    isRefreshing = false;
                  });
                },
                child: const Icon(Icons.add_circle),
              ),
            )
          ]
        ],
      ),
      body: FutureBuilder(
        future: payload["role"] == "DOCTOR" ? doctor : patient,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Center(
              child: FutureBuilder(
                  future: prescriptionData,
                  builder: (context, prescriptionSnapshot) {
                    if (prescriptionSnapshot.hasData) {
                      if (prescriptionSnapshot.data!.items.isNotEmpty) {
                        return Container(
                          margin: const EdgeInsets.only(left: 16, right: 16),
                          child: Column(
                            children: [
                              ConstrainedBox(
                                  constraints: BoxConstraints(
                                      minHeight: 50,
                                      maxHeight: MediaQuery.of(context).size.height - 162,
                                      minWidth: 250,
                                      maxWidth: MediaQuery.of(context).size.width

                                  ),
                                  child: RefreshIndicator(
                                    onRefresh: () async {
                                      setState(() {
                                        isRefreshing = true;
                                      });
                                      if (payload["role"] == "DOCTOR") {
                                        String temp = doctorUUID;
                                        doctorUUID = "";
                                        refresh();
                                        await Future.delayed(Duration(seconds: 1));
                                        doctorUUID = temp;
                                        refresh();
                                      }
                                      else {
                                        String temp = patientUUID;
                                        patientUUID = "";
                                        refresh();
                                        await Future.delayed(Duration(seconds: 1));
                                        patientUUID = temp;
                                        refresh();
                                      }

                                      setState(() {
                                        isRefreshing = false;
                                      });
                                    },
                                    child: ListView(
                                      children: [
                                        if(prescriptionSnapshot.data!.items.isNotEmpty)... [
                                          for(int i = 0; i < prescriptionSnapshot.data!.items.length; i++)... [
                                            GestureDetector(
                                              onTap: () async {
                                                await viewPrescription(prescriptionSnapshot.data!.items[i]!.id, prescriptionSnapshot.data!.items[i]!.medicine!, prescriptionSnapshot.data!.items[i]!.notes!, prescriptionSnapshot.data!.items[i]!.patient!, prescribed: prescriptionSnapshot.data!.items[i]!.prescribed == null ? null : format.format(prescriptionSnapshot.data!.items[i]!.prescribed!), administered: prescriptionSnapshot.data!.items[i]!.administered == null ? null : format.format(prescriptionSnapshot.data!.items[i]!.administered!));
                                                setState(() {
                                                  isRefreshing = true;
                                                });
                                                if (payload["role"] == "DOCTOR") {
                                                  String temp = doctorUUID;
                                                  doctorUUID = "";
                                                  refresh();
                                                  await Future.delayed(Duration(seconds: 1));
                                                  doctorUUID = temp;
                                                  refresh();
                                                }
                                                else {
                                                  String temp = patientUUID;
                                                  patientUUID = "";
                                                  refresh();
                                                  await Future.delayed(Duration(seconds: 1));
                                                  patientUUID = temp;
                                                  refresh();
                                                }
                                                setState(() {
                                                  isRefreshing = false;
                                                });
                                              },
                                              child: TimestampCard(
                                                title: Text("${prescriptionSnapshot.data!.items[i]!.patient!}", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                                timestamp: Text(
                                                    prescriptionSnapshot.data!.items[i]!.prescribed == null ? "Administered ${format.format(prescriptionSnapshot.data!.items[i]!.administered!)}" : "Prescribed ${format.format(prescriptionSnapshot.data!.items[i]!.prescribed!)}",
                                                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: CupertinoColors.systemGrey)),
                                                content: Text(
                                                  prescriptionSnapshot.data!.items[i]!.medicine!,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                width: MediaQuery.of(context).size.width,
                                              ),
                                            )
                                          ]
                                        ]
                                      ],
                                    ),
                                  )
                              ),
                              Container(
                                  margin: EdgeInsets.all(16),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      ElevatedButton(
                                          onPressed: prescriptionSnapshot.data!.hasPrevious ? () async {
                                            pageNumber -= 1;
                                            setState(() {
                                              isRefreshing = true;
                                            });
                                            if (payload["role"] == "DOCTOR") {
                                              String temp = doctorUUID;
                                              doctorUUID = "";
                                              refresh();
                                              await Future.delayed(Duration(seconds: 1));
                                              doctorUUID = temp;
                                              refresh();
                                            }
                                            else {
                                              String temp = patientUUID;
                                              patientUUID = "";
                                              refresh();
                                              await Future.delayed(Duration(seconds: 1));
                                              patientUUID = temp;
                                              refresh();
                                            }
                                            setState(() {
                                              isRefreshing = false;
                                            });
                                          } : null,
                                          style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                            minimumSize: Size(160, 40),
                                            backgroundColor: Colors.green,
                                            foregroundColor: Colors.white,
                                          ),
                                          child: Text("Previous")
                                      ),
                                      ElevatedButton(
                                          onPressed: prescriptionSnapshot.data!.hasNext ? () async {
                                            pageNumber += 1;
                                            setState(() {
                                              isRefreshing = true;
                                            });
                                            if (payload["role"] == "DOCTOR") {
                                              String temp = doctorUUID;
                                              doctorUUID = "";
                                              refresh();
                                              await Future.delayed(Duration(seconds: 1));
                                              doctorUUID = temp;
                                              refresh();
                                            }
                                            else {
                                              String temp = patientUUID;
                                              patientUUID = "";
                                              refresh();
                                              await Future.delayed(Duration(seconds: 1));
                                              patientUUID = temp;
                                              refresh();
                                            }
                                            setState(() {
                                              isRefreshing = false;
                                            });
                                          } : null,
                                          style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                            minimumSize: Size(160, 40),
                                            backgroundColor: Colors.green,
                                            foregroundColor: Colors.white,
                                          ),
                                          child: Text("Next")
                                      ),
                                    ],
                                  )
                              ),
                            ],
                          )

                        );
                      }
                      else {
                        return Center(
                            child: isRefreshing ? const CircularProgressIndicator() : const Center(child: Text("No prescriptions to display", style: TextStyle(color: Colors.black)))
                        );
                      }
                    }
                    else {
                      return const Center(
                          child: Center(child: Text("No content", style: TextStyle(color: Colors.black),))
                      );
                    }
                  }
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
        },
      ),

    );
  }

  Future<bool?> viewPrescription(int id, String medicine, String notes, String patient,
      {String? prescribed, String? administered}) async {
    return showDialog<bool>(
        context: context,
        builder: (dialogContext) {
          return StatefulBuilder(
              builder: (statefulContext, setStateForDialog) {
                return AlertDialog(
                  actions: [
                    TextButton(onPressed: () {Navigator.of(statefulContext).pop(true);}, child: const Text("Close")),
                  ],
                  scrollable: true,
                  title: Text("Prescription", style: const TextStyle(fontSize: 14, ), textAlign: TextAlign.center),
                  content: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextFormField(
                          initialValue: medicine,
                          readOnly: true,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              label: Text("Medicine")
                          ),

                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          initialValue: prescribed ?? administered,
                          readOnly: true,
                          decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              label: Text(prescribed == null ? "Administered" : "Prescribed")
                          ),
                        ),
                        const SizedBox(height: 10,),
                        TextFormField(
                          initialValue: patient,
                          readOnly: true,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              label: Text("Patient")
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          initialValue: notes,
                          readOnly: true,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              label: Text("Prescription notes")
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }
          );
        }
    );
  }
  Future<bool?> addPrescription() async {
    TextEditingController medicineController = TextEditingController();
    TextEditingController notesController = TextEditingController();
    TextEditingController patientController = TextEditingController();

    String patientUUID = "";
    String medicineUUID = "";

    bool prescribed = true;

    return showDialog<bool>(
        context: context,
        builder: (dialogContext) {
          return StatefulBuilder(
              builder: (statefulContext, setStateForDialog) {
                return AlertDialog(
                  actions: [
                    TextButton(onPressed: isSubmitting ? null : () async {
                      if (key.currentState!.validate()) {

                        Prescription newPrescription;
                        if (prescribed) {
                          newPrescription = Prescription(0, payload["jti"], patientUUID, medicineUUID, DateTime.now(), null, notesController.text);
                        }
                        else {
                          newPrescription = Prescription(0, payload["jti"], patientUUID, medicineUUID, null, DateTime.now(), notesController.text);
                        }
                        await HttpRequests.prescription.post(newPrescription);

                        setState(() {
                          isRefreshing = true;
                        });

                        String temp = doctorUUID;
                        doctorUUID = "";
                        refresh();
                        await Future.delayed(Duration(seconds: 1));
                        doctorUUID = temp;
                        refresh();

                        setState(() {
                          isRefreshing = false;
                        });

                        Navigator.of(statefulContext).pop(true);
                      }

                    }, child: const Text("Add")),
                    TextButton(onPressed: isSubmitting ? null : () {Navigator.of(statefulContext).pop(true);}, child: const Text("Cancel")),
                  ],
                  scrollable: true,
                  title: Text("New prescription", style: const TextStyle(fontSize: 14, ), textAlign: TextAlign.center),
                  content: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: key,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          FutureBuilder(
                            future: medicines,
                            builder: (context, medicineSnapshot) {
                              if (medicineSnapshot.hasData) {
                                return DropdownMenu(
                                  controller: medicineController,
                                  enabled: !isSubmitting,
                                  initialSelection: "",
                                  width: 235,
                                  dropdownMenuEntries: [
                                    const DropdownMenuEntry(value: "", label: "Select a medicine...", enabled: false),
                                    for(int i = 0; i < medicineSnapshot.data!.length; i++)... [
                                      DropdownMenuEntry(value: medicineSnapshot.data![i].uuid, label: medicineSnapshot.data![i].name),
                                    ]
                                  ],
                                  onSelected: (value) {
                                    setStateForDialog(() {
                                      medicineUUID = value!;
                                    });
                                  },
                                );
                              }
                              else {
                                return const CircularProgressIndicator();
                              }
                            }
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          FutureBuilder(
                              future: doctor,
                              builder: (context, patientSnapshot) {
                                if (patientSnapshot.hasData) {
                                  return DropdownMenu(
                                    controller: patientController,
                                    enabled: !isSubmitting,
                                    initialSelection: "",
                                    width: 235,
                                    dropdownMenuEntries: [
                                      const DropdownMenuEntry(value: "", label: "Select a patient...", enabled: false),
                                      for(int i = 0; i < patientSnapshot.data!.patients.length; i++)... [
                                        DropdownMenuEntry(value: patientSnapshot.data!.patients[i].uuid, label: "${patientSnapshot.data!.patients[i].firstName} ${patientSnapshot.data!.patients[i].lastName}"),
                                      ]
                                    ],
                                    onSelected: (value) {
                                      setStateForDialog(() {
                                        patientUUID = value!;
                                      });
                                    },
                                  );
                                }
                                else {
                                  return const CircularProgressIndicator();
                                }
                              }
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            enabled: !isSubmitting,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                label: Text("Note content")
                            ),
                            controller: notesController,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,

                            children: [
                              Text("Administered"),
                              Switch(
                                value: prescribed,
                                activeColor: Colors.white,
                                inactiveThumbColor: Colors.white,
                                activeTrackColor: Colors.deepPurple,
                                inactiveTrackColor: Colors.deepPurple,
                                onChanged: (bool value) {
                                  setStateForDialog(() {
                                    prescribed = value;
                                  });
                                }
                              ),
                              Text("Prescribed")
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                );
              }
          );
        }
    );
  }

}