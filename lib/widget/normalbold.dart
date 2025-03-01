import 'package:flutter/material.dart';

class NormalBoldText extends StatelessWidget {
  final Color color;
  final String text;
  double size;
  NormalBoldText({
    super.key, required this.color,
    required this.text,
    this.size=22,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style:const TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.w600,
        fontSize: 16,
      ),
    );
  }
}
