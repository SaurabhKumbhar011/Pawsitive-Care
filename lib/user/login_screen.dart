// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:paw1/user/signup_screen.dart';
// import 'package:paw1/veterinary/login_screen.dart';
// import '../home_screen.dart'; // Import the home screen
// import 'package:fluttertoast/fluttertoast.dart';
// import '../gettingstarted_screen.dart'; // Import the Get Started screen
// import '../constant.dart'; // Import the color constants from getting started screen
//
// class LoginScreen extends StatefulWidget {
//   @override
//   _LoginScreenState createState() => _LoginScreenState();
// }
//
// class _LoginScreenState extends State<LoginScreen> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   String _errorMessage = ''; // Variable to hold error message
//
//   void _login() async {
//     try {
//       UserCredential userCredential = await _auth.signInWithEmailAndPassword(
//         email: _emailController.text.trim(),
//         password: _passwordController.text.trim(),
//       );
//       print("User logged in: ${userCredential.user?.email}");
//
//       Fluttertoast.showToast(
//         msg: "Login successful!",
//         toastLength: Toast.LENGTH_SHORT,
//         gravity: ToastGravity.BOTTOM,
//         timeInSecForIosWeb: 1,
//         backgroundColor: Colors.green,
//         textColor: Colors.white,
//         fontSize: 16.0,
//       );
//       // Navigate to home screen on successful login
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => HomeScreen()),
//       );
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
//       appBar: AppBar(
//         title: Text('Login'),
//         centerTitle: true,
//         backgroundColor: primaryColor, // Match app bar color to primaryColor
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
//                     color: primaryColor, // Use primaryColor for border
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
//                     color: primaryColor, // Use primaryColor for border
//                     width: 2.0,
//                   ),
//                 ),
//               ),
//               obscureText: true,
//             ),
//             SizedBox(height: 30),
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
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => SignupScreen()),
//                 );
//               },
//               child: Text('Don\'t have an account? Sign up'),
//             ),
//            SizedBox(height: 60,),
//             ElevatedButton.icon(
//               onPressed: () {
//                 // Navigate to the Veterinary Login screen
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => VetLoginScreen()), // Assuming VetLoginScreen is your veterinary login screen
//                 );
//               },
//               icon: Icon(Icons.pets), // Icon for veterinary login
//               label: Text('Veterinary Login'),
//               style: ElevatedButton.styleFrom(
//                 foregroundColor: Colors.white,
//                 backgroundColor: primaryColor, // Use primaryColor for button
//                 padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
//               ),
//             ),
//
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:paw1/user/signup_screen.dart';
import '../home_screen.dart'; // Import the home screen
import '../gettingstarted_screen.dart';
import 'package:paw1/constant.dart';
import '../veterinary/login_screen.dart'; // Import the Get Started screen

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
      // Attempt login
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

      // Navigate to home screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } catch (e) {
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
      appBar: AppBar(
        title: Text('Login'),
        centerTitle: true,
        backgroundColor: primaryColor, // Match app bar color to primaryColor
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
          padding: const EdgeInsets.all(16),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 200, // Set height
                width: 200, // Set width
                child: Image.asset(
                  'images/rb_2148975448.png', // Path to your image
                ),
              ),
              SizedBox(height: 20,),

              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: primaryColor,
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
                      color: primaryColor,
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
              SizedBox(height: 30),
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
                    backgroundColor: primaryColor,
                  ),
                ),
              ),
              // SizedBox(height: 20),
              if (_errorMessage.isNotEmpty)
                Text(
                  _errorMessage,
                  style: TextStyle(color: Colors.red),
                ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignupScreen()),
                  );
                },
                child: Text('Don\'t have an account? Sign up'),
              ),
              SizedBox(height: 60,),
              ElevatedButton.icon(
                onPressed: () {
                  // Navigate to the Veterinary Login screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => VetLoginScreen()), // Assuming VetLoginScreen is your veterinary login screen
                  );
                },
                icon: Icon(Icons.pets), // Icon for veterinary login
                label: Text('Veterinary Login'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: primaryColor, // Use primaryColor for button
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}