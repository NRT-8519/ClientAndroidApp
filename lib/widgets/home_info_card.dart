import 'package:flutter/material.dart';

class HomeInfoCard extends StatelessWidget {

  final VoidCallback? callback;
  final Color? color;
  final IconData? icon;
  final Text? text;
  final double width;
  final int? count;
  final bool? countVisible;
  final String countText;

  const HomeInfoCard({
    super.key,
    this.callback,
    this.color = Colors.lightBlue,
    this.icon,
    this.text = const Text("Placeholder", style: TextStyle(color: Colors.white)),
    this.count = -1,
    this.width = 150,
    this.countVisible = true,
    this.countText = ""
  });


  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: callback,
      child: Container(
        width: width,
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3)
              )
            ]
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: width,
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(icon, size: 24, color: color),
                  if(count == -1)... [
                    countVisible! ? Container(
                      width: 24,
                      height: 24,
                      child: const CircularProgressIndicator(),
                    ) : Text(countText, style: const TextStyle(fontSize: 12),)
                  ]
                  else... [
                    countVisible! ? Text(count.toString()) : Text(countText)
                  ],
                ],
              ),
            ),
            Container(
              width: width,
              decoration: BoxDecoration(
                  color: color,
                  borderRadius: const BorderRadius.only(bottomRight: Radius.circular(12), bottomLeft: Radius.circular(12))
              ),
              padding: const EdgeInsets.all(12),
              child: text,
            )
          ],
        ),
      ),
    );
  }

}