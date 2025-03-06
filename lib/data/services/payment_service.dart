// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class PaymentService {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   // Get current user path
//   String _getUserPath() {
//     User? user = _auth.currentUser;
//     if (user == null) throw Exception("User not logged in");
//     return "users/${user.uid}";
//   }

//   // Fetch Stored Cards
//   Stream<QuerySnapshot> getStoredCards() {
//     return _firestore.collection("${_getUserPath()}/payments").snapshots();
//   }

//   // Add New Card to Firebase
//   Future<void> addCard({
//     required String cardNumber,
//     required String expiry,
//     required String cardHolder,
//     required String type,
//   }) async {
//     await _firestore.collection("${_getUserPath()}/payments").add({
//       "cardNumber": cardNumber,
//       "expiry": expiry,
//       "cardHolder": cardHolder,
//       "type": type,
//       "createdAt": FieldValue.serverTimestamp(),
//     });
//   }

//   // Delete a Card
//   Future<void> deleteCard(String cardId) async {
//     await _firestore.doc("${_getUserPath()}/payments/$cardId").delete();
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PaymentService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current user path safely
  String? _getUserPath() {
    User? user = _auth.currentUser;
    if (user == null)
      return null; // ✅ Instead of throwing an exception, return null
    return "users/${user.uid}";
  }

  // Fetch Stored Cards
  Stream<QuerySnapshot> getStoredCards() {
    String? userPath = _getUserPath();
    if (userPath == null)
      return Stream.empty(); // ✅ Prevents Firestore call if user is null

    return _firestore.collection("$userPath/payments").snapshots();
  }

  // Add New Card to Firebase
  Future<void> addCard({
    required String cardNumber,
    required String expiry,
    required String cardHolder,
    required String type,
  }) async {
    String? userPath = _getUserPath();
    if (userPath == null)
      throw Exception(
        "Cannot add card. User is not logged in.",
      ); // ✅ Prevent adding if user is null

    await _firestore.collection("$userPath/payments").add({
      "cardNumber": cardNumber,
      "expiry": expiry,
      "cardHolder": cardHolder,
      "type": type,
      "createdAt": FieldValue.serverTimestamp(),
    });
  }

  // Delete a Card
  Future<void> deleteCard(String cardId) async {
    String? userPath = _getUserPath();
    if (userPath == null)
      throw Exception(
        "Cannot delete card. User is not logged in.",
      ); // ✅ Prevent deleting if user is null

    await _firestore.doc("$userPath/payments/$cardId").delete();
  }
}
