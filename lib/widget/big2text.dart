
import 'package:flutter/material.dart';

class Big2Text extends StatelessWidget {
  final Color color;
  final String text;
  double size;
  TextOverflow textOverflow;
  Big2Text({
    super.key,
    required this.color,
    required this.text,
    this.size=26,
    this.textOverflow=TextOverflow.ellipsis
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style:const TextStyle(
          fontSize: 23,
          fontWeight: FontWeight.w600
      ),
    );
  }
}
