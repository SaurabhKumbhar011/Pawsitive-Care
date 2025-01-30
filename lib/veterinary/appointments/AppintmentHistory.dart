import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../constant.dart';

class HistoryAppointmentsPage extends StatefulWidget {
  final String vetEmail;

  const HistoryAppointmentsPage({Key? key, required this.vetEmail})
      : super(key: key);

  @override
  _HistoryAppointmentsPageState createState() =>
      _HistoryAppointmentsPageState();
}

class _HistoryAppointmentsPageState extends State<HistoryAppointmentsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Appointment History",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: primaryColor,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('historyAppointments') // Collection for history
            .doc(widget.vetEmail) // Vet email as the document ID
            .collection('appointments') // Sub-collection of appointments
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No appointment history."));
          }

          final appointments = snapshot.data!.docs;

          return ListView.builder(
            itemCount: appointments.length,
            itemBuilder: (context, index) {
              final appointment = appointments[index];
              final data = appointment.data() as Map<String, dynamic>;

              final petName = data['petName'] ?? 'Unknown';
              final petAge = data['petAge'] ?? 'N/A';
              final petType = data['petType'] ?? 'Unknown';
              final ownerEmail = data['ownerEmail'] ?? 'Unknown';
              final image = data['image'] ?? '';
              final DateTime dateTime = (data['appointmentDate'] as Timestamp).toDate();


              return Card(
                margin: const EdgeInsets.all(10.0),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Display Pet Image
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.grey[300],
                        child: image.isNotEmpty
                            ? ClipOval(
                          child: Image.memory(
                            base64Decode(image), // Decode Base64 image
                            fit: BoxFit.cover,
                            width: 80,
                            height: 80,
                          ),
                        )
                            : const Icon(Icons.pets, size: 40, color: Colors.white),
                      ),
                      const SizedBox(width: 16),
                      // Display Appointment Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              petName,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Age: $petAge",
                              style: const TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  petType,
                                  style: const TextStyle(fontSize: 16, color: Colors.black),
                                ),
                                Text(
                                  "Date: ${dateTime.day}/${dateTime.month}/${dateTime.year}",
                                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                                ),
                              ],
                            ),
                            Text(
                              "Owner: $ownerEmail",
                              style: const TextStyle(fontSize: 14, color: Colors.black54),
                            ),

                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}