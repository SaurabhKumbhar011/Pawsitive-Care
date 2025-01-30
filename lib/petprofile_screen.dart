// // import 'dart:convert'; // For Base64 encoding
// // import 'dart:io'; // For File handling
// // import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore package
// // import 'package:flutter/material.dart';
// // import 'package:image_picker/image_picker.dart';
// // import 'package:path/path.dart';
// // import 'package:paw1/constant.dart'; // For getting file names
// //
// // class PetProfileScreen extends StatefulWidget {
// //   final String emailId; // Pass the user email to the screen
// //
// //   const PetProfileScreen({Key? key, required this.emailId}) : super(key: key);
// //
// //   @override
// //   _PetProfileScreenState createState() => _PetProfileScreenState();
// // }
// //
// // class _PetProfileScreenState extends State<PetProfileScreen> {
// //   final TextEditingController _nameController = TextEditingController();
// //   final TextEditingController _ageController = TextEditingController();
// //   final TextEditingController _typeController = TextEditingController();
// //
// //   XFile? _imageFile;
// //   final ImagePicker _picker = ImagePicker();
// //
// //   String? _fileName; // To store and display the file name
// //
// //   Future<void> _pickImage() async {
// //     final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
// //     if (pickedFile != null) {
// //       setState(() {
// //         _imageFile = pickedFile;
// //         _fileName = basename(_imageFile!.path); // Extract the file name
// //       });
// //     }
// //   }
// //
// //   Future<void> _savePetData() async {
// //     final String petName = _nameController.text.trim();
// //     final String petAge = _ageController.text.trim();
// //     final String petType = _typeController.text.trim();
// //
// //     if (petName.isEmpty || petAge.isEmpty || petType.isEmpty || _imageFile == null) {
// //       // ScaffoldMessenger.of(context).showSnackBar(
// //       //   SnackBar(content: Text('Please fill all fields and upload an image')),
// //       // );
// //       return;
// //     }
// //
// //     try {
// //       // Convert the image to Base64
// //       final File imageFile = File(_imageFile!.path);
// //       final List<int> imageBytes = await imageFile.readAsBytes();
// //       final String base64Image = base64Encode(imageBytes);
// //
// //       // Save to Firestore
// //       await FirebaseFirestore.instance
// //           .collection('users') // Top-level collection (users)
// //           .doc(widget.emailId) // User document (using email as document ID)
// //           .collection('pets') // Sub-collection (pets)
// //           .doc(petName) // Document ID (pet name)
// //           .set({
// //         'name': petName,
// //         'age': petAge,
// //         'type': petType,
// //         'image': base64Image, // Base64 image data
// //         'fileName': _fileName, // File name
// //       });
// //
// //       // ScaffoldMessenger.of(context).showSnackBar(
// //       //   SnackBar(content: Text('Pet added successfully')),
// //       // );
// //
// //       // Clear the fields after saving
// //       _nameController.clear();
// //       _ageController.clear();
// //       _typeController.clear();
// //       setState(() {
// //         _imageFile = null;
// //         _fileName = null; // Clear the file name
// //       });
// //     } catch (e) {
// //       // ScaffoldMessenger.of(context).showSnackBar(
// //       //   SnackBar(content: Text('Error saving pet: $e')),
// //       // );
// //     }
// //   }
// //
// //   Widget _buildPetList() {
// //     return StreamBuilder<QuerySnapshot>(
// //       stream: FirebaseFirestore.instance
// //           .collection('users')
// //           .doc(widget.emailId)
// //           .collection('pets')
// //           .snapshots(),
// //       builder: (context, snapshot) {
// //         if (snapshot.connectionState == ConnectionState.waiting) {
// //           return CircularProgressIndicator();
// //         }
// //         if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
// //           return Text('No pets added yet.');
// //         }
// //
// //         final pets = snapshot.data!.docs;
// //
// //         return ListView.separated(
// //           shrinkWrap: true,
// //           itemCount: pets.length,
// //           separatorBuilder: (context, index) => Divider(), // Divider between items
// //           itemBuilder: (context, index) {
// //             final pet = pets[index].data() as Map<String, dynamic>;
// //             final petName = pet['name'] ?? '';
// //             final base64Image = pet['image'] ?? '';
// //
// //             return ListTile(
// //               leading: CircleAvatar(
// //                 backgroundImage: base64Image.isNotEmpty
// //                     ? MemoryImage(base64Decode(base64Image))
// //                     : null,
// //                 child: base64Image.isEmpty ? Icon(Icons.pets) : null,
// //               ),
// //               title: Text(petName),
// //               subtitle: Text('Type: ${pet['type'] ?? 'N/A'}'),
// //             );
// //           },
// //         );
// //       },
// //     );
// //   }
// //
// //   @override
// //   void dispose() {
// //     _nameController.dispose();
// //     _ageController.dispose();
// //     _typeController.dispose();
// //     super.dispose();
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         centerTitle: true,
// //         backgroundColor: primaryColor, // Replace with your primary color
// //         title: Text(
// //           'Pet Profiles',
// //           style: TextStyle(fontWeight: FontWeight.bold),
// //         ),
// //       ),
// //       body: Padding(
// //         padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
// //         child: Column(
// //           children: [
// //             TextField(
// //               controller: _nameController,
// //               decoration: InputDecoration(
// //                 labelText: 'Pet Name',
// //                 border: OutlineInputBorder(
// //                   borderRadius: BorderRadius.circular(10),
// //                 ),
// //               ),
// //             ),
// //             SizedBox(height: 10),
// //             TextField(
// //               controller: _ageController,
// //               decoration: InputDecoration(
// //                 labelText: 'Pet Age',
// //                 border: OutlineInputBorder(
// //                   borderRadius: BorderRadius.circular(10),
// //                 ),
// //               ),
// //             ),
// //             SizedBox(height: 10),
// //             TextField(
// //               controller: _typeController,
// //               decoration: InputDecoration(
// //                 labelText: 'Pet Type',
// //                 border: OutlineInputBorder(
// //                   borderRadius: BorderRadius.circular(10),
// //                 ),
// //               ),
// //             ),
// //             SizedBox(height: 10),
// //             GestureDetector(
// //               onTap: _pickImage,
// //               child: Container(
// //                 height: 55,
// //                 width: 358,
// //                 decoration: BoxDecoration(
// //                   borderRadius: BorderRadius.circular(10),
// //                   border: Border.all(color: Colors.black),
// //                 ),
// //                 child: Row(
// //                   mainAxisAlignment: MainAxisAlignment.center,
// //                   children: [
// //                     _fileName == null
// //                         ? Row(
// //                       children: [
// //                         Text(
// //                           'Upload Image',
// //                           style: TextStyle(
// //                             color: Colors.black,
// //                             fontSize: 16,
// //                             fontWeight: FontWeight.w500,
// //                           ),
// //                         ),
// //                         SizedBox(width: 10),
// //                         Icon(Icons.upload, color: Colors.black),
// //                       ],
// //                     )
// //                         : Text(
// //                       _fileName!, // Display the file name only after selection
// //                       style: TextStyle(
// //                         color: Colors.black,
// //                         fontSize: 14,
// //                         fontWeight: FontWeight.w500,
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //             ),
// //             SizedBox(height: 16),
// //             ElevatedButton(
// //               onPressed: _savePetData,
// //               child: Text('Add Pet'),
// //             ),
// //             SizedBox(height: 20),
// //             Expanded(
// //               child: Container(
// //                 decoration: BoxDecoration(
// //                   border: Border.all(color: Colors.white),
// //                   borderRadius: BorderRadius.circular(10),
// //                 ),
// //                 child: _buildPetList(),
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
// //
//
//
// import 'dart:convert'; // For Base64 encoding
// import 'dart:io'; // For File handling
// import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore package
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:path/path.dart';
// import 'package:paw1/constant.dart';
//
// import 'MedicalRecordsScreen.dart'; // For getting file names
//
// class PetProfileScreen extends StatefulWidget {
//   final String emailId; // Pass the user email to the screen
//
//   const PetProfileScreen({Key? key, required this.emailId}) : super(key: key);
//
//   @override
//   _PetProfileScreenState createState() => _PetProfileScreenState();
// }
//
// class _PetProfileScreenState extends State<PetProfileScreen> {
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _ageController = TextEditingController();
//   final TextEditingController _typeController = TextEditingController();
//
//   XFile? _imageFile;
//   final ImagePicker _picker = ImagePicker();
//
//   String? _fileName; // To store and display the file name
//
//   // Pick an image from gallery
//   Future<void> _pickImage() async {
//     final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       setState(() {
//         _imageFile = pickedFile;
//         _fileName = basename(_imageFile!.path); // Extract the file name
//       });
//     }
//   }
//
//   // Save pet data to Firestore
//   Future<void> _savePetData() async {
//     final String petName = _nameController.text.trim();
//     final String petAge = _ageController.text.trim();
//     final String petType = _typeController.text.trim();
//
//     if (petName.isEmpty || petAge.isEmpty || petType.isEmpty || _imageFile == null) {
//       return;
//     }
//
//     try {
//       // Convert the image to Base64
//       final File imageFile = File(_imageFile!.path);
//       final List<int> imageBytes = await imageFile.readAsBytes();
//       final String base64Image = base64Encode(imageBytes);
//
//       // Save to Firestore
//       await FirebaseFirestore.instance
//           .collection('users') // Top-level collection (users)
//           .doc(widget.emailId) // User document (using email as document ID)
//           .collection('pets') // Sub-collection (pets)
//           .doc(petName) // Document ID (pet name)
//           .set({
//         'name': petName,
//         'age': petAge,
//         'type': petType,
//         'image': base64Image, // Base64 image data
//         'fileName': _fileName, // File name
//       });
//
//       // Clear the fields after saving
//       _nameController.clear();
//       _ageController.clear();
//       _typeController.clear();
//       setState(() {
//         _imageFile = null;
//         _fileName = null; // Clear the file name
//       });
//     } catch (e) {
//       // Handle error if needed
//     }
//   }
//
//   // Display list of pets
//   // Widget _buildPetList() {
//   //   return StreamBuilder<QuerySnapshot>(
//   //     stream: FirebaseFirestore.instance
//   //         .collection('users')
//   //         .doc(widget.emailId)
//   //         .collection('pets')
//   //         .snapshots(),
//   //     builder: (BuildContext context, snapshot) {
//   //       if (snapshot.connectionState == ConnectionState.waiting) {
//   //         return CircularProgressIndicator();
//   //       }
//   //       if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//   //         return Text('No pets added yet.');
//   //       }
//   //
//   //       final pets = snapshot.data!.docs;
//   //
//   //       return ListView.separated(
//   //         shrinkWrap: true,
//   //         itemCount: pets.length,
//   //         separatorBuilder: (context, index) => Divider(),
//   //         itemBuilder: (BuildContext context, index) {
//   //           final pet = pets[index].data() as Map<String, dynamic>;
//   //           final petName = pet['name'] ?? '';
//   //           final base64Image = pet['image'] ?? '';
//   //
//   //           return ListTile(
//   //             leading: CircleAvatar(
//   //               backgroundImage: base64Image.isNotEmpty
//   //                   ? MemoryImage(base64Decode(base64Image))
//   //                   : null,
//   //               child: base64Image.isEmpty ? Icon(Icons.pets) : null,
//   //             ),
//   //             title: Text(petName),
//   //             subtitle: Text('Type: ${pet['type'] ?? 'N/A'}'),
//   //             onTap: () {
//   //               // Navigate to the medical records screen for the pet
//   //               Navigator.push(
//   //                 context, // Correctly passing BuildContext here
//   //                 MaterialPageRoute(
//   //                   builder: (BuildContext context) => MedicalRecordsScreen(
//   //                     emailId: widget.emailId,
//   //                     petName: petName,
//   //                   ),
//   //                 ),
//   //               );
//   //             },
//   //           );
//   //         },
//   //       );
//   //     },
//   //   );
//   // }
//
//   Widget _buildPetList() {
//     return StreamBuilder<QuerySnapshot>(
//       stream: FirebaseFirestore.instance
//           .collection('users')
//           .doc(widget.emailId)
//           .collection('pets')
//           .snapshots(),
//       builder: (BuildContext context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return CircularProgressIndicator();
//         }
//         if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//           return Text('No pets added yet.');
//         }
//
//         final pets = snapshot.data!.docs;
//
//         return ListView.separated(
//           shrinkWrap: true,
//           itemCount: pets.length,
//           separatorBuilder: (context, index) => Divider(),
//           itemBuilder: (BuildContext context, index) {
//             final pet = pets[index].data() as Map<String, dynamic>;
//             final petName = pet['name'] ?? '';
//             final petId = pets[index].id; // Get pet document ID for delete/edit operations
//             final base64Image = pet['image'] ?? '';
//
//             return ListTile(
//               leading: CircleAvatar(
//                 backgroundImage: base64Image.isNotEmpty
//                     ? MemoryImage(base64Decode(base64Image))
//                     : null,
//                 child: base64Image.isEmpty ? Icon(Icons.pets) : null,
//               ),
//               title: Text(petName),
//               subtitle: Text('Type: ${pet['type'] ?? 'N/A'}'),
//               onTap: () {
//                 // Navigate to the medical records screen for the pet
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (BuildContext context) => MedicalRecordsScreen(
//                       emailId: widget.emailId,
//                       petName: petName,
//                     ),
//                   ),
//                 );
//               },
//               trailing: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   // Edit Button
//                   IconButton(
//                     icon: Icon(Icons.edit, color: Colors.blue),
//                     onPressed: () {
//                       // Handle editing the pet details
//                       _editPet(petId, petName, pet['age'], pet['type']);
//                     },
//                   ),
//                   // Delete Button
//                   IconButton(
//                     icon: Icon(Icons.delete, color: Colors.red),
//                     onPressed: () {
//                       // Handle deleting the pet
//                       _deletePet(petId);
//                     },
//                   ),
//                 ],
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
//
// // Function to handle editing pet details
//   void _editPet(String petId, String petName, String petAge, String petType) {
//     // You can navigate to a new screen or show a dialog to edit the pet's details.
//     print("Edit Pet: $petName");
//     // Example: You could navigate to an edit screen passing the pet details
//     // Navigator.push(context, MaterialPageRoute(builder: (context) => EditPetScreen(petId: petId, petName: petName, petAge: petAge, petType: petType)));
//   }
//
// // Function to handle deleting a pet
//   void _deletePet(String petId) async {
//     try {
//       await FirebaseFirestore.instance
//           .collection('users')
//           .doc(widget.emailId)
//           .collection('pets')
//           .doc(petId)
//           .delete();
//       // Optionally show a success message
//       // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Pet deleted successfully')));
//     } catch (e) {
//       // Handle error during deletion
//       // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error deleting pet: $e')));
//     }
//   }
//
//
//   @override
//   void dispose() {
//     _nameController.dispose();
//     _ageController.dispose();
//     _typeController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         backgroundColor: primaryColor, // Replace with your primary color
//         title: Text(
//           'Pet Profiles',
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//       ),
//       body: Padding(
//         padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
//         child: Column(
//           children: [
//             TextField(
//               controller: _nameController,
//               decoration: InputDecoration(
//                 labelText: 'Pet Name',
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//               ),
//             ),
//             SizedBox(height: 10),
//             TextField(
//               controller: _ageController,
//               decoration: InputDecoration(
//                 labelText: 'Pet Age',
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//               ),
//             ),
//             SizedBox(height: 10),
//             TextField(
//               controller: _typeController,
//               decoration: InputDecoration(
//                 labelText: 'Pet Type',
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//               ),
//             ),
//             SizedBox(height: 10),
//             GestureDetector(
//               onTap: _pickImage,
//               child: Container(
//                 height: 55,
//                 width: 358,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(10),
//                   border: Border.all(color: Colors.black),
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     _fileName == null
//                         ? Row(
//                       children: [
//                         Text(
//                           'Upload Image',
//                           style: TextStyle(
//                             color: Colors.black,
//                             fontSize: 16,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                         SizedBox(width: 10),
//                         Icon(Icons.upload, color: Colors.black),
//                       ],
//                     )
//                         : Text(
//                       _fileName!, // Display the file name after selection
//                       style: TextStyle(
//                         color: Colors.black,
//                         fontSize: 14,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: _savePetData,
//               child: Text('Add Pet'),
//               style: ElevatedButton.styleFrom(
//                 foregroundColor: Colors.white,
//                 backgroundColor: primaryColor, // Use primaryColor for button
//               ),
//             ),
//
//             SizedBox(height: 20),
//             Expanded(
//               child: Container(
//                 decoration: BoxDecoration(
//                   border: Border.all(color: Colors.white),
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: _buildPetList(),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'dart:convert'; // For Base64 encoding
// import 'dart:io'; // For File handling
// import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore package
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:path/path.dart' as p;
//
// import 'constant.dart'; // For getting file names
//
// class PetProfileScreen extends StatefulWidget {
//   final String emailId; // Pass the user email to the screen
//
//   const PetProfileScreen({Key? key, required this.emailId}) : super(key: key);
//
//   @override
//   _PetProfileScreenState createState() => _PetProfileScreenState();
// }
//
// class _PetProfileScreenState extends State<PetProfileScreen> {
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _ageController = TextEditingController();
//   final TextEditingController _typeController = TextEditingController();
//
//   XFile? _imageFile;
//   final ImagePicker _picker = ImagePicker();
//   String? _fileName; // To store and display the file name
//
//   Future<void> _pickImage() async {
//     final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       setState(() {
//         _imageFile = pickedFile;
//         _fileName = p.basename(_imageFile!.path); // Extract the file name
//       });
//     }
//   }
//
//   Future<void> _savePetData() async {
//     final String petName = _nameController.text.trim();
//     final String petAge = _ageController.text.trim();
//     final String petType = _typeController.text.trim();
//     if (petName.isEmpty || petAge.isEmpty || petType.isEmpty || _imageFile == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Please fill all fields and upload an image')),
//       );
//       return;
//     }
//
//     try {
//       // Convert the image to Base64
//       final File imageFile = File(_imageFile!.path);
//       final List<int> imageBytes = await imageFile.readAsBytes();
//       final String base64Image = base64Encode(imageBytes);
//
//       await FirebaseFirestore.instance
//           .collection('users')
//           .doc(widget.emailId)
//           .collection('pets')
//           .doc(petName)
//           .set({
//         'name': petName,
//         'age': petAge,
//         'type': petType,
//         'image': base64Image,
//         'fileName': _fileName,
//       });
//
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Pet added successfully')),
//       );
//
//       _nameController.clear();
//       _ageController.clear();
//       _typeController.clear();
//       setState(() {
//         _imageFile = null;
//         _fileName = null;
//       });
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error saving pet: $e')),
//       );
//     }
//   }
//
//   Future<void> _deletePet(String petName) async {
//     try {
//       await FirebaseFirestore.instance
//           .collection('users')
//           .doc(widget.emailId)
//           .collection('pets')
//           .doc(petName)
//           .delete();
//
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Pet deleted successfully')),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error deleting pet: $e')),
//       );
//     }
//   }
//
//   Future<void> _editPet(String petName, String petAge, String petType) async {
//     _nameController.text = petName;
//     _ageController.text = petAge;
//     _typeController.text = petType;
//   }
//
//   Widget _buildPetList() {
//     return StreamBuilder<QuerySnapshot>(
//       stream: FirebaseFirestore.instance
//           .collection('users')
//           .doc(widget.emailId)
//           .collection('pets')
//           .snapshots(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return CircularProgressIndicator();
//         }
//         if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//           return Text('No pets added yet.');
//         }
//
//         final pets = snapshot.data!.docs;
//
//         return ListView.separated(
//           shrinkWrap: true,
//           itemCount: pets.length,
//           separatorBuilder: (context, index) => Divider(),
//           itemBuilder: (context, index) {
//             final pet = pets[index].data() as Map<String, dynamic>;
//             final petName = pet['name'] ?? '';
//             final petAge = pet['age'] ?? '';
//             final petType = pet['type'] ?? '';
//             final base64Image = pet['image'] ?? '';
//
//             return ListTile(
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => HistoryPage(
//                       emailId: widget.emailId,  // Pass the emailId
//                       petName: petName,         // Pass the pet name
//                       // Pass the pet image (Base64 encoded)
//                     ),
//                   ),
//                 );
//               },
//               leading: CircleAvatar(
//                 backgroundImage: base64Image.isNotEmpty
//                     ? MemoryImage(base64Decode(base64Image))
//                     : null,
//                 child: base64Image.isEmpty ? Icon(Icons.pets) : null,
//               ),
//               title: Text(petName),
//               subtitle: Text('Type: $petType'),
//               trailing: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   IconButton(
//                     icon: Icon(Icons.edit, color: Colors.blue),
//                     onPressed: () {
//                       _editPet(petName, petAge, petType);
//                     },
//                   ),
//                   IconButton(
//                     icon: Icon(Icons.delete, color: Colors.red),
//                     onPressed: () {
//                       _deletePet(petName);
//                     },
//                   ),
//                 ],
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
//
//   @override
//   void dispose() {
//     _nameController.dispose();
//     _ageController.dispose();
//     _typeController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         backgroundColor: primaryColor,
//         title: Text(
//           'Pet Profiles',
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//       ),
//       body: Padding(
//         padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
//         child: Column(
//           children: [
//             TextField(
//               controller: _nameController,
//               decoration: InputDecoration(
//                 labelText: 'Pet Name',
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//               ),
//             ),
//             SizedBox(height: 10),
//             TextField(
//               controller: _ageController,
//               decoration: InputDecoration(
//                 labelText: 'Pet Age',
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//               ),
//             ),
//             SizedBox(height: 10),
//             TextField(
//               controller: _typeController,
//               decoration: InputDecoration(
//                 labelText: 'Pet Type',
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//               ),
//             ),
//             SizedBox(height: 10),
//             GestureDetector(
//               onTap: _pickImage,
//               child: Container(
//                 height: 55,
//                 width: 358,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(10),
//                   border: Border.all(color: Colors.black),
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     _fileName == null
//                         ? Row(
//                       children: [
//                         Text(
//                           'Upload Image',
//                           style: TextStyle(
//                             color: Colors.black,
//                             fontSize: 16,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                         SizedBox(width: 10),
//                         Icon(Icons.upload, color: Colors.black),
//                       ],
//                     )
//                         : Text(
//                       _fileName!,
//                       style: TextStyle(
//                         color: Colors.black,
//                         fontSize: 14,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: _savePetData,
//               child: Text('Add Pet'),
//               style: ElevatedButton.styleFrom(
//                 foregroundColor: Colors.white,
//                 backgroundColor: primaryColor, // Use primaryColor for button
//               ),
//             ),
//             SizedBox(height: 20),
//             Expanded(
//               child: _buildPetList(),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
//
// class HistoryPage extends StatelessWidget {
//   final String emailId; // User's email ID
//   final String petName;
//
//   const HistoryPage({
//     Key? key,
//     required this.emailId,
//     required this.petName,
//   }) : super(key: key);
//
//   // Fetch the medical history of a pet for a specific user
//   Stream<QuerySnapshot> _getMedicalHistory() {
//     return FirebaseFirestore.instance
//         .collection('medicalHistory')
//         .doc(emailId)  // User's email
//         .collection('pets')
//         .doc(petName)  // Pet's name
//         .collection('history') // Pet's medical history
//         .snapshots();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: primaryColor,
//         title: Text('$petName\'s Medical History'),
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: _getMedicalHistory(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }
//
//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return Center(child: Text('No medical history available.'));
//           }
//
//           final historyDocs = snapshot.data!.docs;
//
//           return ListView.builder(
//             itemCount: historyDocs.length,
//             itemBuilder: (context, index) {
//               final historyData = historyDocs[index].data() as Map<String, dynamic>;
//               final int age = historyData['age'] ?? 0;
//               final String disease = historyData['disease'] ?? 'N/A';
//               final double weight = historyData['weight'] ?? 0.0;
//               final Timestamp visitedDate = historyData['visitDate'];
//               final String nextFollowUp = historyData['nextFollowUp'] ?? 'N/A';
//               final String status = historyData['status'] ?? 'N/A';
//               final String treatment = historyData['treatment'] ?? 'N/A';
//
//               final formattedVisitedDate = visitedDate.toDate().toString(); // Format the timestamp to a string
//
//               return Card(
//                 margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//                 elevation: 3,
//                 child: ListTile(
//                   title: Text('Treatment: $treatment'),
//                   subtitle: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text('Age: $age years'),
//                       Text('Disease: $disease'),
//                       Text('Weight: $weight kg'),
//                       Text('Visited Date: $formattedVisitedDate'),
//                       Text('Next Follow-Up: $nextFollowUp'),
//                       Text('Status: $status'),
//                     ],
//                   ),
//                   contentPadding: EdgeInsets.all(12),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }

import 'dart:convert'; // For Base64 encoding
import 'dart:io'; // For File handling
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore package
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:paw1/constant.dart'; // For getting file names

class PetProfileScreen extends StatefulWidget {
  final String emailId; // Pass the user email to the screen

  const PetProfileScreen({Key? key, required this.emailId}) : super(key: key);

  @override
  _PetProfileScreenState createState() => _PetProfileScreenState();
}

class _PetProfileScreenState extends State<PetProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();

  XFile? _imageFile;
  final ImagePicker _picker = ImagePicker();
  String? _fileName; // To store and display the file name

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = pickedFile;
        _fileName = p.basename(_imageFile!.path); // Extract the file name
      });
    }
  }

  Future<void> _savePetData() async {
    final String petName = _nameController.text.trim();
    final String petAge = _ageController.text.trim();
    final String petType = _typeController.text.trim();
    if (petName.isEmpty || petAge.isEmpty || petType.isEmpty || _imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields and upload an image')),
      );
      return;
    }

    try {
      // Convert the image to Base64
      final File imageFile = File(_imageFile!.path);
      final List<int> imageBytes = await imageFile.readAsBytes();
      final String base64Image = base64Encode(imageBytes);

      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.emailId)
          .collection('pets')
          .doc(petName)
          .set({
        'name': petName,
        'age': petAge,
        'type': petType,
        'image': base64Image,
        'fileName': _fileName,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Pet added successfully')),
      );

      _nameController.clear();
      _ageController.clear();
      _typeController.clear();
      setState(() {
        _imageFile = null;
        _fileName = null;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving pet: $e')),
      );
    }
  }

  Future<void> _deletePet(String petName) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.emailId)
          .collection('pets')
          .doc(petName)
          .delete();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Pet deleted successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting pet: $e')),
      );
    }
  }

  Future<void> _editPet(String petName, String petAge, String petType) async {
    _nameController.text = petName;
    _ageController.text = petAge;
    _typeController.text = petType;
  }

  Widget _buildPetList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(widget.emailId)
          .collection('pets')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Text('No pets added yet.');
        }

        final pets = snapshot.data!.docs;

        return ListView.separated(
          shrinkWrap: true,
          itemCount: pets.length,
          separatorBuilder: (context, index) => Divider(),
          itemBuilder: (context, index) {
            final pet = pets[index].data() as Map<String, dynamic>;
            final petName = pet['name'] ?? '';
            final petAge = pet['age'] ?? '';
            final petType = pet['type'] ?? '';
            final base64Image = pet['image'] ?? '';

            return ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HistoryPage(
                      emailId: widget.emailId,  // Pass the emailId
                      petName: petName,         // Pass the pet name
                      // Pass the pet image (Base64 encoded)
                    ),
                  ),
                );
              },
              leading: CircleAvatar(
                backgroundImage: base64Image.isNotEmpty
                    ? MemoryImage(base64Decode(base64Image))
                    : null,
                child: base64Image.isEmpty ? Icon(Icons.pets) : null,
              ),
              title: Text(petName),
              subtitle: Text('Type: $petType'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.blue),
                    onPressed: () {
                      _editPet(petName, petAge, petType);
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      _deletePet(petName);
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _typeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: primaryColor,
        title: Text(
          'Pet Profiles',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Pet Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _ageController,
              decoration: InputDecoration(
                labelText: 'Pet Age',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _typeController,
              decoration: InputDecoration(
                labelText: 'Pet Type',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 10),
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 55,
                width: 358,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.black),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _fileName == null
                        ? Row(
                      children: [
                        Text(
                          'Upload Image',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(width: 10),
                        Icon(Icons.upload, color: Colors.black),
                      ],
                    )
                        : Text(
                      _fileName!,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _savePetData,
              child: Text('Add Pet'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: _buildPetList(),
            ),
          ],
        ),
      ),
    );
  }
}




class HistoryPage extends StatelessWidget {
  final String emailId; // User's email ID
  final String petName;

  const HistoryPage({
    Key? key,
    required this.emailId,
    required this.petName,
  }) : super(key: key);

  // Fetch the medical history of a pet for a specific user
  Stream<QuerySnapshot> _getMedicalHistory() {
    return FirebaseFirestore.instance
        .collection('medicalHistory')
        .doc(emailId) // User's email
        .collection('pets')
        .doc(petName) // Pet's name
        .collection('history') // Pet's medical history
        .snapshots();
  }

  String getAgeString(dynamic age) {
    if (age is String) {
      return age; // Directly return if stored as "4 months" in Firestore
    }

    return "Unknown"; // Default for invalid data
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text('$petName\'s Medical History'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _getMedicalHistory(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No medical history available.'));
          }

          final historyDocs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: historyDocs.length,
            itemBuilder: (context, index) {
              final historyData = historyDocs[index].data() as Map<String, dynamic>;

              // Safely extract and cast fields
              final String ageString = getAgeString(historyData['age']);

              final String disease = historyData['disease']?.toString() ?? 'N/A';

              final double weight = historyData['weight'] is double
                  ? historyData['weight']
                  : double.tryParse(historyData['weight']?.toString() ?? '0.0') ?? 0.0;

              final String treatment = historyData['treatment']?.toString() ?? 'N/A';

              // Safely handle visitDate (can be either Timestamp or String)
              final visitedDateField = historyData['visitDate'];
              DateTime? visitedDate;

              if (visitedDateField is Timestamp) {
                visitedDate = visitedDateField.toDate();
              } else if (visitedDateField is String) {
                visitedDate = DateTime.tryParse(visitedDateField);
              }

              final String formattedVisitedDate = visitedDate != null
                  ? DateFormat('yyyy-MM-dd').format(visitedDate)
                  : 'Unknown';

              final String nextFollowUp = historyData['nextFollowUp']?.toString() ?? 'N/A';
              final String status = historyData['status']?.toString() ?? 'N/A';

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                elevation: 3,
                child: ListTile(
                  title: Text('Treatment: $treatment'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Age: $ageString'),
                      Text('Disease: $disease'),
                      Text('Weight: $weight kg'),
                      Text('Visited Date: $formattedVisitedDate'),
                      Text('Next Follow-Up: $nextFollowUp'),
                      Text('Status: $status'),
                    ],
                  ),
                  contentPadding: const EdgeInsets.all(12),
                ),
              );
            },
          );
        },
      ),
    );
  }
}