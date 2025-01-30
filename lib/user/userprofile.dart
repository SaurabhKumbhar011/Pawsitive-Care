import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:paw1/constant.dart';
import 'package:paw1/user/login_screen.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? name;
  String? phone;
  String? email;

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final userDoc = await _firestore.collection('users').doc(user.email).get();
        if (userDoc.exists) {
          setState(() {
            name = userDoc['name'];
            phone = userDoc['phone'];
            email = userDoc['email'];
          });
        }
      }
    } catch (e) {
      print("Failed to fetch user profile: $e");
    }
  }

  Future<void> _logout(BuildContext context) async {
    await _auth.signOut();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: primaryColor,
        title: const Text(
          "User Profile",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Align(
        alignment: Alignment.topCenter, // Aligns content to the top center
        child: Padding(
          padding: const EdgeInsets.only(top: 50.0), // Adjust spacing from the top
          child: Column(
            mainAxisSize: MainAxisSize.min, // Shrinks the column to fit its children
            crossAxisAlignment: CrossAxisAlignment.center, // Center content horizontally
            children: [
              CircleAvatar(
                radius: 60,
                backgroundColor: primaryColor,
                child: const Icon(
                  Icons.person,
                  size: 60,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16), // Space between avatar and name
              Text(
                name ?? "Loading...", // Display fetched name or a loading placeholder
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8), // Space between name and phone
              Text(
                phone != null ? "Phone: $phone" : "Phone: Loading...", // Display fetched phone
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 4), // Space between phone and email
              Text(
                email != null ? "Email: $email" : "Email: Loading...", // Display fetched email
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 24), // Space before the logout button
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
                onPressed: () async {
                  await _logout(context);
                },
                icon: const Icon(Icons.logout, color: Colors.white),
                label: const Text(
                  "Logout",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
