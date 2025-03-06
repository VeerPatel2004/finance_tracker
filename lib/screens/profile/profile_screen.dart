import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'widgets/profile_card.dart';
import 'widgets/profile_option.dart';
import 'widgets/logout_button.dart';

class ProfileScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>?> _getUserData() async {
    User? user = _auth.currentUser;
    if (user == null) return null;

    DocumentSnapshot userDoc =
        await _firestore.collection('users').doc(user.uid).get();

    if (!userDoc.exists) return null;
    return userDoc.data() as Map<String, dynamic>;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Profile",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: _getUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData) {
            return const Center(child: Text("User data not found"));
          }

          Map<String, dynamic>? userData = snapshot.data;
          String userName = userData?['name'] ?? "Unknown";
          String email = _auth.currentUser?.email ?? "No Email";
          String joinDate = _formatTimestamp(userData?['joinDate']);

          return Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF00C9FF), Color(0xFFB721FF)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Profile Card
                ProfileCard(
                  userName: userName,
                  email: email,
                  joinDate: joinDate,
                ),
                const SizedBox(height: 30),

                //Profile Options
                ProfileOption(
                  icon: Icons.edit,
                  text: "Edit Profile",
                  onTap: () => Navigator.pushNamed(context, "/editProfile"),
                ),
                ProfileOption(
                  icon: Icons.lock,
                  text: "Change Password",
                  onTap: () => Navigator.pushNamed(context, "/changePassword"),
                ),
                ProfileOption(
                  icon: Icons.privacy_tip,
                  text: "Privacy Settings",
                  onTap: () => Navigator.pushNamed(context, "/privacySettings"),
                ),
                ProfileOption(
                  icon: Icons.settings,
                  text: "App Settings",
                  onTap: () => Navigator.pushNamed(context, "/appSettings"),
                ),
                ProfileOption(
                  icon: Icons.help_outline,
                  text: "Help & Support",
                  onTap: () => Navigator.pushNamed(context, "/helpSupport"),
                ),
                const SizedBox(height: 20),

                // Logout Button
                const LogoutButton(),
              ],
            ),
          );
        },
      ),
    );
  }

  //Timestamp Conversion
  String _formatTimestamp(dynamic timestamp) {
    if (timestamp is Timestamp) {
      DateTime dateTime = timestamp.toDate();
      return "${dateTime.day}/${dateTime.month}/${dateTime.year}";
    }
    return "Unknown Date";
  }
}
