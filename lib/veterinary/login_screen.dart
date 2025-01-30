// import 'package:flutter/material.dart';
// import 'package:paw1/default_widget.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:paw1/veterinary/vetdashboard.dart'; // Import the Vet Dashboard
// import 'package:paw1/veterinary/vetsignupscreen.dart';
// import '../home_screen.dart'; // Import the home screen
// import '../gettingstarted_screen.dart'; // Import the Get Started screen
// import '../constant.dart'; // Import the color constants
//
// class VetLoginScreen extends StatefulWidget {
//   @override
//   _VetLoginScreenState createState() => _VetLoginScreenState();
// }
//
// class _VetLoginScreenState extends State<VetLoginScreen> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   String _errorMessage = ''; // Variable to hold error message
//
//   void _login() async {
//     try {
//       // Check if the email exists in Firestore first
//       String enteredEmail = _emailController.text.trim();
//       var docSnapshot = await FirebaseFirestore.instance
//           .collection('veterinarians')
//           .doc(enteredEmail)
//           .get();
//
//       if (docSnapshot.exists) {
//         // If the vet email exists in Firestore, proceed with Firebase Authentication
//         UserCredential userCredential = await _auth.signInWithEmailAndPassword(
//           email: enteredEmail,
//           password: _passwordController.text.trim(),
//         );
//         print("Vet logged in: ${userCredential.user?.email}");
//
//         Fluttertoast.showToast(
//           msg: "Login successful!",
//           toastLength: Toast.LENGTH_SHORT,
//           gravity: ToastGravity.BOTTOM,
//           timeInSecForIosWeb: 1,
//           backgroundColor: Colors.green,
//           textColor: Colors.white,
//           fontSize: 16.0,
//         );
//
//         // Navigate to Vet Dashboard on successful login
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => VetDashboard(vetEmail: enteredEmail)),
//         );
//       } else {
//         Fluttertoast.showToast(
//           msg: "Vet email not found in Firestore!",
//           toastLength: Toast.LENGTH_SHORT,
//           gravity: ToastGravity.CENTER,
//           backgroundColor: Colors.red,
//           textColor: Colors.white,
//         );
//       }
//     } catch (e) {
//       setState(() {
//         if (e is FirebaseAuthException) {
//           switch (e.code) {
//             case 'user-not-found':
//               _errorMessage = 'No user found for that email.';
//               break;
//             case 'wrong-password':
//               _errorMessage = 'Wrong password provided.';
//               break;
//             case 'invalid-email':
//               _errorMessage = 'The email address is not valid.';
//               break;
//             default:
//               _errorMessage = 'Please fill all fields.';
//           }
//         } else {
//           _errorMessage = 'An error occurred. Please try again.';
//         }
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar( backgroundColor: primaryColor,
//         title: Text('Veterinary Login'),
//         centerTitle: true,
//         //backgroundColor: primaryColor, // Match app bar color to primaryColor
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back), // Back icon
//           onPressed: () {
//             // Navigate back to the "Get Started" screen
//             Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(builder: (context) => GettingStartedScreen()),
//             );
//           },
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             TextField(
//               controller: _emailController,
//               decoration: InputDecoration(
//                 labelText: 'Email',
//                 prefixIcon: Icon(Icons.email),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10),
//                   borderSide: BorderSide(
//                     //color: primaryColor, // Use primaryColor for border
//                     width: 2.0,
//                   ),
//                 ),
//               ),
//             ),
//             SizedBox(height: 20),
//             TextField(
//               controller: _passwordController,
//               decoration: InputDecoration(
//                 labelText: 'Password',
//                 prefixIcon: Icon(Icons.lock),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10),
//                   borderSide: BorderSide(
//                     //color: primaryColor, // Use primaryColor for border
//                     width: 2.0,
//                   ),
//                 ),
//               ),
//               obscureText: true,
//             ),
//             SizedBox(height: 20),
//             Container(
//               width: 150,
//               height: 50,
//               child: ElevatedButton(
//                 onPressed: _login,
//                 child: Text(
//                   'Login',
//                   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                 ),
//                 style: ElevatedButton.styleFrom(
//                   foregroundColor: Colors.white,
//                   backgroundColor: primaryColor, // Use primaryColor for button
//                 ),
//               ),
//             ),
//             SizedBox(height: 20),
//             if (_errorMessage.isNotEmpty)
//               Text(
//                 _errorMessage,
//                 style: TextStyle(color: Colors.red),
//               ),
//             TextButton(
//               onPressed: () {
//                 // Redirect to veterinary signup screen
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => VeterinarySignupScreen()),
//                 );
//               },
//               child: Text('Don\'t have an account? Sign up'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:paw1/veterinary/vetdashboard.dart';
import 'package:paw1/veterinary/vetsignupscreen.dart';
import '../gettingstarted_screen.dart'; // Import the Get Started screen
import '../constant.dart'; // Import the color constants

class VetLoginScreen extends StatefulWidget {
  @override
  _VetLoginScreenState createState() => _VetLoginScreenState();
}


class _VetLoginScreenState extends State<VetLoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _errorMessage = ''; // Variable to hold error message

  void _login() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    // Check for empty fields
    if (email.isEmpty || password.isEmpty) {
      Fluttertoast.showToast(
        msg: "Please fill all fields.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    // Validate email format
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      Fluttertoast.showToast(
        msg: "Invalid email address.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    try {
      // Check if the email exists in Firestore first
      var docSnapshot = await FirebaseFirestore.instance
          .collection('veterinarians')
          .doc(email)
          .get();

      if (docSnapshot.exists) {
        // If the vet email exists in Firestore, proceed with Firebase Authentication
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Login successful
        Fluttertoast.showToast(
          msg: "Login successful!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );

        // Navigate to Vet Dashboard on successful login
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => VetDashboard(vetId: email),
          ),
        );
      } else {
        // Vet email not found in Firestore
        Fluttertoast.showToast(
          msg: "Vet email not found in Firestore!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    }catch (e) {
      // Debugging the error


      // Default error message
      String errorMessage = "An error occurred. Please try again.";

      // Check if the exception is a FirebaseAuthException
      if (e is FirebaseAuthException) {


        switch (e.code) {
          case 'invalid-credential':
            errorMessage = 'Password incorrect.';
            break;
          default:
            errorMessage = e.message ?? errorMessage;
        }
      } else {
        // Handle non-auth exceptions if any
        errorMessage = e.toString();
      }

      // Show the appropriate error message
      Fluttertoast.showToast(
        msg: errorMessage,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }


  void _sendPasswordResetEmail() async {
    try {
      await _auth.sendPasswordResetEmail(email: _emailController.text.trim());
      Fluttertoast.showToast(
        msg: "Password reset email sent! Check your inbox.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } catch (e) {
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( backgroundColor: primaryColor,
        title: Text('Veterinary Login'),
        centerTitle: true,
        //backgroundColor: primaryColor, // Match app bar color to primaryColor
        leading: IconButton(
          icon: Icon(Icons.arrow_back), // Back icon
          onPressed: () {
            // Navigate back to the "Get Started" screen
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => GettingStartedScreen()),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 250, // Set height
                width: 250, // Set width
                child: Image.asset(
                  'images/rb_6677.png', // Path to your image
                ),
              ),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      //color: primaryColor, // Use primaryColor for border
                      width: 2.0,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      //color: primaryColor, // Use primaryColor for border
                      width: 2.0,
                    ),
                  ),
                ),
                obscureText: true,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: _sendPasswordResetEmail,
                  child: Text(
                    'Forgot Password?',
                    style: TextStyle(color: primaryColor),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Container(
                width: 150,
                height: 50,
                child: ElevatedButton(
                  onPressed: _login,
                  child: Text(
                    'Login',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: primaryColor, // Use primaryColor for button
                  ),
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
                  // Redirect to veterinary signup screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => VeterinarySignupScreen()),
                  );
                },
                child: Text('Don\'t have an account? Sign up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}