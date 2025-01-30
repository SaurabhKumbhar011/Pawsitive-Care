//
// import 'dart:convert';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:paw1/constant.dart';
//
// class AppointmentManagementPage extends StatelessWidget {
//   final String vetEmail;
//
//   AppointmentManagementPage({required this.vetEmail});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         title: const Text(
//           "Appointment Management",
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//         backgroundColor: primaryColor,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(12.0),
//         child: StreamBuilder<QuerySnapshot>(
//           stream: FirebaseFirestore.instance
//               .collection('appointments')
//               .doc(vetEmail)
//               .collection('requests')
//               .snapshots(),
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return const Center(child: CircularProgressIndicator());
//             }
//             if (snapshot.hasError) {
//               return Center(child: Text('Error: ${snapshot.error}'));
//             }
//             if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//               return const Center(child: Text('No appointments found.'));
//             }
//
//             final appointments = snapshot.data!.docs;
//
//             return ListView.builder(
//               itemCount: appointments.length,
//               itemBuilder: (context, index) {
//                 final appointment = appointments[index];
//                 final data = appointment.data() as Map<String, dynamic>;
//
//                 final String petName = data['petName'] ?? 'Unknown';
//                 final String ownerEmail = data['ownerEmail'] ?? 'Unknown';
//                 final Timestamp? timestamp = data['appointmentDate'];
//                 final DateTime appointmentDate =
//                 timestamp != null ? timestamp.toDate() : DateTime.now();
//
//                 return Card(
//                   margin: const EdgeInsets.symmetric(vertical: 8.0),
//                   elevation: 4.0,
//                   child: Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: Row(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         CircleAvatar(
//                           radius: 40,
//                           backgroundImage: data['image'] != null &&
//                               data['image'].isNotEmpty
//                               ? MemoryImage(base64Decode(data['image']))
//                               : null,
//                           backgroundColor: Colors.grey[300],
//                           child: (data['image'] == null ||
//                               data['image'].isEmpty)
//                               ? const Icon(
//                             Icons.pets,
//                             size: 40,
//                             color: Colors.white,
//                           )
//                               : null,
//                         ),
//                         const SizedBox(width: 16),
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 "$petName, ${data['petAge'] ?? 'N/A'}",
//                                 style: const TextStyle(
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                               Text(
//                                 data['petType'] ?? 'Unknown',
//                                 style: const TextStyle(
//                                   fontSize: 16,
//                                   color: Colors.grey,
//                                 ),
//                               ),
//                               const SizedBox(height: 8),
//                               Text(
//                                 "Date: ${appointmentDate.day}/${appointmentDate.month}/${appointmentDate.year}",
//                                 style: const TextStyle(
//                                   fontSize: 14,
//                                   color: Colors.black87,
//                                 ),
//                               ),
//                               const SizedBox(height: 8),
//                               Text(
//                                 ownerEmail,
//                                 style: const TextStyle(
//                                   fontSize: 14,
//                                   color: Colors.black54,
//                                 ),
//                               ),
//                               const SizedBox(height: 16),
//                               Row(
//                                 children: [
//                                   Expanded(
//                                     child: ElevatedButton.icon(
//                                       icon: const Icon(Icons.check),
//                                       label: const Text("Approve"),
//                                       style: ElevatedButton.styleFrom(
//                                         backgroundColor: Colors.green,
//                                         padding: const EdgeInsets.symmetric(
//                                             vertical: 12),
//                                         shape: RoundedRectangleBorder(
//                                           borderRadius:
//                                           BorderRadius.circular(8.0),
//                                         ),
//                                       ),
//                                       onPressed: () {
//                                         _showConfirmationDialog(
//                                           context,
//                                           "Approve Appointment",
//                                           "Are you sure you want to approve this appointment?",
//                                               () => _approveAppointment(
//                                               vetEmail, data, context),
//                                         );
//                                       },
//                                     ),
//                                   ),
//                                   const SizedBox(width: 8),
//                                   Expanded(
//                                     child: ElevatedButton.icon(
//                                       icon: const Icon(Icons.cancel_outlined),
//                                       label: const Text("Reject"),
//                                       style: ElevatedButton.styleFrom(
//                                         backgroundColor: Colors.red,
//                                         padding: const EdgeInsets.symmetric(
//                                             vertical: 12),
//                                         shape: RoundedRectangleBorder(
//                                           borderRadius:
//                                           BorderRadius.circular(8.0),
//                                         ),
//                                       ),
//                                       onPressed: () {
//                                         _showConfirmationDialog(
//                                           context,
//                                           "Reject Appointment",
//                                           "Are you sure you want to reject this appointment?",
//                                               () => _rejectAppointment(
//                                               vetEmail, data, context),
//                                         );
//                                       },
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             );
//           },
//         ),
//       ),
//     );
//   }
//
//   void _showConfirmationDialog(BuildContext context, String title,
//       String content, VoidCallback onConfirm) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text(title),
//         content: Text(content),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(),
//             child: const Text("Cancel"),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               Navigator.of(context).pop();
//               onConfirm();
//             },
//             child: const Text("Confirm"),
//           ),
//         ],
//       ),
//     );
//   }
//
//
//   void _approveAppointment(String vetEmail, Map<String, dynamic> data,
//       BuildContext context) async {
//     try {
//       final ownerEmail = data['ownerEmail'];
//       final petName = data['petName'];
//       final appointmentDate = (data['appointmentDate'] as Timestamp).toDate();
//       final now = DateTime.now();
//
//       // Check if pet exists in registeredPets collection
//       final registeredPetsSnapshot = await FirebaseFirestore.instance
//           .collection('registeredPets')
//           .doc(vetEmail)
//           .collection('pets')
//           .where('petName', isEqualTo: petName)
//           .where('ownerEmail', isEqualTo: ownerEmail)
//           .get();
//
//       if (registeredPetsSnapshot.docs.isEmpty) {
//         // Add new pet to registeredPets
//         await FirebaseFirestore.instance
//             .collection('registeredPets')
//             .doc(vetEmail)
//             .collection('pets')
//             .doc(petName) // Using petName as the document ID
//             .set({
//           'petName': petName,
//           'ownerEmail': ownerEmail,
//           'petType': data['petType'],
//           'petAge': data['petAge'],
//           'image': data['image'],
//         });
//       }
//
//       // Compare dates without time
//       DateTime appointmentDay = DateTime(
//           appointmentDate.year, appointmentDate.month, appointmentDate.day);
//       DateTime today = DateTime(now.year, now.month, now.day);
//
//       String collection =
//       appointmentDay == today ? 'todaysAppointments' : 'upcomingAppointments';
//
//       // Add to the appropriate appointments collection
//       await FirebaseFirestore.instance
//           .collection(collection)
//           .doc(vetEmail)
//           .collection('appointments')
//           .doc('${petName}_${appointmentDate.millisecondsSinceEpoch}')
//           .set(data);
//
//       // Update user appointment status to approved
//       await FirebaseFirestore.instance
//           .collection('userAppointments')
//           .doc(ownerEmail)
//           .collection('appointments')
//           .doc('${petName}_${appointmentDate.millisecondsSinceEpoch}')
//           .update({'status': 'Approved'});
//
//       // Remove the request from appointments management
//       await FirebaseFirestore.instance
//           .collection('appointments')
//           .doc(vetEmail)
//           .collection('requests')
//           .doc('${petName}_${appointmentDate.millisecondsSinceEpoch}')
//           .delete();
//
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Appointment approved successfully.')),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error approving appointment: $e')),
//       );
//     }
//   }
//
//
//
//   void _rejectAppointment(String vetEmail, Map<String, dynamic> data,
//       BuildContext context) async {
//     try {
//       final ownerEmail = data['ownerEmail'];
//       final petName = data['petName'];
//       final appointmentDate = (data['appointmentDate'] as Timestamp).toDate();
//
//       // Remove from requests immediately
//       await FirebaseFirestore.instance
//           .collection('appointments')
//           .doc(vetEmail)
//           .collection('requests')
//           .doc('${petName}_${appointmentDate.millisecondsSinceEpoch}')
//           .delete();
//
//       // Update user appointment status asynchronously
//       FirebaseFirestore.instance
//           .collection('userAppointments')
//           .doc(ownerEmail)
//           .collection('appointments')
//           .doc('${petName}_${appointmentDate.millisecondsSinceEpoch}')
//           .update({'status': 'Rejected'}).catchError((e) {
//         // Handle cases where updating the userAppointment fails
//         debugPrint('Failed to update user appointment status: $e');
//       });
//
//       // Show success message
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//             content: Text('Appointment rejected and deleted successfully.')),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error rejecting appointment: $e')),
//       );
//     }
//   }
// }

import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:paw1/constant.dart';

class AppointmentManagementPage extends StatelessWidget {
  final String vetEmail;

  AppointmentManagementPage({required this.vetEmail});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Appointment Management",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('appointments')
              .doc(vetEmail)
              .collection('requests')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
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

                final String petName = data['petName'] ?? 'Unknown';
                final String ownerEmail = data['ownerEmail'] ?? 'Unknown';
                final Timestamp? timestamp = data['appointmentDate'];
                final DateTime appointmentDate =
                timestamp != null ? timestamp.toDate() : DateTime.now();

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  elevation: 4.0,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundImage: data['image'] != null &&
                              data['image'].isNotEmpty
                              ? MemoryImage(base64Decode(data['image']))
                              : null,
                          backgroundColor: Colors.grey[300],
                          child: (data['image'] == null ||
                              data['image'].isEmpty)
                              ? const Icon(
                            Icons.pets,
                            size: 40,
                            color: Colors.white,
                          )
                              : null,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "$petName, ${data['petAge'] ?? 'N/A'}",
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                data['petType'] ?? 'Unknown',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Date: ${appointmentDate.day}/${appointmentDate.month}/${appointmentDate.year}",
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                ownerEmail,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black54,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      icon: const Icon(Icons.check),
                                      label: const Text("Approve"),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 12),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(8.0),
                                        ),
                                      ),
                                      onPressed: () {
                                        _showConfirmationDialog(
                                          context,
                                          "Approve Appointment",
                                          "Are you sure you want to approve this appointment?",
                                              () => _approveAppointment(
                                              vetEmail, data, context),
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      icon: const Icon(Icons.cancel_outlined),
                                      label: const Text("Reject"),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 12),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(8.0),
                                        ),
                                      ),
                                      onPressed: () {
                                        _showConfirmationDialog(
                                          context,
                                          "Reject Appointment",
                                          "Are you sure you want to reject this appointment?",
                                              () => _rejectAppointment(
                                              vetEmail, data, context),
                                        );
                                      },
                                    ),
                                  ),
                                ],
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
      ),
    );
  }

  void _showConfirmationDialog(BuildContext context, String title,
      String content, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              onConfirm();
            },
            child: const Text("Confirm"),
          ),
        ],
      ),
    );
  }

  void _rejectAppointment(
      String vetEmail, Map<String, dynamic> data, BuildContext context) async {
    try {
      final String ownerEmail = data['ownerEmail'] ?? '';
      final String petName = data['petName'] ?? '';
      final Timestamp? timestamp = data['appointmentDate'];

      if (timestamp == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error: Appointment date is missing.')),
        );
        return;
      }

      final DateTime appointmentDate = timestamp.toDate();
      final String documentId = '${petName}_${appointmentDate.millisecondsSinceEpoch}';

      // Remove from the 'requests' collection
      await FirebaseFirestore.instance
          .collection('appointments')
          .doc(vetEmail)
          .collection('requests')
          .doc(documentId)
          .delete();

      // Update user appointment status asynchronously
      await FirebaseFirestore.instance
          .collection('userAppointments')
          .doc(ownerEmail)
          .collection('appointments')
          .doc(documentId)
          .update({'status': 'Rejected'});

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Appointment rejected and deleted successfully.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error rejecting appointment: $e')),
      );
    }
  }

  void _approveAppointment(String vetEmail, Map<String, dynamic> data,
      BuildContext context) async {
    try {
      final ownerEmail = data['ownerEmail'];
      final petName = data['petName'];
      final appointmentDate = (data['appointmentDate'] as Timestamp).toDate();
      final now = DateTime.now();

      // Check if pet exists in registeredPets collection
      final registeredPetsSnapshot = await FirebaseFirestore.instance
          .collection('registeredPets')
          .doc(vetEmail)
          .collection('pets')
          .where('petName', isEqualTo: petName)
          .where('ownerEmail', isEqualTo: ownerEmail)
          .get();

      if (registeredPetsSnapshot.docs.isEmpty) {
        // Add new pet to registeredPets
        await FirebaseFirestore.instance
            .collection('registeredPets')
            .doc(vetEmail)
            .collection('pets')
            .doc(petName) // Using petName as the document ID
            .set({
          'petName': petName,
          'ownerEmail': ownerEmail,
          'petType': data['petType'],
          'petAge': data['petAge'],
          'image': data['image'],
        });
      }

      // Compare dates without time
      DateTime appointmentDay = DateTime(
          appointmentDate.year, appointmentDate.month, appointmentDate.day);
      DateTime today = DateTime(now.year, now.month, now.day);

      String collection =
      appointmentDay == today ? 'todaysAppointments' : 'upcomingAppointments';

      // Add to the appropriate appointments collection
      await FirebaseFirestore.instance
          .collection(collection)
          .doc(vetEmail)
          .collection('appointments')
          .doc('${petName}_${appointmentDate.millisecondsSinceEpoch}')
          .set(data);

      // Update user appointment status to approved
      await FirebaseFirestore.instance
          .collection('userAppointments')
          .doc(ownerEmail)
          .collection('appointments')
          .doc('${petName}_${appointmentDate.millisecondsSinceEpoch}')
          .update({'status': 'Approved'});

      // Remove the request from appointments management
      await FirebaseFirestore.instance
          .collection('appointments')
          .doc(vetEmail)
          .collection('requests')
          .doc('${petName}_${appointmentDate.millisecondsSinceEpoch}')
          .delete();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Appointment approved successfully.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error approving appointment: $e')),
      );
    }
  }
}
