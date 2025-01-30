import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../constant.dart';

class VeterinarianDetailsPage extends StatelessWidget {
  final String vetId; // Firestore document ID of the veterinarian

   VeterinarianDetailsPage({Key? key, required this.vetId})
      : super(key: key);

  // Function to check if slot is available
  Future<bool> _checkSlotAvailability() async {
    try {
      // Fetching the veterinarian's document from Firestore
      DocumentSnapshot vetDoc = await FirebaseFirestore.instance
          .collection('veterinarians')
          .doc(vetId) // Vet ID as the document ID
          .get();

      if (vetDoc.exists) {
        // Retrieve slot availability from Firestore
        return vetDoc['isSlotAvailable'] ??
            false; // Assuming isSlotAvailable field is used
      }
    } catch (e) {
      print("Error checking availability: $e");
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title:  Text('Veterinarian Details'),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('veterinarians').doc(
            vetId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return  Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return  Center(child: Text('Veterinarian not found'));
          }

          final vetData = snapshot.data!.data() as Map<String, dynamic>;

          // Extracting the required fields
          final String fullname = vetData['fullName'] ?? 'Unknown';
          final String phoneNo = vetData['phone'] ?? 'Not Available';
          final String email = vetData['email'] ?? 'Not Available';
          final String address = vetData['address'] ?? 'Not Available';
          final String workingHours = vetData['workingHours'] ??
              'Not Available';
          final String hospitalName = vetData['hospitalName'] ??
              'Not Available';

          return Column(
            children: [
              Padding(
                padding:  EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fullname,
                      style:  TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                     SizedBox(height: 10),
                    Text(
                      'Phone: $phoneNo',
                      style:  TextStyle(fontSize: 16),
                    ),
                     SizedBox(height: 10),
                    Text(
                      'Email: $email',
                      style:  TextStyle(fontSize: 16),
                    ),
                     SizedBox(height: 10),
                    Text(
                      'Address: $address',
                      style:  TextStyle(fontSize: 16),
                    ),
                     SizedBox(height: 10),
                    Text(
                      'Working Hours: $workingHours',
                      style:  TextStyle(fontSize: 16),
                    ),
                     SizedBox(height: 10),
                    Text(
                      'Hospital: $hospitalName',
                      style:  TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
              // Book Appointment Button
              Container(
                child: Padding(
                  padding:  EdgeInsets.only(left: 10.0, top: 300),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding:  EdgeInsets.symmetric(
                          vertical: 20, horizontal: 20),
                      textStyle:  TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                      backgroundColor: primaryColor, // Button color
                      foregroundColor: Colors.white, // Text color
                    ),
                    onPressed: () async {
                      bool slotAvailable = await _checkSlotAvailability();
                      if (!slotAvailable) {
                        ScaffoldMessenger.of(context).showSnackBar(
                           SnackBar(content: Text(
                              'No slots available! Please try again later.')),
                        );
                      } else {
                        _showPetSelectionDialog(context, vetId, fullname);
                      }
                    },
                    child:  Text('Book Appointment'),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showPetSelectionDialog(BuildContext context, String vetId,
      String vetName) async {
    String ownerEmail = FirebaseAuth.instance.currentUser?.email ??
        'No email found';
    List<String> selectedPetIds = [];
    DateTime? selectedDate;

    // Fetch pets from Firestore
    final petsSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(ownerEmail)
        .collection('pets')
        .get();

    if (petsSnapshot.docs.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(content: Text('No pets found!')),
      );
      return;
    }

    // Prepare a list of pets
    final pets = petsSnapshot.docs.map((doc) {
      final data = doc.data();
      return {
        'id': doc.id,
        'name': data['name'] ?? 'Unknown',
        'type': data['type'] ?? 'Unknown',
        'age': data['age'] ?? 'Unknown',
        'image': data['image'] ?? '',
      };
    }).toList();

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15)),
          child: Container(
            height: 450,
            padding:  EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 Text(
                  'Select a Pet',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                 SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: pets.length,
                    itemBuilder: (context, index) {
                      final pet = pets[index];
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        margin:  EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          leading: Checkbox(
                            value: selectedPetIds.contains(pet['id']),
                            onChanged: (bool? isSelected) {
                              if (isSelected == true) {
                                selectedPetIds.add(pet['id']);
                              } else {
                                selectedPetIds.remove(pet['id']);
                              }
                              (context as Element)
                                  .markNeedsBuild(); // Rebuild dialog
                            },
                          ),
                          title: Text(
                            pet['name'],
                            style:  TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text('${pet['type']} (Age: ${pet['age']})'),
                          trailing: pet['image'].isNotEmpty
                              ? CircleAvatar(
                            backgroundImage: MemoryImage(
                                base64Decode(pet['image'])),
                            radius: 25,
                          )
                              :  Icon(Icons.pets, size: 30),
                        ),
                      );
                    },
                  ),
                ),
                 SizedBox(height: 10),
                Row(
                  children: [
                     Text(
                      'Select Date: ',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    TextButton(
                      onPressed: () async {
                        selectedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(
                               Duration(days: 365)),
                        );
                        (context as Element)
                            .markNeedsBuild(); // Rebuild dialog to show date
                      },
                      child: Text(
                        selectedDate == null
                            ? 'Pick a date'
                            : '${selectedDate!.day}/${selectedDate!
                            .month}/${selectedDate!.year}',
                        style:  TextStyle(
                            fontSize: 16, color: primaryColor),
                      ),
                    ),
                  ],
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      if (selectedPetIds.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                           SnackBar(content: Text(
                              'Please select at least one pet!')),
                        );
                        return;
                      }

                      if (selectedDate == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                           SnackBar(content: Text(
                              'Please select a date!')),
                        );
                        return;
                      }

                      for (String petId in selectedPetIds) {
                        final selectedPet = pets.firstWhere((
                            pet) => pet['id'] == petId);
                        final petName = selectedPet['name'];

                        // Check for duplicate appointment
                        final existingAppointmentsSnapshot = await FirebaseFirestore
                            .instance
                            .collection('appointments')
                            .doc(vetId)
                            .collection('requests')
                            .where('ownerEmail', isEqualTo: ownerEmail)
                            .where('petName', isEqualTo: petName)
                            .where('appointmentDate',
                            isEqualTo: Timestamp.fromDate(selectedDate!))
                            .get();

                        if (existingAppointmentsSnapshot.docs.isNotEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(
                                'Appointment for $petName on this date already exists!')),
                          );
                          continue;
                        }

                        // Save to veterinarian's appointments
                        await FirebaseFirestore.instance
                            .collection('appointments')
                            .doc(vetId)
                            .collection('requests')
                            .doc('${petName}_${selectedDate!
                            .millisecondsSinceEpoch}')
                            .set({
                          'petName': petName,
                          'petType': selectedPet['type'],
                          'petAge': selectedPet['age'],
                          'ownerEmail': ownerEmail,
                          'drName': vetName, // Veterinarian's name
                          'approved': 0,
                          'appointmentDate': Timestamp.fromDate(selectedDate!),
                          // 'timestamp': Timestamp.now(),
                          'image': selectedPet['image'],
                        });

                        // Save to user's appointments
                        await FirebaseFirestore.instance
                            .collection('userAppointments')
                            .doc(ownerEmail)
                            .collection('appointments')
                            .doc('${petName}_${selectedDate!
                            .millisecondsSinceEpoch}')
                            .set({
                          'petName': petName,
                          'petType': selectedPet['type'],
                          'petAge': selectedPet['age'],
                          'vetEmail': vetId,
                          'drName': vetName, // Veterinarian's name
                          'appointmentDate': Timestamp.fromDate(selectedDate!),
                          'status': 'Pending', // Initial status
                          //'timestamp': Timestamp.now(),
                          'image': selectedPet['image'],
                        });
                      }

                      Navigator.pop(context); // Close dialog
                      ScaffoldMessenger.of(context).showSnackBar(
                         SnackBar(content: Text(
                            'Appointment Requests Sent')),
                      );
                    },
                    child:
                    Text('Submit'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: primaryColor, // Use primaryColor for button
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}