import 'package:flutter/material.dart';

class Normal400 extends StatelessWidget {
  final Color color;
  final String text;
  double size;
  Normal400({
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
        fontSize: 14,
      ),
    );
  }
}
