import 'package:flutter/material.dart';

class AppointmentInfoCard extends StatelessWidget {

  final VoidCallback? callback;
  final double? width;
  final double? height;
  final IconData? icon;
  final Color? color;
  final Color? iconColor;
  final Text? text;
  final Text? descriptionText;
  final List<Widget> children;

  const AppointmentInfoCard({this.callback, this.width, this.height, this.icon, required this.children, this.color = Colors.white, this.iconColor = Colors.white, this.text = const Text(""), this.descriptionText = const Text(""), super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
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
            decoration: BoxDecoration(
                color: color,
                borderRadius: const BorderRadius.only(topRight: Radius.circular(12), topLeft: Radius.circular(12))
            ),
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(icon, size: 24, color: iconColor),
                text!
              ],
            ),
          ),
          Container(
            width: width,
            height: height,
            child: ListView(
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              children: children,
            ),
          )
        ],
      ),
    );
  }
}