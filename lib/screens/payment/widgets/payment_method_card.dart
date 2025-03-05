import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentMethodCard extends StatelessWidget {
  final DocumentSnapshot cardData;
  final bool isSelected;
  final VoidCallback onSelect;

  const PaymentMethodCard({
    required this.cardData,
    required this.isSelected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    var data = cardData.data() as Map<String, dynamic>;

    return GestureDetector(
      onTap: onSelect,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: isSelected ? Colors.blue[100] : Colors.white,
        child: ListTile(
          leading: Icon(Icons.credit_card, color: Colors.blue),
          title: Text(
            "${data['type']} ****${data['cardNumber'].substring(data['cardNumber'].length - 4)}",
          ),
          subtitle: Text("Expires: ${data['expiry']}"),
          trailing:
              isSelected ? Icon(Icons.check_circle, color: Colors.blue) : null,
        ),
      ),
    );
  }
}
