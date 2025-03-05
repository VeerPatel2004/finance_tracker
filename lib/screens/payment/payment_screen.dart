import 'package:finance_tracker/theme/payment_Page/payment_theme.dart';
import 'package:flutter/material.dart';

class PaymentScreen extends StatefulWidget {
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  List<Map<String, String>> storedCards = [
    {"cardNumber": "**** **** **** 1234", "expiry": "07/26"},
    {"cardNumber": "**** **** **** 5678", "expiry": "12/25"},
  ];

  String lastPayment = "\$250.00 on 10th March 2024";

  void _addNewCard() {
    setState(() {
      storedCards.add({"cardNumber": "**** **** **** 9876", "expiry": "09/27"});
    });
  }

  void _removeCard(int index) {
    setState(() {
      storedCards.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Payments",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      backgroundColor: PaymentTheme.backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Last Payment Details
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 3,
              child: ListTile(
                leading: const Icon(
                  Icons.history,
                  color: PaymentTheme.primaryColor,
                ),
                title: Text("Last Payment", style: PaymentTheme.titleStyle),
                subtitle: Text(lastPayment, style: PaymentTheme.subtitleStyle),
              ),
            ),
            const SizedBox(height: 20),

            // Stored Cards List
            Text("Saved Cards", style: PaymentTheme.titleStyle),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: storedCards.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    decoration: PaymentTheme.cardDecoration,
                    child: ListTile(
                      leading: const Icon(
                        Icons.credit_card,
                        color: Colors.black,
                      ),
                      title: Text(storedCards[index]["cardNumber"]!),
                      subtitle: Text(
                        "Expiry: ${storedCards[index]["expiry"]}",
                        style: PaymentTheme.subtitleStyle,
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _removeCard(index),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Add Card Button
            Center(
              child: ElevatedButton.icon(
                style: PaymentTheme.buttonStyle,
                onPressed: _addNewCard,
                icon: const Icon(Icons.add, color: Colors.white),
                label: const Text(
                  "Add New Card",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
