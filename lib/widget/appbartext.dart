import 'package:flutter/material.dart';

class AppBarText extends StatelessWidget {
  final Color color;
  final String text;
  double size;
  AppBarText({
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
        fontWeight: FontWeight.w500,
        fontSize: 18,
      ),
    );
  }
}
