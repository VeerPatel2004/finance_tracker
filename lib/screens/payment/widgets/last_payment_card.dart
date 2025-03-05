import 'package:flutter/material.dart';

class LastPaymentCard extends StatelessWidget {
  final Map<String, dynamic> data;

  const LastPaymentCard({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          const Text(
            "Last Payment",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(
            "\$${data['amount']}",
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
          Text(
            "Method: ${data['method']}",
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
          Text(
            "Date: ${data['date'].toString().split("T")[0]}",
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
