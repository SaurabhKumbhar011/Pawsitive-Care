import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UploadImageScreen extends StatefulWidget {
  @override
  _UploadImageScreenState createState() => _UploadImageScreenState();
}

class _UploadImageScreenState extends State<UploadImageScreen> {
  String? _base64Image;
  final ImagePicker _picker = ImagePicker();

  Future<void> pickImageAndConvert() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      Uint8List imageBytes = await image.readAsBytes();
      setState(() {
        _base64Image = base64Encode(imageBytes);
      });

      // Store base64 string in Firestore under 'images' collection
      await FirebaseFirestore.instance
          .collection('images')
          .doc('UniqueUserId') // Replace with unique user ID
          .set({'imageUrl': _base64Image});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Upload Profile Image')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: pickImageAndConvert,
              child: Text('Pick Image and Upload'),
            ),
          ],
        ),
      ),
    );
  }
}
