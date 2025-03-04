// import 'package:firebase_auth/firebase_auth.dart';

// class AuthService {
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   Future<User?> signIn(String email, String password) async {
//     try {
//       UserCredential userCredential = await _auth.signInWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//       return userCredential.user;
//     } catch (e) {
//       print(e);
//       return null;
//     }
//   }

//   Future<User?> signUp(String email, String password) async {
//     try {
//       UserCredential userCredential = await _auth
//           .createUserWithEmailAndPassword(email: email, password: password);
//       return userCredential.user;
//     } catch (e) {
//       print(e);
//       return null;
//     }
//   }

//   Future<void> signOut() async {
//     await _auth.signOut();
//   }
// }

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ✅ Get Current User
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // ✅ Sign In (Login)
  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      print("Error during login: ${e.message}");
      return null;
    }
  }

  // ✅ Sign Up (Register)
  Future<User?> signUp(String name, String email, String password) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      User? user = userCredential.user;
      if (user != null) {
        // ✅ Store user details in Firestore
        await _firestore.collection("users").doc(user.uid).set({
          "name": name,
          "email": email,
          "joinDate": DateTime.now().toIso8601String(),
        });
      }

      return user;
    } on FirebaseAuthException catch (e) {
      print("Error during sign-up: ${e.message}");
      return null;
    }
  }

  // ✅ Logout User
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print("Error signing out: $e");
    }
  }

  // ✅ Delete User Account
  Future<void> deleteUserAccount() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await _firestore.collection("users").doc(user.uid).delete();
        await user.delete();
      }
    } catch (e) {
      print("Error deleting user: $e");
    }
  }

  // ✅ Listen for Authentication State Changes
  Stream<User?> authStateChanges() {
    return _auth.authStateChanges();
  }
}
