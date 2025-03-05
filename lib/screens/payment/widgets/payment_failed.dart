import 'package:flutter/material.dart';

class PaymentFailedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: Column(
        children: [
          Image.asset('assets/payment_failed.png', height: 100),
          const SizedBox(height: 10),
          const Text(
            "Payment Failed",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
      content: const Text(
        "Your card was rejected by the vendor. Please select another payment method.",
        textAlign: TextAlign.center,
      ),
      actions: [
        Center(
          child: ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Go Back"),
          ),
        ),
      ],
    );
  }
}
