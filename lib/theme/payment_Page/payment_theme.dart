import 'package:flutter/material.dart';

class PaymentTheme {
  static const Color primaryColor = Colors.blue;
  static const Color secondaryColor = Colors.white;
  static const Color backgroundColor = Color(0xFFF5F5F5);
  static const Color textColor = Colors.black;

  static final BoxDecoration cardDecoration = BoxDecoration(
    color: secondaryColor,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 2),
    ],
  );

  static final TextStyle titleStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: textColor,
  );

  static final TextStyle subtitleStyle = TextStyle(
    fontSize: 14,
    color: Colors.grey.shade600,
  );

  static final ButtonStyle buttonStyle = ElevatedButton.styleFrom(
    backgroundColor: primaryColor,
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  );
}
