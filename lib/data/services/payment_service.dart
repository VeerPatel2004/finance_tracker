import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PaymentService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get the user's Firestore path
  String _getUserPath() {
    User? user = _auth.currentUser;
    if (user == null) throw Exception("User not logged in");
    return "users/${user.uid}";
  }

  // Fetch Stored Cards
  Stream<QuerySnapshot> getStoredCards() {
    return _firestore.collection("${_getUserPath()}/payments").snapshots();
  }

  // Fetch Last Payment
  Future<DocumentSnapshot> getLastPayment() {
    return _firestore.doc("${_getUserPath()}/lastPayment").get();
  }

  // Add New Card
  Future<void> addCard(
    String cardNumber,
    String expiry,
    String cardHolder,
    String type,
  ) async {
    await _firestore.collection("${_getUserPath()}/payments").add({
      "cardNumber": cardNumber,
      "expiry": expiry,
      "cardHolder": cardHolder,
      "type": type,
    });
  }

  // Delete Card
  Future<void> deleteCard(String cardId) async {
    await _firestore.doc("${_getUserPath()}/payments/$cardId").delete();
  }

  // Save Last Payment
  Future<void> saveLastPayment(double amount, String method) async {
    await _firestore.doc("${_getUserPath()}/lastPayment").set({
      "amount": amount,
      "date": DateTime.now().toIso8601String(),
      "method": method,
    });
  }
}
