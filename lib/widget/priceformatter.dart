import 'package:flutter/material.dart';

class PriceDisplay extends StatelessWidget {
  final int price;
  final bool? iswinner;
  final bool? isjoincontest;

  const PriceDisplay(
      {super.key,
      required this.price,
      this.iswinner = false,
      this.isjoincontest = false});

  // String formatMegaPrice(int price) {
  //   if (price >= 10000000) {
  //     // 1 crore = 10,000,000
  //     return "${(price / 10000000).toStringAsFixed(1)} cr"; // Format to 1 decimal place
  //   } else if (price >= 100000) {
  //     // 1 lakh = 100,000
  //     return "${(price / 100000).toStringAsFixed(1)} lakh"; // Format to 1 decimal place
  //   } else {
  //     return "₹${price.toString()}"; // For values less than 1 lakh
  //   }
  // }
  String formatMegaPrice(int price) {
    if (price >= 10000000) {
      // 1 crore = 10,000,000
      double croreValue = price / 10000000;
      return croreValue % 1 == 0
          ? "${croreValue.toStringAsFixed(0)} cr"
          : "${croreValue.toStringAsFixed(1)} cr";
    } else if (price >= 100000) {
      // 1 lakh = 100,000
      double lakhValue = price / 100000;
      return lakhValue % 1 == 0
          ? "${lakhValue.toStringAsFixed(0)} lakh"
          : "${lakhValue.toStringAsFixed(1)} lakh";
    } else {
      return "₹${price.toString()}"; // For values less than 1 lakh
    }
  }

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle;
    if (isjoincontest == true) {
      textStyle = const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: Color(0xff140B40),
      );
    } else if (iswinner == true) {
      textStyle = const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: Colors.black,
      );
    } else {
      textStyle = const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: Color(0xffD4AF37),
      );
    }
    return Text(
      formatMegaPrice(price),
      style: textStyle,
      // style: TextStyle(fontSize: iswinner! ? 16 :12 , fontWeight: FontWeight.w500,color: iswinner! ? Colors.black :Color(0xffD4AF37)), // Customize the style as needed
    );
  }
}
