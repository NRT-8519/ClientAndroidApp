import 'package:client_android_app/auth/http_request.dart';
import 'package:client_android_app/auth/validators.dart';
import 'package:client_android_app/models/Note.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotesCard extends StatefulWidget {
  final double? width;
  final Text? noteTitle;
  final Text? noteContent;
  final Text? noteTimestamp;
  const NotesCard({super.key, this.width, required this.noteTitle, required this.noteContent, required this.noteTimestamp});



  @override
  State<StatefulWidget> createState() => NotesCardState();
}

class NotesCardState extends State<NotesCard> {
  late double? width;

  late Text noteTitle;
  late Text noteContent;
  late Text noteTimestamp;

  @override
  void initState() {
    super.initState();
    width = widget.width;

    noteTitle = widget.noteTitle!;
    noteContent = widget.noteContent!;
    noteTimestamp = widget.noteTimestamp!;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: width,
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.25),
                  spreadRadius: 3,
                  blurRadius: 4,
                  offset: const Offset(0, 1.5)
              )
            ]
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: width,
              padding: const EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  noteTitle,
                  noteTimestamp,
                ],
              ),
            ),
            Container(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 16),
                child: noteContent
            )
          ],
        ),
      ),
    );
  }
}