import 'package:flutter/material.dart';

class Small2Text extends StatelessWidget {
  final Color color;
  final String text;
  double size;
  Small2Text({
    super.key, required this.color,
    required this.text,
    this.size=20,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: color,
        fontSize: 12,
      ),
    );
  }
}
