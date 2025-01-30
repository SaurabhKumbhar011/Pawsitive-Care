import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DisplayImageScreen extends StatelessWidget {
  Future<Uint8List?> _fetchImage() async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('images')
        .doc('UniqueUserId') // Replace with unique user ID
        .get();

    if (doc.exists) {
      String base64Image = doc['imageUrl'];
      return base64Decode(base64Image);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Display Profile Image')),
      body: FutureBuilder<Uint8List?>(
        future: _fetchImage(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            return Center(
              child: Image.memory(snapshot.data!),
            );
          } else {
            return Center(child: Text('No Image Found'));
          }
        },
      ),
    );
  }
}
