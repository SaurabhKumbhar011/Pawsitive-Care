// // import 'dart:convert';
// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_rating_bar/flutter_rating_bar.dart';
// // import 'package:paw1/constant.dart';
// //
// // class AppointmentScreen extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     String userEmail = FirebaseAuth.instance.currentUser?.email ?? '';
// //
// //     return Scaffold(
// //       appBar: AppBar(
// //         backgroundColor: primaryColor,
// //         title: const Text('My Appointments'),
// //       ),
// //       body: StreamBuilder<QuerySnapshot>(
// //         stream: FirebaseFirestore.instance
// //             .collection('userAppointments')
// //             .doc(userEmail)
// //             .collection('appointments')
// //             .snapshots(),
// //         builder: (context, snapshot) {
// //           if (snapshot.connectionState == ConnectionState.waiting) {
// //             return const Center(child: CircularProgressIndicator());
// //           }
// //           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
// //             return const Center(child: Text('No appointments found.'));
// //           }
// //
// //           final appointments = snapshot.data!.docs;
// //
// //           return ListView.builder(
// //             itemCount: appointments.length,
// //             itemBuilder: (context, index) {
// //               final appointment = appointments[index];
// //               final data = appointment.data() as Map<String, dynamic>;
// //
// //               final petName = data['petName'] ?? 'Unknown';
// //               final petType = data['petType'] ?? 'Unknown';
// //               final petAge = data['petAge'] ?? 'Unknown';
// //               final appointmentDate = (data['appointmentDate'] as Timestamp).toDate();
// //               final status = data['status'] ?? 'Pending';
// //               final doctorEmail = data['drEmail'] ?? '';
// //               final doctorName = data['drName'] ?? 'Unknown Doctor';
// //               final imageBase64 = data['image'] ?? '';
// //               final rescheduledDate = data['rescheduledDate'] != null
// //                   ? (data['rescheduledDate'] as Timestamp).toDate()
// //                   : null;
// //
// //               Color statusColor;
// //               String statusText;
// //
// //               if (status == 'Approved') {
// //                 statusColor = Colors.green;
// //                 statusText = 'Approved';
// //               } else if (status == 'Rejected') {
// //                 statusColor = Colors.red;
// //                 statusText = 'Rejected';
// //               } else if (status == 'Canceled') {
// //                 statusColor = Colors.red;
// //                 statusText = 'Canceled';
// //               } else if (status == 'Rescheduled') {
// //                 statusColor = Colors.blue;
// //                 statusText = 'Rescheduled';
// //               } else {
// //                 statusColor = Colors.orange;
// //                 statusText = 'Pending';
// //               }
// //
// //               return Card(
// //                 margin: const EdgeInsets.all(10),
// //                 elevation: 5,
// //                 child: Padding(
// //                   padding: const EdgeInsets.all(10.0),
// //                   child: Column(
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     children: [
// //                       Row(
// //                         children: [
// //                           CircleAvatar(
// //                             radius: 30,
// //                             backgroundImage: imageBase64.isNotEmpty
// //                                 ? MemoryImage(base64Decode(imageBase64))
// //                                 : null,
// //                             child: imageBase64.isEmpty ? const Icon(Icons.pets) : null,
// //                           ),
// //                           const SizedBox(width: 10),
// //                           Expanded(
// //                             child: Column(
// //                               crossAxisAlignment: CrossAxisAlignment.start,
// //                               children: [
// //                                 Text(petName,
// //                                     style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
// //                                 Text('Type: $petType'),
// //                                 Text('Age: $petAge'),
// //                                 Text('Appointment Date: ${appointmentDate.day}/${appointmentDate.month}/${appointmentDate.year}'),
// //                                 Text('Doctor: $doctorName'),
// //                               ],
// //                             ),
// //                           ),
// //                         ],
// //                       ),
// //                       const SizedBox(height: 10),
// //                       Row(
// //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                         children: [
// //                           Text(
// //                             'Status: $statusText',
// //                             style: TextStyle(fontWeight: FontWeight.bold, color: statusColor),
// //                           ),
// //                           if (status == 'Approved')
// //                             TextButton(
// //                               onPressed: () {
// //                                 _cancelAppointment(appointment.id, userEmail, doctorEmail);
// //                               },
// //                               child: const Text('Cancel', style: TextStyle(color: Colors.red)),
// //                             ),
// //                         ],
// //                       ),
// //                       if (status == 'Rescheduled' && rescheduledDate != null)
// //                         Padding(
// //                           padding: const EdgeInsets.only(top: 5.0),
// //                           child: Text(
// //                             'Rescheduled Date: ${rescheduledDate.day}/${rescheduledDate.month}/${rescheduledDate.year}',
// //                             style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
// //                           ),
// //                         ),
// //                       if (status == 'Approved')
// //                         Align(
// //                           alignment: Alignment.centerRight,
// //                           child: TextButton(
// //                             onPressed: () {
// //                               _showRatingDialog(context, userEmail, doctorEmail);
// //                             },
// //                             child: const Text('Rate & Feedback', style: TextStyle(color: Colors.amber)),
// //                           ),
// //                         ),
// //                     ],
// //                   ),
// //                 ),
// //               );
// //             },
// //           );
// //         },
// //       ),
// //     );
// //   }
// //
// //   void _cancelAppointment(String appointmentId, String userEmail, String doctorEmail) async {
// //     final appointmentRef = FirebaseFirestore.instance
// //         .collection('userAppointments')
// //         .doc(userEmail)
// //         .collection('appointments')
// //         .doc(appointmentId);
// //
// //     await appointmentRef.update({
// //       'status': 'Canceled',
// //       'isCancelledByUser': true,
// //     });
// //
// //     final vetRef = FirebaseFirestore.instance
// //         .collection('todaysAppointments')
// //         .doc(doctorEmail)
// //         .collection('appointments')
// //         .doc(appointmentId);
// //
// //     final vetSnapshot = await vetRef.get();
// //     if (vetSnapshot.exists) {
// //       await vetRef.delete();
// //     }
// //   }
// //
// //   void _showRatingDialog(BuildContext context, String userEmail, String doctorEmail) {
// //     double rating = 3.0;
// //     TextEditingController feedbackController = TextEditingController();
// //
// //     showDialog(
// //       context: context,
// //       builder: (context) {
// //         return AlertDialog(
// //           title: const Text('Rate Your Experience'),
// //           content: Column(
// //             mainAxisSize: MainAxisSize.min,
// //             children: [
// //               const Text('Rate the veterinary service:'),
// //               RatingBar.builder(
// //                 initialRating: 3.0,
// //                 minRating: 1,
// //                 direction: Axis.horizontal,
// //                 allowHalfRating: false,
// //                 itemCount: 5,
// //                 itemBuilder: (context, _) => const Icon(
// //                   Icons.star,
// //                   color: Colors.amber,
// //                 ),
// //                 onRatingUpdate: (value) {
// //                   rating = value;
// //                 },
// //               ),
// //               TextField(
// //                 controller: feedbackController,
// //                 decoration: const InputDecoration(labelText: 'Enter your feedback'),
// //                 maxLines: 3,
// //               ),
// //             ],
// //           ),
// //           actions: [
// //             TextButton(
// //               onPressed: () => Navigator.pop(context),
// //               child: const Text('Cancel', style: TextStyle(color: Colors.red)),
// //             ),
// //             TextButton(
// //               onPressed: () {
// //                 _submitFeedback(userEmail, doctorEmail, rating, feedbackController.text);
// //                 Navigator.pop(context);
// //               },
// //               child: const Text('Submit', style: TextStyle(color: Colors.green)),
// //             ),
// //           ],
// //         );
// //       },
// //     );
// //   }
// //
// //   void _submitFeedback(String userEmail, String doctorEmail, double rating, String feedback) async {
// //     FirebaseFirestore.instance.collection('veterinarianFeedback').add({
// //       'userEmail': userEmail,
// //       'doctorEmail': doctorEmail,
// //       'rating': rating,
// //       'feedback': feedback,
// //       'timestamp': Timestamp.now(),
// //     });
// //   }
// // }
//
// //06/04
// import 'dart:convert';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_rating_bar/flutter_rating_bar.dart';
// import 'package:paw1/constant.dart';
//
// class AppointmentScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     String userEmail = FirebaseAuth.instance.currentUser?.email ?? '';
//
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: primaryColor,
//         title: const Text('My Appointments'),
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance
//             .collection('userAppointments')
//             .doc(userEmail)
//             .collection('appointments')
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return const Center(child: Text('No appointments found.'));
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
//               final petType = data['petType'] ?? 'Unknown';
//               final petAge = data['petAge'] ?? 'Unknown';
//               final appointmentDate =
//               (data['appointmentDate'] as Timestamp).toDate();
//               final status = data['status'] ?? 'Pending';
//               final doctorEmail = data['drEmail'] ?? '';
//               final doctorName = data['drName'] ?? 'Unknown Doctor';
//               final imageBase64 = data['image'] ?? '';
//               final rescheduledDate = data['rescheduledDate'] != null
//                   ? (data['rescheduledDate'] as Timestamp).toDate()
//                   : null;
//
//               Color statusColor;
//               String statusText;
//
//               if (status == 'Approved') {
//                 statusColor = Colors.green;
//                 statusText = 'Approved';
//               } else if (status == 'Rejected') {
//                 statusColor = Colors.red;
//                 statusText = 'Rejected';
//               } else if (status == 'Canceled') {
//                 statusColor = Colors.red;
//                 statusText = 'Canceled';
//               } else if (status == 'Rescheduled') {
//                 statusColor = Colors.blue;
//                 statusText = 'Rescheduled';
//               } else {
//                 statusColor = Colors.orange;
//                 statusText = 'Pending';
//               }
//
//               return Card(
//                 margin: const EdgeInsets.all(10),
//                 elevation: 5,
//                 child: Padding(
//                   padding: const EdgeInsets.all(10.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         children: [
//                           CircleAvatar(
//                             radius: 30,
//                             backgroundImage: imageBase64.isNotEmpty
//                                 ? MemoryImage(base64Decode(imageBase64))
//                                 : null,
//                             child: imageBase64.isEmpty
//                                 ? const Icon(Icons.pets)
//                                 : null,
//                           ),
//                           const SizedBox(width: 10),
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(petName,
//                                     style: const TextStyle(
//                                         fontSize: 18,
//                                         fontWeight: FontWeight.bold)),
//                                 Text('Type: $petType'),
//                                 Text('Age: $petAge'),
//                                 Text(
//                                     'Appointment Date: ${appointmentDate.day}/${appointmentDate.month}/${appointmentDate.year}'),
//                                 Text('Doctor: $doctorName'),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 10),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             'Status: $statusText',
//                             style: TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 color: statusColor),
//                           ),
//                           if (status == 'Approved')
//                             TextButton(
//                               onPressed: () {
//                                 _cancelAppointment(
//                                     appointment.id, userEmail, doctorEmail);
//                               },
//                               child: const Text('Cancel',
//                                   style: TextStyle(color: Colors.red)),
//                             ),
//                         ],
//                       ),
//                       if (status == 'Rescheduled' && rescheduledDate != null)
//                         Padding(
//                           padding: const EdgeInsets.only(top: 5.0),
//                           child: Text(
//                             'Rescheduled Date: ${rescheduledDate.day}/${rescheduledDate.month}/${rescheduledDate.year}',
//                             style: const TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.blue),
//                           ),
//                         ),
//                       if (status == 'Approved')
//                         Align(
//                           alignment: Alignment.centerRight,
//                           child: TextButton(
//                             onPressed: () {
//                               _showRatingDialog(
//                                   context, userEmail, doctorEmail, doctorName);
//                             },
//                             child: const Text('Rate & Feedback',
//                                 style: TextStyle(color: Colors.amber)),
//                           ),
//                         ),
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
//
//   void _cancelAppointment(
//       String appointmentId, String userEmail, String doctorEmail) async {
//     final appointmentRef = FirebaseFirestore.instance
//         .collection('userAppointments')
//         .doc(userEmail)
//         .collection('appointments')
//         .doc(appointmentId);
//
//     await appointmentRef.update({
//       'status': 'Canceled',
//       'isCancelledByUser': true,
//     });
//
//     final vetRef = FirebaseFirestore.instance
//         .collection('todaysAppointments')
//         .doc(doctorEmail)
//         .collection('appointments')
//         .doc(appointmentId);
//
//     final vetSnapshot = await vetRef.get();
//     if (vetSnapshot.exists) {
//       await vetRef.delete();
//     }
//   }
//
//   void _showRatingDialog(BuildContext context, String userEmail,
//       String doctorEmail, String doctorName) {
//     double rating = 3.0;
//     TextEditingController feedbackController = TextEditingController();
//
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text('Rate Your Experience'),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               const Text('Rate the veterinary service:'),
//               RatingBar.builder(
//                 initialRating: 3.0,
//                 minRating: 1,
//                 direction: Axis.horizontal,
//                 allowHalfRating: false,
//                 itemCount: 5,
//                 itemBuilder: (context, _) => const Icon(
//                   Icons.star,
//                   color: Colors.amber,
//                 ),
//                 onRatingUpdate: (value) {
//                   rating = value;
//                 },
//               ),
//               TextField(
//                 controller: feedbackController,
//                 decoration:
//                 const InputDecoration(labelText: 'Enter your feedback'),
//                 maxLines: 3,
//               ),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text('Cancel', style: TextStyle(color: Colors.red)),
//             ),
//             TextButton(
//               onPressed: () async {
//                 if (doctorEmail.trim().isNotEmpty) {
//                   await _submitFeedback(
//                     userEmail,
//                     doctorEmail,
//                     doctorName,
//                     rating,
//                     feedbackController.text,
//                   );
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(
//                       content: Text('Feedback submitted successfully'),
//                     ),
//                   );
//                 } else {
//                   print("Error: doctorEmail is empty, feedback not submitted.");
//                 }
//                 Navigator.pop(context);
//               },
//               child: const Text('Submit',
//                   style: TextStyle(color: Colors.green)),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   Future<void> _submitFeedback(
//       String userEmail,
//       String doctorEmail,
//       String doctorName,
//       double rating,
//       String feedback) async {
//     final formattedEmail = doctorEmail.replaceAll('.', ',');
//
//     final feedbackData = {
//       'userEmail': userEmail,
//       'doctorEmail': doctorEmail,
//       'doctorName': doctorName,
//       'rating': rating,
//       'feedback': feedback,
//       'timestamp': Timestamp.now(),
//     };
//
//     try {
//       print('Submitting feedback for $formattedEmail...');
//       await FirebaseFirestore.instance
//           .collection('veterinarianFeedback')
//           .doc(formattedEmail)
//           .collection('feedbacks')
//           .add(feedbackData);
//       print('✅ Feedback successfully submitted to Firestore.');
//     } catch (e) {
//       print('❌ Error writing feedback to Firestore: $e');
//     }
//   }
// }

//15/05
// import 'dart:convert';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_rating_bar/flutter_rating_bar.dart';
// import 'package:paw1/constant.dart';
//
// class AppointmentScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     String userEmail = FirebaseAuth.instance.currentUser?.email ?? '';
//
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: primaryColor,
//         title: const Text('My Appointments'),
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance
//             .collection('userAppointments')
//             .doc(userEmail)
//             .collection('appointments')
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return const Center(child: Text('No appointments found.'));
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
//               final petType = data['petType'] ?? 'Unknown';
//               final petAge = data['petAge'] ?? 'Unknown';
//               final appointmentDate =
//               (data['appointmentDate'] as Timestamp).toDate();
//               final status = data['status'] ?? 'Pending';
//               final doctorEmail = data['drEmail'] ?? '';
//               final doctorName = data['drName'] ?? 'Unknown Doctor';
//               final imageBase64 = data['image'] ?? '';
//               final rescheduledDate = data['rescheduledDate'] != null
//                   ? (data['rescheduledDate'] as Timestamp).toDate()
//                   : null;
//
//               Color statusColor;
//               String statusText;
//
//               if (status == 'Approved') {
//                 statusColor = Colors.green;
//                 statusText = 'Approved';
//               } else if (status == 'Rejected') {
//                 statusColor = Colors.red;
//                 statusText = 'Rejected';
//               } else if (status == 'Canceled') {
//                 statusColor = Colors.red;
//                 statusText = 'Canceled';
//               } else if (status == 'Rescheduled') {
//                 statusColor = Colors.blue;
//                 statusText = 'Rescheduled';
//               } else {
//                 statusColor = Colors.orange;
//                 statusText = 'Pending';
//               }
//
//               return Card(
//                 margin: const EdgeInsets.all(10),
//                 elevation: 5,
//                 child: Padding(
//                   padding: const EdgeInsets.all(10.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         children: [
//                           CircleAvatar(
//                             radius: 30,
//                             backgroundImage: imageBase64.isNotEmpty
//                                 ? MemoryImage(base64Decode(imageBase64))
//                                 : null,
//                             child: imageBase64.isEmpty
//                                 ? const Icon(Icons.pets)
//                                 : null,
//                           ),
//                           const SizedBox(width: 10),
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(petName,
//                                     style: const TextStyle(
//                                         fontSize: 18,
//                                         fontWeight: FontWeight.bold)),
//                                 Text('Type: $petType'),
//                                 Text('Age: $petAge'),
//                                 Text(
//                                     'Appointment Date: ${appointmentDate.day}/${appointmentDate.month}/${appointmentDate.year}'),
//                                 Text('Doctor: $doctorName'),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 10),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             'Status: $statusText',
//                             style: TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 color: statusColor),
//                           ),
//                           if (status == 'Approved')
//                             TextButton(
//                               onPressed: () {
//                                 _cancelAppointment(
//                                     appointment.id, userEmail, doctorEmail);
//                               },
//                               child: const Text('Cancel',
//                                   style: TextStyle(color: Colors.red)),
//                             ),
//                         ],
//                       ),
//                       if (status == 'Rescheduled' && rescheduledDate != null)
//                         Padding(
//                           padding: const EdgeInsets.only(top: 5.0),
//                           child: Text(
//                             'Rescheduled Date: ${rescheduledDate.day}/${rescheduledDate.month}/${rescheduledDate.year}',
//                             style: const TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.blue),
//                           ),
//                         ),
//                       if (status == 'Approved')
//                         Align(
//                           alignment: Alignment.centerRight,
//                           child: TextButton(
//                             onPressed: () {
//                               _showRatingDialog(
//                                   context, userEmail, doctorEmail, doctorName);
//                             },
//                             child: const Text('Rate & Feedback',
//                                 style: TextStyle(color: Colors.amber)),
//                           ),
//                         ),
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
//
//   void _cancelAppointment(
//       String appointmentId, String userEmail, String doctorEmail) async {
//     final appointmentRef = FirebaseFirestore.instance
//         .collection('userAppointments')
//         .doc(userEmail)
//         .collection('appointments')
//         .doc(appointmentId);
//
//     await appointmentRef.update({
//       'status': 'Canceled',
//       'isCancelledByUser': true,
//     });
//
//     final vetRef = FirebaseFirestore.instance
//         .collection('todaysAppointments')
//         .doc(doctorEmail)
//         .collection('appointments')
//         .doc(appointmentId);
//
//     final vetSnapshot = await vetRef.get();
//     if (vetSnapshot.exists) {
//       await vetRef.delete();
//     }
//   }
//
//   void _showRatingDialog(BuildContext context, String userEmail,
//       String doctorEmail, String doctorName) {
//     double rating = 3.0;
//     TextEditingController feedbackController = TextEditingController();
//
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text('Rate Your Experience'),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               const Text('Rate the veterinary service:'),
//               RatingBar.builder(
//                 initialRating: 3.0,
//                 minRating: 1,
//                 direction: Axis.horizontal,
//                 allowHalfRating: false,
//                 itemCount: 5,
//                 itemBuilder: (context, _) => const Icon(
//                   Icons.star,
//                   color: Colors.amber,
//                 ),
//                 onRatingUpdate: (value) {
//                   rating = value;
//                 },
//               ),
//               TextField(
//                 controller: feedbackController,
//                 decoration: const InputDecoration(
//                     labelText: 'Enter your feedback'),
//                 maxLines: 3,
//               ),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text('Cancel', style: TextStyle(color: Colors.red)),
//             ),
//             TextButton(
//               onPressed: () async {
//                 if (doctorEmail.trim().isNotEmpty) {
//                   await _submitFeedback(
//                     userEmail,
//                     doctorEmail,
//                     doctorName,
//                     rating,
//                     feedbackController.text,
//                   );
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(
//                       content: Text('Feedback submitted successfully'),
//                     ),
//                   );
//                 }
//                 Navigator.pop(context);
//               },
//               child:
//               const Text('Submit', style: TextStyle(color: Colors.green)),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   Future<void> _submitFeedback(
//       String userEmail,
//       String doctorEmail,
//       String doctorName,
//       double rating,
//       String feedback,
//       ) async {
//     final formattedEmail = doctorEmail.replaceAll('.', ',');
//
//     final feedbackDocRef =
//     FirebaseFirestore.instance.collection('vetFeedback').doc(formattedEmail);
//
//     final feedbackData = {
//       'userEmail': userEmail,
//       'rating': rating,
//       'feedback': feedback,
//       'timestamp': Timestamp.now(),
//     };
//
//     try {
//       print('Setting doctorName: $doctorName');
//       await feedbackDocRef.set({
//         'doctorName': doctorName,
//       }, SetOptions(merge: true));
//
//       print('Adding feedback to collection ratings');
//       await feedbackDocRef.collection('ratings').add(feedbackData);
//
//       print('✅ Feedback successfully submitted');
//     } catch (e) {
//       print('❌ Error submitting feedback: $e');
//     }
//   }
//
// }

// import 'dart:convert';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_rating_bar/flutter_rating_bar.dart';
// import 'package:paw1/constant.dart';
//
// class AppointmentScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     String userEmail = FirebaseAuth.instance.currentUser?.email ?? '';
//
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: primaryColor,
//         title: const Text('My Appointments'),
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance
//             .collection('userAppointments')
//             .doc(userEmail)
//             .collection('appointments')
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return const Center(child: Text('No appointments found.'));
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
//               final petType = data['petType'] ?? 'Unknown';
//               final petAge = data['petAge'] ?? 'Unknown';
//               final appointmentDate = (data['appointmentDate'] as Timestamp).toDate();
//               final status = data['status'] ?? 'Pending';
//               final doctorEmail = data['drEmail'] ?? '';
//               final doctorName = data['drName'] ?? 'Unknown Doctor';
//               final imageBase64 = data['image'] ?? '';
//               final rescheduledDate = data['rescheduledDate'] != null
//                   ? (data['rescheduledDate'] as Timestamp).toDate()
//                   : null;
//
//               Color statusColor;
//               String statusText;
//
//               if (status == 'Approved') {
//                 statusColor = Colors.green;
//                 statusText = 'Approved';
//               } else if (status == 'Rejected') {
//                 statusColor = Colors.red;
//                 statusText = 'Rejected';
//               } else if (status == 'Canceled') {
//                 statusColor = Colors.red;
//                 statusText = 'Canceled';
//               } else if (status == 'Rescheduled') {
//                 statusColor = Colors.blue;
//                 statusText = 'Rescheduled';
//               } else {
//                 statusColor = Colors.orange;
//                 statusText = 'Pending';
//               }
//
//               return Card(
//                 margin: const EdgeInsets.all(10),
//                 elevation: 5,
//                 child: Padding(
//                   padding: const EdgeInsets.all(10.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         children: [
//                           CircleAvatar(
//                             radius: 30,
//                             backgroundImage: imageBase64.isNotEmpty
//                                 ? MemoryImage(base64Decode(imageBase64))
//                                 : null,
//                             child: imageBase64.isEmpty ? const Icon(Icons.pets) : null,
//                           ),
//                           const SizedBox(width: 10),
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(petName,
//                                     style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                                 Text('Type: $petType'),
//                                 Text('Age: $petAge'),
//                                 Text('Appointment Date: ${appointmentDate.day}/${appointmentDate.month}/${appointmentDate.year}'),
//                                 Text('Doctor: $doctorName'),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 10),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             'Status: $statusText',
//                             style: TextStyle(fontWeight: FontWeight.bold, color: statusColor),
//                           ),
//                           if (status == 'Approved')
//                             TextButton(
//                               onPressed: () {
//                                 _cancelAppointment(appointment.id, userEmail, doctorEmail);
//                               },
//                               child: const Text('Cancel', style: TextStyle(color: Colors.red)),
//                             ),
//                         ],
//                       ),
//                       if (status == 'Rescheduled' && rescheduledDate != null)
//                         Padding(
//                           padding: const EdgeInsets.only(top: 5.0),
//                           child: Text(
//                             'Rescheduled Date: ${rescheduledDate.day}/${rescheduledDate.month}/${rescheduledDate.year}',
//                             style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
//                           ),
//                         ),
//                       if (status == 'Approved')
//                         Align(
//                           alignment: Alignment.centerRight,
//                           child: TextButton(
//                             onPressed: () {
//                               _showRatingDialog(context, userEmail, doctorEmail);
//                             },
//                             child: const Text('Rate & Feedback', style: TextStyle(color: Colors.amber)),
//                           ),
//                         ),
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
//
//   void _cancelAppointment(String appointmentId, String userEmail, String doctorEmail) async {
//     final appointmentRef = FirebaseFirestore.instance
//         .collection('userAppointments')
//         .doc(userEmail)
//         .collection('appointments')
//         .doc(appointmentId);
//
//     await appointmentRef.update({
//       'status': 'Canceled',
//       'isCancelledByUser': true,
//     });
//
//     final vetRef = FirebaseFirestore.instance
//         .collection('todaysAppointments')
//         .doc(doctorEmail)
//         .collection('appointments')
//         .doc(appointmentId);
//
//     final vetSnapshot = await vetRef.get();
//     if (vetSnapshot.exists) {
//       await vetRef.delete();
//     }
//   }
//
//   void _showRatingDialog(BuildContext context, String userEmail, String doctorEmail) {
//     double rating = 3.0;
//     TextEditingController feedbackController = TextEditingController();
//
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text('Rate Your Experience'),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               const Text('Rate the veterinary service:'),
//               RatingBar.builder(
//                 initialRating: 3.0,
//                 minRating: 1,
//                 direction: Axis.horizontal,
//                 allowHalfRating: false,
//                 itemCount: 5,
//                 itemBuilder: (context, _) => const Icon(
//                   Icons.star,
//                   color: Colors.amber,
//                 ),
//                 onRatingUpdate: (value) {
//                   rating = value;
//                 },
//               ),
//               TextField(
//                 controller: feedbackController,
//                 decoration: const InputDecoration(labelText: 'Enter your feedback'),
//                 maxLines: 3,
//               ),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text('Cancel', style: TextStyle(color: Colors.red)),
//             ),
//             TextButton(
//               onPressed: () {
//                 _submitFeedback(userEmail, doctorEmail, rating, feedbackController.text);
//                 Navigator.pop(context);
//               },
//               child: const Text('Submit', style: TextStyle(color: Colors.green)),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   void _submitFeedback(String userEmail, String doctorEmail, double rating, String feedback) async {
//     FirebaseFirestore.instance.collection('veterinarianFeedback').add({
//       'userEmail': userEmail,
//       'doctorEmail': doctorEmail,
//       'rating': rating,
//       'feedback': feedback,
//       'timestamp': Timestamp.now(),
//     });
//   }
// }
//
//

import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:paw1/constant.dart';

class AppointmentScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Get current logged-in user's email
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
              final doctorEmail = data['drEmail'] ?? '';
              final doctorName = data['drName'] ?? 'Unknown Doctor';
              final imageBase64 = data['image'] ?? '';
              final rescheduledDate = data['rescheduledDate'] != null
                  ? (data['rescheduledDate'] as Timestamp).toDate()
                  : null;

              Color statusColor;
              String statusText;

              if (status == 'Approved') {
                statusColor = Colors.green;
                statusText = 'Approved';
              } else if (status == 'Rejected') {
                statusColor = Colors.red;
                statusText = 'Rejected';
              } else if (status == 'Canceled') {
                statusColor = Colors.red;
                statusText = 'Canceled';
              } else if (status == 'Rescheduled') {
                statusColor = Colors.blue;
                statusText = 'Rescheduled';
              } else {
                statusColor = Colors.orange;
                statusText = 'Pending';
              }

              return Card(
                margin: const EdgeInsets.all(10),
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundImage: imageBase64.isNotEmpty
                                ? MemoryImage(base64Decode(imageBase64))
                                : null,
                            child: imageBase64.isEmpty ? const Icon(Icons.pets) : null,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(petName,
                                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                Text('Type: $petType'),
                                Text('Age: $petAge'),
                                Text('Appointment Date: ${appointmentDate.day}/${appointmentDate.month}/${appointmentDate.year}'),
                                Text('Doctor: $doctorName'),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Status: $statusText',
                            style: TextStyle(fontWeight: FontWeight.bold, color: statusColor),
                          ),
                          if (status == 'Approved')
                            TextButton(
                              onPressed: () {
                                _cancelAppointment(appointment.id, userEmail, doctorEmail);
                              },
                              child: const Text('Cancel', style: TextStyle(color: Colors.red)),
                            ),
                        ],
                      ),
                      if (status == 'Rescheduled' && rescheduledDate != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: Text(
                            'Rescheduled Date: ${rescheduledDate.day}/${rescheduledDate.month}/${rescheduledDate.year}',
                            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                          ),
                        ),
                      if (status == 'Approved')
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              _showRatingDialog(context, userEmail, doctorEmail, doctorName);
                            },
                            child: const Text('Rate & Feedback', style: TextStyle(color: Colors.amber)),
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

  void _cancelAppointment(String appointmentId, String userEmail, String doctorEmail) async {
    final appointmentRef = FirebaseFirestore.instance
        .collection('userAppointments')
        .doc(userEmail)
        .collection('appointments')
        .doc(appointmentId);

    await appointmentRef.update({
      'status': 'Canceled',
      'isCancelledByUser': true,
    });

    final vetRef = FirebaseFirestore.instance
        .collection('todaysAppointments')
        .doc(doctorEmail)
        .collection('appointments')
        .doc(appointmentId);

    final vetSnapshot = await vetRef.get();
    if (vetSnapshot.exists) {
      await vetRef.delete();
    }
  }

  void _showRatingDialog(BuildContext context, String userEmail, String doctorEmail, String doctorName) {
    double rating = 3.0;
    TextEditingController feedbackController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Rate Your Experience'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Rate the veterinary service:'),
              RatingBar.builder(
                initialRating: 0.0,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: false,
                itemCount: 5,
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (value) {
                  rating = value;
                },
              ),
              TextField(
                controller: feedbackController,
                decoration: const InputDecoration(labelText: 'Enter your feedback'),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () {
                _submitFeedback(userEmail, doctorName, rating, feedbackController.text);
                Navigator.pop(context);
              },
              child: const Text('Submit', style: TextStyle(color: Colors.green)),
            ),
          ],
        );
      },
    );
  }

  Future<void> _submitFeedback(String userEmail, String doctorName, double rating, String feedback) async {
    try {
      await FirebaseFirestore.instance.collection('veterinarianFeedback').add({
        'userEmail': userEmail,
        //'doctorEmail': doctorEmail,
        'doctorName': doctorName,
        'rating': rating,
        'feedback': feedback,
        'timestamp': Timestamp.now(),
      });
      print('✅ Feedback submitted successfully');
    } catch (e) {
      print('❌ Failed to submit feedback: $e');
    }
  }
}

