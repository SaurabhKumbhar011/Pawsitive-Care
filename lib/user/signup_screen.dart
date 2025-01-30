import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:paw1/constant.dart';
import 'login_screen.dart';


const Color dprimaryColor = Color(0xFFF7924A);
const Color secondaryColor = Color(0xFFFBD2B6);

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _errorMessage = '';

  // Regular expressions for validation
  final RegExp emailRegExp = RegExp(r'^[a-zA-Z0-9.%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$');
  final RegExp _nameRegExp = RegExp(r'^[a-zA-Z\s]+$');  // Only allows letters and spaces
  final RegExp _phoneRegExp = RegExp(r'^\d{10}$');     // Exactly 10 digits

  bool _isVerificationEmailSent = false;
  bool _isEmailVerified = false;
  User? _temporaryUser;

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

    String name = _nameController.text.trim();
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
      await _firestore.collection('users').doc(email).set({
        'name': name,
        'email': email,
        'phone': phone,
        'password': password,
      });

      Fluttertoast.showToast(
        msg: 'Signup successful',
        backgroundColor: Colors.green,
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                LoginScreen()), // Replace with your login screen widget
      );
    } catch (e) {
      setState(() {
        _errorMessage = 'Signup failed. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Signup'),
        centerTitle: true,
        backgroundColor: dprimaryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: dprimaryColor,
                    width: 2.0,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: 'Phone Number',
                prefixIcon: Icon(Icons.phone),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: dprimaryColor,
                    width: 2.0,
                  ),
                ),
              ),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 20),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
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
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: Icon(Icons.lock),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: dprimaryColor,
                    width: 2.0,
                  ),
                ),
              ),
              obscureText: true,
            ),
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
                child: Text('Signup',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
              ),
            ),
            SizedBox(height: 20),
            if (_errorMessage.isNotEmpty)
              Text(
                _errorMessage,
                style: TextStyle(color: Colors.red),
              ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Go back to login screen
              },
              child: Text('Already have an account? Login'),
            ),
          ],
        ),
      ),
    );
  }
}