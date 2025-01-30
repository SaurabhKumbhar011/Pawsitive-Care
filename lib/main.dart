import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:paw1/apis/MapScreen.dart';
import 'package:paw1/displayimage.dart';
import 'package:paw1/home_screen.dart';
import 'package:paw1/uploadimge.dart';
import 'package:paw1/user/login_screen.dart';
import 'package:paw1/user/userprofile.dart';
import 'package:paw1/veterinary/login_screen.dart';
import 'package:paw1/veterinary/vetdashboard.dart';
import 'package:paw1/veterinary/vetsignupscreen.dart';
import 'gettingstarted_screen.dart';
// Import the GettingStartedScreen

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Firebase Auth',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: GettingStartedScreen(), // Set GettingStartedScreen as the home screen
        // home: HomeScreen(),
        // home: MapScreen(),
      
    );
  }
}