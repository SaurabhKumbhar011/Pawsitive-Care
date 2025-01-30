// import 'dart:convert';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:paw1/constant.dart';
// import 'MedicalHistoryPage.dart'; // Import the medical history page
//
// class RegisteredPetsPage extends StatelessWidget {
//   final String vetEmail;
//
//   const RegisteredPetsPage({Key? key, required this.vetEmail}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         title: const Text(
//           "Registered Pet",
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//         backgroundColor: primaryColor,
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance
//             .collection('registeredPets')
//             .doc(vetEmail)
//             .collection('pets')
//             .snapshots(), // Use snapshots() for real-time updates
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           }
//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return const Center(child: Text('No pets registered.'));
//           }
//
//           final pets = snapshot.data!.docs.map((doc) {
//             final data = doc.data() as Map<String, dynamic>;
//             return {
//               'petName': data['petName'] ?? 'Unknown',
//               'petAge': data['petAge'] ?? 'Unknown',
//               'petType': data['petType'] ?? 'Unknown',
//               'ownerEmail': data['ownerEmail'] ?? 'Unknown',
//               'image': data['image'] ?? '', // Base64 encoded image string
//             };
//           }).toList();
//
//           return ListView.builder(
//             itemCount: pets.length,
//             itemBuilder: (context, index) {
//               final pet = pets[index];
//
//               return Card(
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 margin: const EdgeInsets.symmetric(vertical: 8),
//                 child: ListTile(
//                   leading: CircleAvatar(
//                     backgroundColor: Colors.grey[300],
//                     radius: 30,
//                     child: pet['image'].isNotEmpty
//                         ? ClipOval(
//                       child: Image.memory(
//                         base64Decode(pet['image']),
//                         fit: BoxFit.cover,
//                         width: 50,
//                         height: 50,
//                       ),
//                     )
//                         : const Icon(Icons.pets, size: 30, color: Colors.white),
//                   ),
//                   title: Text(pet['petName'], style: const TextStyle(fontWeight: FontWeight.bold)),
//                   subtitle: Text('${pet['petType']}, ${pet['petAge']}'),
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => MedicalHistoryPage(
//                           petName: pet['petName'],
//                           petType: pet['petType'],
//                           petAge: pet['petAge'],
//                           ownerEmail: pet['ownerEmail'],
//                           vetEmail: vetEmail,
//                         ),
//                       ),
//                     );
//                   },
//                   trailing: IconButton(
//                     icon: const Icon(Icons.delete),
//                     onPressed: () async {
//                       await FirebaseFirestore.instance
//                           .collection('registeredPets')
//                           .doc(vetEmail)
//                           .collection('pets')
//                           .doc(pet['petName'])
//                           .delete();
//
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(content: Text('Pet removed successfully.')),
//                       );
//                     },
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

import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:paw1/constant.dart';
import 'MedicalHistoryPage.dart'; // Import the medical history page

class RegisteredPetsPage extends StatelessWidget {
  final String vetEmail;

  const RegisteredPetsPage({Key? key, required this.vetEmail}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        centerTitle: true,
        title: const Text('Registered Pets'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('registeredPets')
            .doc(vetEmail)
            .collection('pets')
            .snapshots(), // Use snapshots() for real-time updates
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No pets registered.'));
          }

          final pets = snapshot.data!.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return {
              'petName': data['petName'] ?? 'Unknown',
              'petAge': data['petAge'] ?? 'Unknown',
              'petType': data['petType'] ?? 'Unknown',
              'ownerEmail': data['ownerEmail'] ?? 'Unknown',
              'image': data['image'] ?? '', // Base64 encoded image string
            };
          }).toList();

          return ListView.builder(
            itemCount: pets.length,
            itemBuilder: (context, index) {
              final pet = pets[index];

              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.grey[300],
                    radius: 30,
                    child: pet['image'].isNotEmpty
                        ? ClipOval(
                      child: Image.memory(
                        base64Decode(pet['image']),
                        fit: BoxFit.cover,
                        width: 50,
                        height: 50,
                      ),
                    )
                        : const Icon(Icons.pets, size: 30, color: Colors.white),
                  ),
                  title: Text(pet['petName'], style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${pet['petType']}, ${pet['petAge']}'),
                      Text('Owner: ${pet['ownerEmail']}', style: TextStyle(color: Colors.grey[600])),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MedicalHistoryPage(
                          petName: pet['petName'],
                          petType: pet['petType'],
                          petAge: pet['petAge'],
                          ownerEmail: pet['ownerEmail'],
                          vetEmail: vetEmail,
                        ),
                      ),
                    );
                  },
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () async {
                      await FirebaseFirestore.instance
                          .collection('registeredPets')
                          .doc(vetEmail)
                          .collection('pets')
                          .doc(pet['petName'])
                          .delete();

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Pet removed successfully.')),
                      );
                    },
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