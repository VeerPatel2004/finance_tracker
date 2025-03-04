// import 'package:cloud_firestore/cloud_firestore.dart';

// class TransactionService {
//   final CollectionReference transactions = FirebaseFirestore.instance
//       .collection('transactions');

//   // Create Transaction
//   Future<void> addTransaction(String name, double amount, DateTime date) {
//     return transactions.add({
//       'name': name,
//       'amount': amount,
//       'date': date.toIso8601String(),
//     });
//   }

//   // Read Transactions (Stream)
//   Stream<QuerySnapshot> getTransactions() {
//     return transactions.orderBy('date', descending: true).snapshots();
//   }

//   // Update Transaction
//   Future<void> updateTransaction(
//     String id,
//     String name,
//     double amount,
//     DateTime date,
//   ) {
//     return transactions.doc(id).update({
//       'name': name,
//       'amount': amount,
//       'date': date.toIso8601String(),
//     });
//   }

//   // Delete Transaction
//   Future<void> deleteTransaction(String id) {
//     return transactions.doc(id).delete();
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TransactionService {
  final CollectionReference transactions = FirebaseFirestore.instance
      .collection('transactions');
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // ✅ Create Transaction (Attach User ID)
  Future<void> addTransaction(String name, double amount, DateTime date) async {
    User? user = _auth.currentUser;
    if (user == null) return; // Ensure user is logged in

    await transactions.add({
      'userId': user.uid, // Attach user ID
      'name': name,
      'amount': amount,
      'date': date.toIso8601String(),
    });
  }

  // ✅ Fetch Transactions for Logged-in User
  Stream<QuerySnapshot> getTransactions() {
    User? user = _auth.currentUser;
    if (user == null) {
      return const Stream.empty(); // If no user, return empty stream
    }
    return transactions
        .where('userId', isEqualTo: user.uid) // 🔥 Filter by user ID
        .orderBy('date', descending: true)
        .snapshots();
  }

  // ✅ Update Transaction
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

  // ✅ Delete Transaction
  Future<void> deleteTransaction(String id) {
    return transactions.doc(id).delete();
  }
}
