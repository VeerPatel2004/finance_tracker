import 'package:flutter/material.dart';

class NoSavedCardsWidget extends StatelessWidget {
  final VoidCallback onAddCard;

  const NoSavedCardsWidget({required this.onAddCard, Key? key})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.credit_card_off, size: 50, color: Colors.white54),
          const SizedBox(height: 10),
          const Text(
            "No saved cards",
            style: TextStyle(color: Colors.white70, fontSize: 18),
          ),
          const SizedBox(height: 15),
          ElevatedButton(
            onPressed: onAddCard,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 40),
              backgroundColor: Colors.purpleAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              "Add a Card",
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
