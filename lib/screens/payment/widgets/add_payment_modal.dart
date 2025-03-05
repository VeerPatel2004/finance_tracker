import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentCard extends StatelessWidget {
  final DocumentSnapshot cardData;
  final bool isSelected;
  final VoidCallback onSelect;

  const PaymentCard({
    required this.cardData,
    required this.isSelected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    var data = cardData.data() as Map<String, dynamic>;

    return GestureDetector(
      onTap: onSelect,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.grey[900] : Colors.grey[800],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Card Holder",
              style: TextStyle(color: Colors.white54, fontSize: 12),
            ),
            Text(
              data['cardHolder'],
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              "**** **** **** ${data['cardNumber'].substring(data['cardNumber'].length - 4)}",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Exp: ${data['expiry']}",
                  style: TextStyle(color: Colors.white54),
                ),
                Image.asset(
                  "assets/icons/${data['type'].toLowerCase()}.png",
                  height: 20,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
