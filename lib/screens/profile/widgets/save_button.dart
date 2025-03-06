import 'package:flutter/material.dart';

class SaveButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isLoading;

  const SaveButton({required this.onPressed, required this.isLoading, Key? key})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blueAccent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(vertical: 14),
      ),
      onPressed: isLoading ? null : onPressed,
      child:
          isLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text(
                "Save Changes",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
    );
  }
}
