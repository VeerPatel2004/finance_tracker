import 'package:flutter/material.dart';

class AddCardButton extends StatelessWidget {
  final VoidCallback onPressed;

  const AddCardButton({required this.onPressed, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey.shade900,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text(
          "Add New Card",
          style: TextStyle(fontSize: 16, color: Colors.white70),
        ),
      ),
    );
  }
}
