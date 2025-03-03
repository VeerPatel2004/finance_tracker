import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionService {
  final CollectionReference transactions = FirebaseFirestore.instance
      .collection('transactions');

  // Create Transaction
  Future<void> addTransaction(String name, double amount, DateTime date) {
    return transactions.add({
      'name': name,
      'amount': amount,
      'date': date.toIso8601String(),
    });
  }

  // Read Transactions (Stream)
  Stream<QuerySnapshot> getTransactions() {
    return transactions.orderBy('date', descending: true).snapshots();
  }

  // Update Transaction
  Future<void> updateTransaction(
    String id,
    String name,
    double amount,
    DateTime date,
  ) {
    return transactions.doc(id).update({
      'name': name,
      'amount': amount,
      'date': date.toIso8601String(),
    });
  }

  // Delete Transaction
  Future<void> deleteTransaction(String id) {
    return transactions.doc(id).delete();
  }
}
