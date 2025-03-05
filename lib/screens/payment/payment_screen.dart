import 'package:finance_tracker/screens/payment/widgets/add_payment_modal.dart';
import 'package:flutter/material.dart';
import 'package:finance_tracker/data/services/payment_service.dart';
import 'package:finance_tracker/screens/payment/widgets/add_card_modal.dart';

class PaymentScreen extends StatefulWidget {
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final PaymentService _paymentService = PaymentService();
  String? selectedMethod;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Dark UI
      appBar: AppBar(
        title: const Text(
          "Payment Method",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: StreamBuilder(
                stream: _paymentService.getStoredCards(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  var cards = snapshot.data!.docs;
                  if (cards.isEmpty) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "No saved cards",
                          style: TextStyle(color: Colors.white),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              builder:
                                  (context) => AddCardModal(
                                    paymentService: _paymentService,
                                  ),
                            );
                          },
                          child: const Text("Add a Card"),
                        ),
                      ],
                    );
                  }

                  return ListView.builder(
                    itemCount: cards.length,
                    itemBuilder: (context, index) {
                      var card = cards[index];
                      return PaymentCard(
                        cardData: card,
                        isSelected: selectedMethod == card.id,
                        onSelect: () {
                          setState(() {
                            selectedMethod = card.id;
                          });
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) => AddCardModal(paymentService: _paymentService),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
