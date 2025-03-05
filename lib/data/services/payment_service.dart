import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PaymentService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current user path
  String _getUserPath() {
    User? user = _auth.currentUser;
    if (user == null) throw Exception("User not logged in");
    return "users/${user.uid}";
  }

  // Fetch Stored Cards
  Stream<QuerySnapshot> getStoredCards() {
    return _firestore.collection("${_getUserPath()}/payments").snapshots();
  }

  // Add New Card to Firebase
  Future<void> addCard({
    required String cardNumber,
    required String expiry,
    required String cardHolder,
    required String type,
  }) async {
    await _firestore.collection("${_getUserPath()}/payments").add({
      "cardNumber": cardNumber,
      "expiry": expiry,
      "cardHolder": cardHolder,
      "type": type,
      "createdAt": FieldValue.serverTimestamp(),
    });
  }

  // Delete a Card
  Future<void> deleteCard(String cardId) async {
    await _firestore.doc("${_getUserPath()}/payments/$cardId").delete();
  }
}
