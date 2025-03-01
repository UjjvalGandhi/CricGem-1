import 'package:flutter/material.dart';

class NormalText extends StatelessWidget {
  final Color color;
  final String text;
  double size;
  FontWeight? fontWeight;
 final TextStyle? textStyle;
  NormalText({
    this.fontWeight,
    super.key, required this.color,
    required this.text,
    this.size=22,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style:textStyle?? TextStyle(
        color: color,
        fontWeight:fontWeight?? FontWeight.w400,
        fontSize: 14,
      ),
    );
  }
}
