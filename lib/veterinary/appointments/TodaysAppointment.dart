// import 'dart:convert';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:paw1/constant.dart';
//
// class TodaysAppointmentsPage extends StatefulWidget {
//   final String vetEmail;
//
//   const TodaysAppointmentsPage({Key? key, required this.vetEmail}) : super(key: key);
//
//   @override
//   _TodaysAppointmentsPageState createState() => _TodaysAppointmentsPageState();
// }
//
// class _TodaysAppointmentsPageState extends State<TodaysAppointmentsPage> {
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         title: const Text("Today's Appointments"),
//         backgroundColor: primaryColor,
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance
//             .collection('todaysAppointments')
//             .doc(widget.vetEmail)
//             .collection('appointments')
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           }
//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return const Center(child: Text("No appointments for today."));
//           }
//
//           final appointments = snapshot.data!.docs;
//
//           return ListView.builder(
//             itemCount: appointments.length,
//             itemBuilder: (context, index) {
//               final appointment = appointments[index];
//               final data = appointment.data() as Map<String, dynamic>;
//
//               final petName = data['petName'] ?? 'Unknown';
//               final petAge = data['petAge'] ?? 'N/A';
//               final petType = data['petType'] ?? 'Unknown';
//               final ownerEmail = data['ownerEmail'] ?? 'Unknown';
//               final image = data['image'] ?? '';
//               final timestamp = (data['timestamp'] as Timestamp?)?.toDate();
//               final formattedDate = timestamp != null
//                   ? "${timestamp.day}-${timestamp.month}-${timestamp.year}"
//                   : 'Unknown Date';
//
//               return Card(
//                 margin: const EdgeInsets.all(10.0),
//                 child: Padding(
//                   padding: const EdgeInsets.all(12.0),
//                   child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // Display Pet Image
//                       CircleAvatar(
//                         radius: 40,
//                         backgroundColor: Colors.grey[300],
//                         child: image.isNotEmpty
//                             ? ClipOval(
//                           child: Image.memory(
//                             base64Decode(image), // Decode Base64 image
//                             fit: BoxFit.cover,
//                             width: 80,
//                             height: 80,
//                           ),
//                         )
//                             : const Icon(Icons.pets, size: 40, color: Colors.white),
//                       ),
//                       const SizedBox(width: 16),
//                       // Display Appointment Details
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               petName,
//                               style: const TextStyle(
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             Text(
//                               "Age: $petAge",
//                               style: const TextStyle(fontSize: 16, color: Colors.grey),
//                             ),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Text(
//                                   petType,
//                                   style: const TextStyle(fontSize: 16, color: Colors.black),
//                                 ),
//                                 Text(
//                                   "Date: $formattedDate",
//                                   style: const TextStyle(fontSize: 14, color: Colors.black87),
//                                 ),
//                               ],
//                             ),
//                             Text(
//                               "Owner: $ownerEmail",
//                               style: const TextStyle(fontSize: 14, color: Colors.black54),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }

// import 'dart:convert';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
//
// import '../../constant.dart';
//
// class TodaysAppointmentsPage extends StatefulWidget {
//   final String vetEmail;
//
//   const TodaysAppointmentsPage({Key? key, required this.vetEmail}) : super(key: key);
//
//   @override
//   _TodaysAppointmentsPageState createState() => _TodaysAppointmentsPageState();
// }
//
// class _TodaysAppointmentsPageState extends State<TodaysAppointmentsPage> {
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//         centerTitle: true,
//         title: const Text("Today's Appointments"),
//         backgroundColor: primaryColor,
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance
//             .collection('todaysAppointments')
//             .doc(widget.vetEmail)
//             .collection('appointments')
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           }
//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return const Center(child: Text("No appointments for today."));
//           }
//
//           final appointments = snapshot.data!.docs;
//
//           return ListView.builder(
//             itemCount: appointments.length,
//             itemBuilder: (context, index) {
//               final appointment = appointments[index];
//               final data = appointment.data() as Map<String, dynamic>;
//
//               final petName = data['petName'] ?? 'Unknown';
//               final petAge = data['petAge'] ?? 'N/A';
//               final petType = data['petType'] ?? 'Unknown';
//               final ownerEmail = data['ownerEmail'] ?? 'Unknown';
//               final image = data['image'] ?? '';
//               final DateTime dateTime = (data['appointmentDate'] as Timestamp).toDate();
//
//
//               return Card(
//                 margin: const EdgeInsets.all(10.0),
//                 child: Padding(
//                   padding: const EdgeInsets.all(12.0),
//                   child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // Display Pet Image
//                       CircleAvatar(
//                         radius: 40,
//                         backgroundColor: Colors.grey[300],
//                         child: image.isNotEmpty
//                             ? ClipOval(
//                           child: Image.memory(
//                             base64Decode(image), // Decode Base64 image
//                             fit: BoxFit.cover,
//                             width: 80,
//                             height: 80,
//                           ),
//                         )
//                             : const Icon(Icons.pets, size: 40, color: Colors.white),
//                       ),
//                       const SizedBox(width: 16),
//                       // Display Appointment Details
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               petName,
//                               style: const TextStyle(
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             Text(
//                               "Age: $petAge",
//                               style: const TextStyle(fontSize: 16, color: Colors.grey),
//                             ),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Text(
//                                   petType,
//                                   style: const TextStyle(fontSize: 16, color: Colors.black),
//                                 ),
//                                 Text(
//                                   "Date: ${dateTime.day}/${dateTime.month}/${dateTime.year}",
//                                   style: const TextStyle(fontSize: 14, color: Colors.black87),
//                                 ),
//                               ],
//                             ),
//                             Text(
//                               "Owner: $ownerEmail",
//                               style: const TextStyle(fontSize: 14, color: Colors.black54),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }

// //26/03
// import 'dart:convert';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
//
// import '../../constant.dart';
//
// class TodaysAppointmentsPage extends StatefulWidget {
//   final String vetEmail;
//
//   const TodaysAppointmentsPage({Key? key, required this.vetEmail}) : super(key: key);
//
//   @override
//   _TodaysAppointmentsPageState createState() => _TodaysAppointmentsPageState();
// }
//
// class _TodaysAppointmentsPageState extends State<TodaysAppointmentsPage> {
//   final DateTime today = DateTime.now();
//
//   void moveToHistory(DocumentSnapshot appointment) async {
//     final data = appointment.data() as Map<String, dynamic>;
//     final ownerEmail = data['ownerEmail'] ?? '';
//
//     await FirebaseFirestore.instance
//         .collection('historyAppointments')
//         .doc(widget.vetEmail)
//         .collection('appointments')
//         .doc(appointment.id)
//         .set(data);
//
//     await FirebaseFirestore.instance
//         .collection('todaysAppointments')
//         .doc(widget.vetEmail)
//         .collection('appointments')
//         .doc(appointment.id)
//         .delete();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         title: const Text("Today's Appointments"),
//         backgroundColor: primaryColor,
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance
//             .collection('todaysAppointments')
//             .doc(widget.vetEmail)
//             .collection('appointments')
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           }
//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return const Center(child: Text("No appointments for today."));
//           }
//
//           final appointments = snapshot.data!.docs;
//
//           return ListView.builder(
//             itemCount: appointments.length,
//             itemBuilder: (context, index) {
//               final appointment = appointments[index];
//               final data = appointment.data() as Map<String, dynamic>;
//               final DateTime dateTime = (data['appointmentDate'] as Timestamp).toDate();
//
//               // Check if the appointment is outdated
//               if (dateTime.isBefore(DateTime(today.year, today.month, today.day))) {
//                 moveToHistory(appointment);
//                 return const SizedBox();
//               }
//
//               return Card(
//                 margin: const EdgeInsets.all(10.0),
//                 child: Padding(
//                   padding: const EdgeInsets.all(12.0),
//                   child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       CircleAvatar(
//                         radius: 40,
//                         backgroundColor: Colors.grey[300],
//                         child: data['image'] != null && data['image'].isNotEmpty
//                             ? ClipOval(
//                           child: Image.memory(
//                             base64Decode(data['image']),
//                             fit: BoxFit.cover,
//                             width: 80,
//                             height: 80,
//                           ),
//                         )
//                             : const Icon(Icons.pets, size: 40, color: Colors.white),
//                       ),
//                       const SizedBox(width: 16),
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               data['petName'] ?? 'Unknown',
//                               style: const TextStyle(
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             Text(
//                               "Age: ${data['petAge'] ?? 'N/A'}",
//                               style: const TextStyle(fontSize: 16, color: Colors.grey),
//                             ),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Text(
//                                   data['petType'] ?? 'Unknown',
//                                   style: const TextStyle(fontSize: 16, color: Colors.black),
//                                 ),
//                                 Text(
//                                   "Date: ${dateTime.day}/${dateTime.month}/${dateTime.year}",
//                                   style: const TextStyle(fontSize: 14, color: Colors.black87),
//                                 ),
//                               ],
//                             ),
//                             Text(
//                               "Owner: ${data['ownerEmail'] ?? 'Unknown'}",
//                               style: const TextStyle(fontSize: 14, color: Colors.black54),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }

//06/04

import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../constant.dart';

class TodaysAppointmentsPage extends StatefulWidget {
  final String vetEmail;

  const TodaysAppointmentsPage({Key? key, required this.vetEmail}) : super(key: key);

  @override
  _TodaysAppointmentsPageState createState() => _TodaysAppointmentsPageState();
}

class _TodaysAppointmentsPageState extends State<TodaysAppointmentsPage> {
  final DateTime today = DateTime.now();

  void moveToHistory(DocumentSnapshot appointment) async {
    final data = appointment.data() as Map<String, dynamic>;
    await FirebaseFirestore.instance
        .collection('historyAppointments')
        .doc(widget.vetEmail)
        .collection('appointments')
        .doc(appointment.id)
        .set(data);

    await appointment.reference.delete();
  }

  void rescheduleAppointment(DocumentSnapshot appointment) async {
    DateTime? newDate = await showDatePicker(
      context: context,
      initialDate: today,
      firstDate: today,
      lastDate: DateTime(today.year + 1),
    );

    if (newDate != null) {
      final newTimestamp = Timestamp.fromDate(newDate);
      final data = appointment.data() as Map<String, dynamic>;
      data['appointmentDate'] = newTimestamp;

      if (newDate.isAfter(DateTime(today.year, today.month, today.day))) {
        await FirebaseFirestore.instance
            .collection('upcomingAppointments')
            .doc(widget.vetEmail)
            .collection('appointments')
            .doc(appointment.id)
            .set(data);

        await appointment.reference.delete();
      } else {
        await appointment.reference.update({'appointmentDate': newTimestamp});
      }
    }
  }

  void cancelAppointment(DocumentSnapshot appointment) async {
    await appointment.reference.delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Today's Appointments"),
        backgroundColor: primaryColor,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('todaysAppointments')
            .doc(widget.vetEmail)
            .collection('appointments')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No appointments for today."));
          }

          final appointments = snapshot.data!.docs;

          return ListView.builder(
            itemCount: appointments.length,
            itemBuilder: (context, index) {
              final appointment = appointments[index];
              final data = appointment.data() as Map<String, dynamic>;
              final DateTime dateTime = (data['appointmentDate'] as Timestamp).toDate();
              final ownerEmail = data['ownerEmail'];
              final appointmentId = appointment.id;

              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('userAppointments')
                    .doc(ownerEmail)
                    .collection('appointments')
                    .doc(appointmentId)
                    .get(),
                builder: (context, userSnapshot) {
                  if (userSnapshot.connectionState == ConnectionState.waiting) {
                    return const SizedBox();
                  }

                  if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
                    appointment.reference.delete();
                    return const SizedBox();
                  }

                  final userData = userSnapshot.data!.data() as Map<String, dynamic>;

                  if (userData['isCancelledByUser'] == true) {
                    appointment.reference.delete(); // auto remove if user cancelled
                    return const SizedBox();
                  }

                  if (dateTime.isBefore(DateTime(today.year, today.month, today.day))) {
                    moveToHistory(appointment);
                    return const SizedBox();
                  }

                  return Card(
                    margin: const EdgeInsets.all(10.0),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 40,
                                backgroundColor: Colors.grey[300],
                                child: data['image'] != null && data['image'].isNotEmpty
                                    ? ClipOval(
                                  child: Image.memory(
                                    base64Decode(data['image']),
                                    fit: BoxFit.cover,
                                    width: 80,
                                    height: 80,
                                  ),
                                )
                                    : const Icon(Icons.pets, size: 40, color: Colors.white),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(data['petName'] ?? 'Unknown',
                                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                    Text("Age: ${data['petAge'] ?? 'N/A'}"),
                                    Text("Type: ${data['petType'] ?? 'Unknown'}"),
                                    Text("Owner: ${data['ownerEmail'] ?? 'Unknown'}"),
                                    Text("Date: ${dateTime.day}/${dateTime.month}/${dateTime.year}"),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                onPressed: () => moveToHistory(appointment),
                                child: const Text("Done"),
                              ),
                              ElevatedButton(
                                onPressed: () => rescheduleAppointment(appointment),
                                child: const Text("Reschedule"),
                              ),
                              ElevatedButton(
                                onPressed: () => cancelAppointment(appointment),
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                child: const Text("Cancel"),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
