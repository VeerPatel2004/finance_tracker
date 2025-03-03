import 'package:finance_tracker/screens/dashboard/expense_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ExpenseProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addExpense(Expense expense) async {
    await _firestore.collection('expenses').add(expense.toMap());
    notifyListeners();
  }
}
