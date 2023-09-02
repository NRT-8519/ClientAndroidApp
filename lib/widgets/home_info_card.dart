import 'package:flutter/material.dart';

class HomeInfoCard extends StatelessWidget {

  final VoidCallback? callback;
  final Color? color;
  final IconData? icon;
  final String? text;
  final double width;

  const HomeInfoCard({
    super.key,
    this.callback,
    this.color = Colors.lightBlue,
    this.icon,
    this.text = "Placeholder",
    this.width = 150
  });


  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
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
          children: [
            Container(
              width: width,
              padding: const EdgeInsets.all(12),
              child: Icon(icon, size: 24, color: color),
            ),
            Container(
              width: width,
              decoration: BoxDecoration(
                  color: color,
                  borderRadius: const BorderRadius.only(bottomRight: Radius.circular(12), bottomLeft: Radius.circular(12))
              ),
              padding: const EdgeInsets.all(12),
              child: Text(text!),
            )
          ],
        ),
      ),
    );
  }

}