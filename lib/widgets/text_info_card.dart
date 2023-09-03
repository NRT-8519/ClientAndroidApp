import 'package:flutter/material.dart';

class TextInfoCard extends StatelessWidget {
  const TextInfoCard({super.key, this.callback, this.color, this.icon, this.title, this.text, required this.width});

  final VoidCallback? callback;
  final Color? color;
  final IconData? icon;
  final Text? title;
  final Widget? text;
  final double width;

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
                  spreadRadius: 3,
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
              child: title,
            ),
            Container(
              width: width,
              padding: const EdgeInsets.all(12),
              child: text
            )

          ],
        ),
      ),
    );
  }

}