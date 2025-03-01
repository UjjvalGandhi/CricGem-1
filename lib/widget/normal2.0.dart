import 'package:flutter/material.dart';

class Normal2Text extends StatelessWidget {
  final Color color;
  final String text;
  double size;
  Normal2Text({
    super.key, required this.color,
    required this.text,
    this.size=15,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style:const TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.w500,
        fontSize: 13,
      ),
    );
  }
}
