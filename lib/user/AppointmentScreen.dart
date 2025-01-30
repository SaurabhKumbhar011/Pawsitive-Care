import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:paw1/constant.dart';

class AppointmentScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String userEmail = FirebaseAuth.instance.currentUser?.email ?? '';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text('My Appointments'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('userAppointments')
            .doc(userEmail)
            .collection('appointments')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No appointments found.'));
          }

          final appointments = snapshot.data!.docs;

          return ListView.builder(
            itemCount: appointments.length,
            itemBuilder: (context, index) {
              final appointment = appointments[index];
              final data = appointment.data() as Map<String, dynamic>;

              final petName = data['petName'] ?? 'Unknown';
              final petType = data['petType'] ?? 'Unknown';
              final petAge = data['petAge'] ?? 'Unknown';
              final appointmentDate = (data['appointmentDate'] as Timestamp).toDate();
              final status = data['status'] ?? 'Pending';
              final doctorName = data['drName'] ?? 'Unknown Doctor'; // Fetch doctor's name
              final imageBase64 = data['image'] ?? '';

              return Card(
                margin: const EdgeInsets.all(10),
                elevation: 5,
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 30,
                    backgroundImage: imageBase64.isNotEmpty
                        ? MemoryImage(base64Decode(imageBase64))
                        : null,
                    child: imageBase64.isEmpty ? const Icon(Icons.pets) : null,
                  ),
                  title: Text(
                    petName,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 5),
                      Text('Type: $petType'),
                      Text('Age: $petAge'),
                      Text('Date: ${appointmentDate.day}/${appointmentDate.month}/${appointmentDate.year}'),
                      Text('Doctor: $doctorName'), // Display doctor's name
                      const SizedBox(height: 5),
                      Text(
                        'Status: $status',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: status == 'Approved'
                              ? Colors.green
                              : status == 'Rejected'
                              ? Colors.red
                              : Colors.orange,
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