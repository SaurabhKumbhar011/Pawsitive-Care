import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:paw1/constant.dart';

class MedicalHistoryPage extends StatefulWidget {
  final String petName;
  final String petType;
  final String petAge;
  final String ownerEmail;
  final String vetEmail;

  const MedicalHistoryPage({
    Key? key,
    required this.petName,
    required this.petType,
    required this.petAge,
    required this.ownerEmail,
    required this.vetEmail,
  }) : super(key: key);

  @override
  _MedicalHistoryPageState createState() => _MedicalHistoryPageState();
}

class _MedicalHistoryPageState extends State<MedicalHistoryPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Form fields
  final TextEditingController _visitDateController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _diseaseController = TextEditingController();
  final TextEditingController _treatmentController = TextEditingController();
  final TextEditingController _nextFollowUpController = TextEditingController();
  String _status = 'Healthy';

  Future<void> _pickDate(TextEditingController controller) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      controller.text = DateFormat('yyyy-MM-dd').format(pickedDate);
    }
  }

  // Fetch medical history for the specific pet
  Stream<QuerySnapshot> _getMedicalHistoryStream() {
    return FirebaseFirestore.instance
        .collection('medicalHistory')
        .doc(widget.vetEmail)
        .collection('pets')
        .doc(widget.petName)
        .collection('history')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  // Add or Edit record
  void _showForm({String? docId, Map<String, dynamic>? recordData}) {
    if (recordData != null) {
      _visitDateController.text = recordData['visitDate'] ?? '';
      _ageController.text = recordData['age'] ?? '';
      _weightController.text = recordData['weight'] ?? '';
      _diseaseController.text = recordData['disease'] ?? '';
      _treatmentController.text = recordData['treatment'] ?? '';
      _nextFollowUpController.text = recordData['nextFollowUp'] ?? '';
      _status = recordData['status'] ?? 'Healthy';
    } else {
      _visitDateController.clear();
      _ageController.clear();
      _weightController.clear();
      _diseaseController.clear();
      _treatmentController.clear();
      _nextFollowUpController.clear();
      _status = 'Healthy';
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: 20,
            left: 20,
            right: 20,
          ),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _visitDateController,
                    decoration: const InputDecoration(
                      labelText: 'Visit Date',
                      icon: Icon(Icons.calendar_today),
                    ),
                    readOnly: true,
                    onTap: () => _pickDate(_visitDateController),
                    validator: (value) => value == null || value.isEmpty ? 'Visit date is required' : null,
                  ),
                  TextFormField(
                    controller: _ageController,
                    decoration: const InputDecoration(labelText: 'Age'),
                    validator: (value) => value == null || value.isEmpty ? 'Age is required' : null,
                  ),
                  TextFormField(
                    controller: _weightController,
                    decoration: const InputDecoration(labelText: 'Weight (kg)'),
                    keyboardType: TextInputType.number,
                    validator: (value) => value == null || value.isEmpty ? 'Weight is required' : null,
                  ),
                  TextFormField(
                    controller: _diseaseController,
                    decoration: const InputDecoration(labelText: 'Disease'),
                    validator: (value) => value == null || value.isEmpty ? 'Disease is required' : null,
                  ),
                  TextFormField(
                    controller: _treatmentController,
                    decoration: const InputDecoration(labelText: 'Treatment'),
                    validator: (value) => value == null || value.isEmpty ? 'Treatment is required' : null,
                  ),
                  TextFormField(
                    controller: _nextFollowUpController,
                    decoration: const InputDecoration(
                      labelText: 'Next Follow-Up',
                      icon: Icon(Icons.calendar_today),
                    ),
                    readOnly: true,
                    onTap: () => _pickDate(_nextFollowUpController),
                    validator: (value) => value == null || value.isEmpty ? 'Next follow-up is required' : null,
                  ),
                  DropdownButtonFormField<String>(
                    value: _status,
                    items: const [
                      DropdownMenuItem(value: 'Healthy', child: Text('Healthy')),
                      DropdownMenuItem(value: 'Need Attention', child: Text('Need Attention')),
                    ],
                    onChanged: (value) => setState(() => _status = value!),
                    decoration: const InputDecoration(labelText: 'Status'),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        final data = {
                          'visitDate': _visitDateController.text,
                          'age': _ageController.text,
                          'weight': _weightController.text,
                          'disease': _diseaseController.text,
                          'treatment': _treatmentController.text,
                          'nextFollowUp': _nextFollowUpController.text,
                          'status': _status,
                          'timestamp': FieldValue.serverTimestamp(),
                        };

                        // Save data for veterinarian
                        final vetRef = FirebaseFirestore.instance
                            .collection('medicalHistory')
                            .doc(widget.vetEmail)
                            .collection('pets')
                            .doc(widget.petName)
                            .collection('history');

                        // Save data for owner
                        final ownerRef = FirebaseFirestore.instance
                            .collection('medicalHistory')
                            .doc(widget.ownerEmail)
                            .collection('pets')
                            .doc(widget.petName)
                            .collection('history');

                        if (docId != null) {
                          await vetRef.doc(docId).update(data);
                          await ownerRef.doc(docId).update(data);
                        } else {
                          final newDoc = await vetRef.add(data);
                          await ownerRef.doc(newDoc.id).set(data);
                        }

                        Navigator.pop(context);
                      }
                    },
                    child: const Text('Submit'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Delete record
  Future<void> _deleteRecord(String docId) async {
    await FirebaseFirestore.instance
        .collection('medicalHistory')
        .doc(widget.vetEmail)
        .collection('pets')
        .doc(widget.petName)
        .collection('history')
        .doc(docId)
        .delete();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Medical record deleted successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text('${widget.petName}\'s Medical History'),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _getMedicalHistoryStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No medical records found.'));
          }
          return ListView(
            padding: const EdgeInsets.all(8.0),
            children: snapshot.data!.docs.map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              return Card(
                child: ListTile(
                  title: Text('Date: ${data['visitDate']}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Disease: ${data['disease']} (Age: ${data['age']})'),
                      Text('Treatment: ${data['treatment']} (Weight: ${data['weight']}kg)'),
                      Text('Status: ${data['status']}'),
                      Text('Next Follow-Up: ${data['nextFollowUp']}'),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _showForm(docId: doc.id, recordData: data),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _deleteRecord(doc.id),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showForm(),
        child: const Icon(Icons.add),
        backgroundColor: primaryColor,
      ),
    );
  }
}