import 'package:flutter/material.dart';

class BigText extends StatelessWidget {
  final Color color;
  final String text;
  double size;
  TextOverflow textOverflow;
   BigText({
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
      style: TextStyle(
        fontSize: 26,
        color: color,
        letterSpacing: 0.8,
        fontWeight: FontWeight.w600
      ),
    );
  }
}
