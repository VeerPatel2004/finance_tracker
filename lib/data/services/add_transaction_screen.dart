import 'package:finance_tracker/data/services/transaction_service.dart';
import 'package:flutter/material.dart';

class AddTransactionScreen extends StatefulWidget {
  @override
  _AddTransactionScreenState createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TransactionService transactionService = TransactionService();

  void _addTransaction() {
    String name = _nameController.text;
    double amount = double.tryParse(_amountController.text) ?? 0;

    if (name.isNotEmpty && amount > 0) {
      transactionService.addTransaction(name, amount, DateTime.now());
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Transaction")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: "Name"),
            ),
            TextField(
              controller: _amountController,
              decoration: const InputDecoration(labelText: "Amount"),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addTransaction,
              child: const Text("Add Transaction"),
            ),
          ],
        ),
      ),
    );
  }
}
