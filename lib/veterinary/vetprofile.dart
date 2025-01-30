import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../constant.dart';
import 'login_screen.dart'; // Import the login screen for navigation
import 'dart:convert'; // For decoding base64 image

class VetProfile extends StatefulWidget {
  final String vetEmail;

  const VetProfile({required this.vetEmail, Key? key}) : super(key: key);

  @override
  _VetProfileState createState() => _VetProfileState();
}

class _VetProfileState extends State<VetProfile> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? name;
  String? phone;
  String? email;
  String? hospitalName;
  String? specializations;
  String? education;
  String? address;
  String? workingHours;
  String? imageUrl;

  @override
  void initState() {
    super.initState();
    _fetchVetProfile();
  }

  Future<void> _fetchVetProfile() async {
    try {
      final vetDoc = await _firestore.collection('veterinarians').doc(widget.vetEmail).get();
      if (vetDoc.exists) {
        setState(() {
          name = vetDoc['fullName'];
          phone = vetDoc['phone'];
          email = vetDoc['email'];
          hospitalName = vetDoc['hospitalName'];
          specializations = vetDoc['specializations'];
          education = vetDoc['education'];
          address = vetDoc['address'];
          workingHours = vetDoc['workingHours'];
          imageUrl = vetDoc['imageUrl'];
        });
      }
    } catch (e) {
      print("Failed to fetch veterinarian profile: $e");
    }
  }

  Future<void> _logout(BuildContext context) async {
    await _auth.signOut();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => VetLoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: primaryColor,
        title: const Text(
          "Veterinarian Profile",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 60,
                backgroundColor: primaryColor,
                backgroundImage: imageUrl != null
                    ? MemoryImage(base64Decode(imageUrl!))
                    : null,
                child: imageUrl == null
                    ? const Icon(
                  Icons.person,
                  size: 60,
                  color: Colors.white,
                )
                    : null,
              ),
              const SizedBox(height: 16),
              Text(
                name ?? "Loading...",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              if (hospitalName != null)
                Text(
                  "Hospital: $hospitalName",
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              if (specializations != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Text(
                    "Specializations: $specializations",
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ),
              if (education != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Text(
                    "Education: $education",
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ),
              if (address != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Text(
                    "Address: $address",
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ),
              if (workingHours != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Text(
                    "Working Hours: $workingHours",
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
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
