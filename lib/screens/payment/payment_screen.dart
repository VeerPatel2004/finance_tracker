import 'package:flutter/material.dart';
import 'package:finance_tracker/data/services/payment_service.dart';
import 'package:finance_tracker/screens/payment/widgets/stored_card_item.dart';
import 'package:finance_tracker/screens/payment/widgets/add_card_modal.dart';
import 'package:finance_tracker/screens/payment/widgets/pay_now_button.dart';
import 'package:finance_tracker/screens/payment/widgets/no_saved_cards.dart';
import 'package:finance_tracker/screens/payment/widgets/add_card_button.dart';
// screen for the payment screen
class PaymentScreen extends StatefulWidget {
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final PaymentService _paymentService = PaymentService();
  String? selectedMethod;

  // Simulates a payment process
  void _processPayment() {
    if (selectedMethod == null) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text(" Payment Successful!")));
  }

  // Show Add Card Dialog
  void _showAddCardDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder:
          (context) => SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: AddCardModal(paymentService: _paymentService),
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Background: Dark Gradient
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          "Payment Method",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1E1E1E), Color(0xFF292929)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                      return NoSavedCardsWidget(onAddCard: _showAddCardDialog);
                    }

                    return ListView.builder(
                      itemCount: cards.length,
                      itemBuilder: (context, index) {
                        var card = cards[index];

                        return StoredCardItem(
                          card: card,
                          paymentService: _paymentService,
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
              const SizedBox(height: 20),

              // Buttons
              AddCardButton(onPressed: _showAddCardDialog),
              const SizedBox(height: 10),
              PayNowButton(
                selectedMethod: selectedMethod,
                onPay: _processPayment,
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),

      // Floating Action Button
      floatingActionButton: FloatingActionButton(
        heroTag: "add_card_fab",
        backgroundColor: Colors.purpleAccent,
        onPressed: _showAddCardDialog,
        child: const Icon(Icons.add, size: 30),
      ),
    );
  }
}
