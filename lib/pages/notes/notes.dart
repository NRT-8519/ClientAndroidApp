import 'package:client_android_app/auth/http_request.dart';
import 'package:client_android_app/home.dart';
import 'package:client_android_app/models/Note.dart';
import 'package:client_android_app/models/doctor.dart';
import 'package:client_android_app/models/paginated_list.dart';
import 'package:client_android_app/widgets/notes_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

class Notes extends StatefulWidget {
  const Notes(this.payload, {this.patientUUID = "", super.key});

  final Map<String, dynamic> payload;
  final String? patientUUID;

  @override
  State<StatefulWidget> createState() => NotesState();

}

class NotesState extends State<Notes> {

  late Map<String, dynamic> payload;
  late String patientUUID;
  late String sortOrder, doctorUUID;
  late int pageNumber, pageSize;
  late String selectedUser;
  late bool isRefreshing = false;

  DateFormat format = DateFormat("dd/MM HH:mm");

  GlobalKey<FormState> key = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  bool isSubmitting = false;
  Future<Doctor?> get doctor async {
    return await HttpRequests.doctor.get(payload["jti"]);
  }

  late Future<PaginatedList<Note?>> notesData;

  Future<PaginatedList<Note?>> getNotes() async {
    return await HttpRequests.notes.getPaged(sortOrder, pageNumber, pageSize, doctorUUID, patientUUID);
  }

  void refresh() {
    setState(() {
      notesData = getNotes();
    });
  }

  @override
  initState() {
    super.initState();
    payload = widget.payload;
    selectedUser = widget.patientUUID!;
    sortOrder = "";
    doctorUUID = payload["jti"];
    patientUUID = widget.patientUUID!;
    pageNumber = 1;
    pageSize = 10;
    isSubmitting = false;
    isRefreshing = false;

    notesData = getNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Notes"),
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(payload)));
          },
          child: const Icon(Icons.arrow_back),
        ),
        actions: [
          patientUUID == "" ? Container() : Padding(
            padding: const EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: () async {
                await addNote(patientUUID);
                setState(() {
                  isRefreshing = true;
                });

                String temp = patientUUID;
                patientUUID = "";
                refresh();
                await Future.delayed(Duration(seconds: 1));
                patientUUID = temp;
                refresh();

                setState(() {
                  isRefreshing = false;
                });
              },
              child: const Icon(Icons.add_circle),
            ),
          )
        ],
      ),
      body: FutureBuilder(
        future: doctor,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Center(
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(16),
                    child: DropdownMenu(
                      enabled: !isRefreshing,
                      width: MediaQuery.of(context).size.width - 32,
                      initialSelection: patientUUID,
                      dropdownMenuEntries: [
                        const DropdownMenuEntry(value: "", label: "Select a patient...", enabled: false),
                        for(int i = 0; i < snapshot.data!.patients.length; i++)... [
                          DropdownMenuEntry(value: snapshot.data!.patients[i].uuid, label: "${snapshot.data!.patients[i].firstName} ${snapshot.data!.patients[i].lastName}"),
                        ]
                      ],
                      onSelected: (value) async {
                        patientUUID = value!;
                        refresh();
                      },
                    )
                  ),
                  FutureBuilder(
                    future: notesData,
                    builder: (context, notesSnapshot) {
                      if (notesSnapshot.hasData) {
                        if (notesSnapshot.data!.items.isNotEmpty) {
                          return Container(
                            margin: const EdgeInsets.only(left: 16, right: 16),
                            child: ConstrainedBox(
                                constraints: BoxConstraints(
                                    minHeight: 50,
                                    maxHeight: MediaQuery.of(context).size.height - 172 - 16,
                                    minWidth: 250,
                                    maxWidth: MediaQuery.of(context).size.width

                                ),
                                child: RefreshIndicator(
                                  onRefresh: () async {

                                    setState(() {
                                      isRefreshing = true;
                                    });

                                    String temp = patientUUID;
                                    patientUUID = "";
                                    refresh();
                                    await Future.delayed(Duration(seconds: 1));
                                    patientUUID = temp;
                                    refresh();

                                    setState(() {
                                      isRefreshing = false;
                                    });
                                  },
                                  child: ListView(
                                    children: [
                                      if(notesSnapshot.data!.items.isNotEmpty)... [
                                        for(int i = 0; i < notesSnapshot.data!.items.length; i++)... [
                                          GestureDetector(
                                            onTap: () async {
                                              await editNote(notesSnapshot.data!.items[i]!.id, notesSnapshot.data!.items[i]!.noteTitle, notesSnapshot.data!.items[i]!.note, patientUUID);
                                              setState(() {
                                                isRefreshing = true;
                                              });

                                              String temp = patientUUID;
                                              patientUUID = "";
                                              refresh();
                                              await Future.delayed(Duration(seconds: 1));
                                              patientUUID = temp;
                                              refresh();

                                              setState(() {
                                                isRefreshing = false;
                                              });
                                            },
                                            child: NotesCard(
                                              noteTitle: Text(notesSnapshot.data!.items[i]!.noteTitle, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                              noteTimestamp: Text(format.format(notesSnapshot.data!.items[i]!.noteDate), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: CupertinoColors.systemGrey)),
                                              noteContent: Text(
                                                notesSnapshot.data!.items[i]!.note,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontSize: 12,
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
                          );
                        }
                        else {
                          return Container(
                              child: isRefreshing ? const CircularProgressIndicator() : const Center(child: Text("No notes to display", style: TextStyle(color: Colors.black)))
                          );
                        }
                      }
                      else {
                        return Container(
                          child: const Center(child: Text("No content", style: TextStyle(color: Colors.black),))
                        );
                      }
                    }
                  )
                ],
              ),
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

  Future<bool?> editNote(int id, String noteTitle, String note, String patientUUID) async {
    TextEditingController noteTitleController = TextEditingController();
    TextEditingController noteController = TextEditingController();

    return showDialog<bool>(
        context: context,
        builder: (dialogContext) {
          return StatefulBuilder(
              builder: (statefulContext, setStateForDialog) {
                noteTitleController.text = noteTitle;
                noteController.text = note;
                return AlertDialog(
                  actions: [
                    TextButton(onPressed: isSubmitting ? null : () async {
                      if (key.currentState!.validate()) {

                        Note updated = Note(id, payload["jti"], patientUUID, noteTitleController.text, noteController.text, DateTime.now());
                        await HttpRequests.notes.put(updated);

                        setStateForDialog(() {
                          isSubmitting = true;
                        });
                        await Future.delayed(const Duration(seconds: 1));

                        setStateForDialog(() {
                          isSubmitting = false;
                        });

                        Navigator.of(statefulContext).pop(true);
                      }

                    }, child: const Text("Save")),
                    TextButton(onPressed: isSubmitting ? null : () {Navigator.of(statefulContext).pop(true);}, child: const Text("Cancel")),
                  ],
                  scrollable: true,
                  title: Text(noteTitle, style: const TextStyle(fontSize: 14, ), textAlign: TextAlign.center),
                  content: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: key,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextFormField(
                            validator: (value) {
                              if (value!.length > 30) {
                                return "Maximum 30 characters!";
                              }
                              return null;
                            },
                            enabled: !isSubmitting,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                label: Text("Note title")
                            ),
                            controller: noteTitleController,
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
                            controller: noteController,
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
  Future<bool?> addNote(String patientUUID) async {
    TextEditingController noteTitleController = TextEditingController();
    TextEditingController noteController = TextEditingController();

    return showDialog<bool>(
        context: context,
        builder: (dialogContext) {
          return StatefulBuilder(
              builder: (statefulContext, setStateForDialog) {
                return AlertDialog(
                  actions: [
                    TextButton(onPressed: isSubmitting ? null : () async {
                      if (key.currentState!.validate()) {

                        Note newNote = Note(0, payload["jti"], patientUUID, noteTitleController.text, noteController.text, DateTime.now());
                        await HttpRequests.notes.post(newNote);

                        setStateForDialog(() {
                          isSubmitting = true;
                        });
                        await Future.delayed(const Duration(seconds: 1));

                        setStateForDialog(() {
                          isSubmitting = false;
                        });

                        Navigator.of(statefulContext).pop(true);
                      }

                    }, child: const Text("Add")),
                    TextButton(onPressed: isSubmitting ? null : () {Navigator.of(statefulContext).pop(true);}, child: const Text("Cancel")),
                  ],
                  scrollable: true,
                  title: Text("New note", style: const TextStyle(fontSize: 14, ), textAlign: TextAlign.center),
                  content: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: key,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextFormField(
                            validator: (value) {
                              if (value!.length > 30) {
                                return "Maximum 30 characters!";
                              }
                              return null;
                            },
                            enabled: !isSubmitting,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                label: Text("Note title")
                            ),
                            controller: noteTitleController,
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
                            controller: noteController,
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