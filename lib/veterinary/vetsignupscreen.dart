import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../apis/MapScreen.dart';
import 'package:path/path.dart' as p;
import 'package:paw1/constant.dart';

import 'login_screen.dart';

class VeterinarySignupScreen extends StatefulWidget {
  @override
  _VeterinarySignupScreenState createState() => _VeterinarySignupScreenState();
}


class _VeterinarySignupScreenState extends State<VeterinarySignupScreen> {
  // Controllers for form fields
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _hospitalNameController = TextEditingController();
  final TextEditingController _specializationsController = TextEditingController();
  final TextEditingController _educationController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _workingHoursController = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isVerifying = false;
  bool _showAdditionalFields = false;
  String _errorMessage = '';
  String? _base64Image;
  bool _isVerificationEmailSent = false;
  bool _isEmailVerified = false;
  User? _temporaryUser;
  LatLng? _selectedLocation;
  String? _address;

  final ImagePicker _picker = ImagePicker();
  String? _imagePath;  // Store the image path
  Future<void> pickImageAndConvert() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      // Convert the image to bytes
      Uint8List imageBytes = await image.readAsBytes();

      // Update the state with the base64 image and the image path
      setState(() {
        _base64Image = base64Encode(imageBytes); // Store the image as base64
        _imagePath = image.path; // Store the image path
      });
    }
  }

  // Toggle additional fields
  void _toggleAdditionalFields() {
    setState(() {
      _showAdditionalFields = !_showAdditionalFields;
    });
  }

  // Send verification email
  Future<void> _sendVerificationEmail() async {
    try {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      // Create a temporary user account
      UserCredential userCredential =
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      _temporaryUser = userCredential.user;

      if (_temporaryUser != null && !_temporaryUser!.emailVerified) {
        await _temporaryUser!.sendEmailVerification();
        setState(() {
          _isVerificationEmailSent = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
              Text("Verification email sent! Please check your inbox.")),
        );

        // Send a registration email to the user
        await _sendRegistrationEmail(email);

        // Continuously check for email verification
        _checkEmailVerificationAutomatically();
      }
    } catch (e) {
      print("Error sending verification email: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to send verification email: $e")),
      );
    }
  }

  Future<void> _sendRegistrationEmail(String email) async {
    // Placeholder for sending registration email logic
    // Use Firebase Cloud Functions or any email service like SendGrid
    print("Registration email sent to: $email");
  }

  // Check if email is verified
  Future<void> _checkEmailVerificationAutomatically() async {
    while (_temporaryUser != null && !_isEmailVerified) {
      await Future.delayed(Duration(seconds: 3)); // Poll every 3 seconds
      await _temporaryUser?.reload(); // Reload the user to get the latest state
      _temporaryUser = _auth.currentUser;

      if (_temporaryUser != null && _temporaryUser!.emailVerified) {
        setState(() {
          _isEmailVerified = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Email verified successfully!")),
        );
        break;
      }
    }
  }

  // Signup and store details in Firestore
  Future<void> _completeSignUp() async {
    if (!_isEmailVerified) {
      setState(() {
        _errorMessage = 'Please verify your email before signing up.';
      });
      return;
    }

    String name = _fullNameController.text.trim();
    String email = _emailController.text.trim();
    String phone = _phoneController.text.trim();
    String password = _passwordController.text.trim();

    if (name.isEmpty || email.isEmpty || phone.isEmpty || password.isEmpty) {
      setState(() {
        _errorMessage = 'Please fill in all primary fields.';
      });
      return;
    }

    try {
      await _firestore.collection('veterinarians').doc(email).set({
        'fullName': name,
        'email': email,
        'phone': phone,
        'password': password,
        'hospitalName': _hospitalNameController.text.trim(),
        'specializations': _specializationsController.text.trim(),
        'education': _educationController.text.trim(),
        'imageUrl': _base64Image,
        'workingHours': _workingHoursController.text.trim(),
        'location': _selectedLocation != null
            ? {
          'latitude': _selectedLocation!.latitude,
          'longitude': _selectedLocation!.longitude
        }
            : null,
        'address': _address,
      });

      Fluttertoast.showToast(
        msg: 'Signup successful',
        backgroundColor: Colors.green,
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                VetLoginScreen()), // Replace with your login screen widget
      );
    } catch (e) {
      setState(() {
        _errorMessage = 'Signup failed. Please try again.';
      });
    }
  }

  Future<void> _pickLocation() async {
    LatLng? pickedLocation = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LocationPickerScreen(
          onLocationPicked: (LatLng location) {
            Navigator.pop(context, location);
          },
        ),
      ),
    );

    if (pickedLocation != null) {
      setState(() {
        _selectedLocation = pickedLocation;
      });

      // Fetch address for the selected location
      await _getAddress(pickedLocation);
    }
  }

// Get address from LatLng
  Future<void> _getAddress(LatLng location) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(location.latitude, location.longitude);
      Placemark place = placemarks[0];
      setState(() {
        _address = "${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
      });
    } catch (e) {
      print("Error fetching address: $e");
      setState(() {
        _address = "Unable to fetch address";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Veterinary Signup'),
        centerTitle: true,
        backgroundColor: primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Primary fields
              TextField(
                controller: _fullNameController,
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                onChanged: (value) {
                  // Reset states when email changes
                  setState(() {
                    _isVerificationEmailSent = false;
                    _isEmailVerified = false;
                    _temporaryUser = null;
                  });
                },
              ),
              if (_emailController.text.isNotEmpty) ...[
                const SizedBox(height: 5),
                Row(
                  children: [
                    Spacer(),
                    GestureDetector(
                      onTap: _isVerificationEmailSent || _isEmailVerified
                          ? null
                          : _sendVerificationEmail,
                      child: Text(
                        _isEmailVerified
                            ? "Verified ✅"
                            : (_isVerificationEmailSent
                            ? "Verification email sent."
                            : "Verify"),
                        style: TextStyle(
                          color: _isEmailVerified ? Colors.green : Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],

              SizedBox(height: 20),
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  prefixIcon: Icon(Icons.phone),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
              SizedBox(height: 20),

              // Toggle for additional fields
              InkWell(
                onTap: _toggleAdditionalFields,
                child: Row(
                  children: [
                    Icon(
                      _showAdditionalFields
                          ? Icons.arrow_drop_up
                          : Icons.arrow_drop_down,
                      color: primaryColor,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'More Details',
                      style: TextStyle(
                          color: primaryColor, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              if (_showAdditionalFields) ...[
                SizedBox(height: 20),
                TextField(
                  controller: _hospitalNameController,
                  decoration: InputDecoration(
                    labelText: 'Hospital Name',
                    prefixIcon: Icon(Icons.local_hospital),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _specializationsController,
                  decoration: InputDecoration(
                    labelText: 'Specializations',
                    prefixIcon: Icon(Icons.school),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _educationController,
                  decoration: InputDecoration(
                    labelText: 'Education',
                    prefixIcon: Icon(Icons.book),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: _pickLocation,
                  child: Container(
                    height: 55,
                    width: 358,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          Icon(Icons.location_on, color: Colors.black), // Location icon
                          SizedBox(width: 10), // Spacing between icon and text
                          Expanded(
                            child: Text(
                              _address ?? 'Pick Location', // Show address or default text
                              style: TextStyle(color: Colors.grey.shade600,fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis, // Prevents overflow for long addresses
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),

                GestureDetector(
                  onTap: pickImageAndConvert, // This will trigger the image picker when tapped
                  child: Container(
                    height: 55,
                    width: 358,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          Icon(
                            Icons.upload, // Upload icon
                            color: Colors.black,
                          ),
                          SizedBox(width: 10), // Space between icon and text
                          Expanded(
                            child: Text(
                              _imagePath != null ? p.basename(_imagePath!) : 'Upload Image',
                              // Use basename to extract only the file name
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.bold,
                                overflow: TextOverflow.ellipsis, // Truncate text if too long
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
              SizedBox(height: 20),
              // Signup button
              Container(
                width: 150,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isEmailVerified ? _completeSignUp : null,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: primaryColor,
                  ),
                  child: Text(
                    'Signup',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              if (_errorMessage.isNotEmpty)
                Text(
                  _errorMessage,
                  style: TextStyle(color: Colors.red),
                ),
            ],
          ),
        ),
      ),
    );
  }
}