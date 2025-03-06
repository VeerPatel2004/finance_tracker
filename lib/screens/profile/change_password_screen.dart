import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'widgets/password_input.dart';
import 'widgets/save_button.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  bool _isLoading = false;

  /// **Handles Password Change**
  Future<void> _changePassword() async {
    setState(() => _isLoading = true);

    try {
      User? user = _auth.currentUser;
      String email = user?.email ?? "";

      // Re-authenticate the user before changing the password
      AuthCredential credential = EmailAuthProvider.credential(
        email: email,
        password: _currentPasswordController.text.trim(),
      );
      await user?.reauthenticateWithCredential(credential);

      // Update the password
      await user?.updatePassword(_newPasswordController.text.trim());

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Password updated successfully!")),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("❌ Error: ${e.toString()}")));
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Change Password"),
        backgroundColor: Colors.black,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF00C9FF),
              Color(0xFFB721FF),
            ], // Background gradient
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 50),
              PasswordInput(
                controller: _currentPasswordController,
                hintText: "Current Password",
              ),
              const SizedBox(height: 20),
              PasswordInput(
                controller: _newPasswordController,
                hintText: "New Password",
              ),
              const SizedBox(height: 40),
              SaveButton(onPressed: _changePassword, isLoading: _isLoading),
            ],
          ),
        ),
      ),
    );
  }
}
