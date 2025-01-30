import 'package:flutter/material.dart';
import 'package:paw1/constant.dart';

class MedicalRecordsScreen extends StatelessWidget {
  final String emailId;
  final String petName;

  // Constructor to receive emailId and petName
  const MedicalRecordsScreen({
    Key? key,
    required this.emailId,
    required this.petName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$petName Medical Records'),
        centerTitle: true,
        backgroundColor: primaryColor, // Customize this color
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display the pet's medical history details here
            Text(
              'Medical History for $petName:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),

            // Medical records list
            Expanded(
              child: ListView.builder(
                itemCount: 5, // Example number of records; replace with actual data
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text('Treatment ${index + 1}'),
                      subtitle: Text('Details about the treatment for $petName.'),
                      trailing: Icon(Icons.medical_services),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 16),

            // Button to add new medical record
            ElevatedButton(
              onPressed: () {
                // Handle adding new medical record here
                print('Add new record for $petName');
              },
              child: Text('Add New Record'),
            ),
          ],
        ),
      ),
    );
  }
}
