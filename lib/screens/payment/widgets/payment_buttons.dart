import 'package:flutter/material.dart';

class PaymentButtons extends StatelessWidget {
  final VoidCallback onSendMoney;
  final VoidCallback onPayBill;
  final VoidCallback onAddMoney;

  const PaymentButtons({
    required this.onSendMoney,
    required this.onPayBill,
    required this.onAddMoney,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildButton("Send Money", Colors.blue, onSendMoney),
            _buildButton("Pay Bill", Colors.purple, onPayBill),
          ],
        ),
        const SizedBox(height: 15),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey[900],
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: onAddMoney,
          child: const Text("Add Money", style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }

  Widget _buildButton(String text, Color color, VoidCallback onPressed) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      onPressed: onPressed,
      child: Text(text, style: const TextStyle(color: Colors.white)),
    );
  }
}
