import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:finance_tracker/data/services/payment_service.dart';

class StoredCardItem extends StatelessWidget {
  final DocumentSnapshot card;
  final PaymentService paymentService;

  const StoredCardItem({
    Key? key,
    required this.card,
    required this.paymentService,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var data = card.data() as Map<String, dynamic>;

    return Card(
      child: ListTile(
        leading: Icon(Icons.credit_card, color: Colors.blue),
        title: Text(
          "${data['type']} ****${data['cardNumber'].substring(data['cardNumber'].length - 4)}",
        ),
        subtitle: Text("Expires: ${data['expiry']}"),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () => paymentService.deleteCard(card.id),
        ),
      ),
    );
  }
}
