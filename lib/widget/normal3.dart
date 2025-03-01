import 'package:flutter/material.dart';

class Normal3Text extends StatelessWidget {
  final Color color;
  final String text;
  double size;
  Normal3Text({
    super.key, required this.color,
    required this.text,
    this.size=22,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: color,
        fontWeight: FontWeight.w400,
        fontSize: 12,
      ),
    );
  }
}
