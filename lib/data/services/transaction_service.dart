import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TransactionService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference _transactions = FirebaseFirestore.instance
      .collection('transactions');

  /// Add a new transaction (with user ID)
  Future<void> addTransaction(String name, double amount, DateTime date) async {
    final user = _auth.currentUser;
    if (user == null) return;

    await _transactions.add({
      'userId': user.uid,
      'name': name,
      'amount': amount,
      'date': date.toIso8601String(),
    });
  }

  /// Stream transactions for current logged-in user
  Stream<QuerySnapshot> getTransactions() {
    final user = _auth.currentUser;
    if (user == null) return const Stream.empty();

    return _transactions
        .where('userId', isEqualTo: user.uid)
        .orderBy('date', descending: true)
        .snapshots();
  }

  /// Update a specific transaction
  Future<void> updateTransaction(
    String id,
    String name,
    double amount,
    DateTime date,
  ) async {
    await _transactions.doc(id).update({
      'name': name,
      'amount': amount,
      'date': date.toIso8601String(),
    });
  }

  /// Delete a transaction by ID
  Future<void> deleteTransaction(String id) async {
    await _transactions.doc(id).delete();
  }
}
