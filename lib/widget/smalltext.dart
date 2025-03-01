import 'package:flutter/material.dart';

class SmallText extends StatelessWidget {

  final Color color;
  final String text;
  double size;
  SmallText({
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
          fontSize: 11,
      ),

    );

  }
}
