import 'package:flutter/material.dart';

class TimestampCard extends StatefulWidget {
  final double? width;
  final Text? title;
  final Text? content;
  final Text? timestamp;
  const TimestampCard({super.key, this.width, required this.title, required this.content, required this.timestamp});



  @override
  State<StatefulWidget> createState() => TimestampCardState();
}

class TimestampCardState extends State<TimestampCard> {
  late double? width;

  late Text noteTitle;
  late Text noteContent;
  late Text noteTimestamp;

  @override
  void initState() {
    super.initState();
    width = widget.width;

    noteTitle = widget.title!;
    noteContent = widget.content!;
    noteTimestamp = widget.timestamp!;
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