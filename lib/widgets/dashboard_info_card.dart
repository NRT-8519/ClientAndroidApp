import 'package:flutter/material.dart';

class DashboardInfoCard extends StatelessWidget {

  final VoidCallback? callback;
  final Color? color;
  final IconData? icon;
  final Text? text;
  final Text? descriptionText;
  final double width;

  const DashboardInfoCard({
    super.key,
    this.callback,
    this.color = Colors.lightBlue,
    this.icon,
    this.text = const Text("Placeholder", style: TextStyle(color: Colors.white)),
    this.descriptionText = const Text("Placeholder description", style: TextStyle(color: Colors.black)),
    this.width = 150
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(icon, size: 36, color: color),
                  descriptionText!
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