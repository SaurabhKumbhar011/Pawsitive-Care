import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:paw1/veterinary/vetprofile.dart';
import '../constant.dart';
import 'RegisteredPet.dart';
import 'appointments/AppintmentHistory.dart';
import 'appointments/AppointmentManagementPage.dart';
import 'appointments/TodaysAppointment.dart';
import 'appointments/UpcomingAppointments.dart'; // Import the primary color

class VetDashboard extends StatefulWidget {
  final String vetId;

  const VetDashboard({required this.vetId});

  @override
  _VetDashboardState createState() => _VetDashboardState();
}

class _VetDashboardState extends State<VetDashboard> {
  bool isSlotAvailable = true; // Default to available

  @override
  void initState() {
    super.initState();
    _loadSlotAvailability();
    _moveAppointmentsToToday(widget.vetId);
  }

  // Load the slot availability status from Firestore
  Future<void> _loadSlotAvailability() async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('veterinarians')
          .doc(widget.vetId)
          .get();

      setState(() {
        isSlotAvailable = snapshot['isSlotAvailable'] ?? true;
      });
    } catch (e) {
      print('Error loading slot availability: $e');
    }
  }

  // Update the slot availability status in Firestore
  Future<void> _toggleSlotAvailability(bool value) async {
    try {
      await FirebaseFirestore.instance
          .collection('veterinarians')
          .doc(widget.vetId)
          .update({'isSlotAvailable': value});

      setState(() {
        isSlotAvailable = value;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(isSlotAvailable ? 'Slots Enabled' : 'Slots Disabled')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating slot availability: $e')),
      );
    }
  }

  void _moveAppointmentsToToday(String vetEmail) async {
    final db = FirebaseFirestore.instance;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    try {
      final upcomingRef = db
          .collection('upcomingAppointments')
          .doc(vetEmail)
          .collection('appointments');

      final todaysRef = db
          .collection('todaysAppointments')
          .doc(vetEmail)
          .collection('appointments');

      // Query for appointments matching today's date
      final snapshot = await upcomingRef.get();
      for (var doc in snapshot.docs) {
        final data = doc.data();
        final appointmentDate = (data['appointmentDate'] as Timestamp).toDate();

        // If the appointment is today, move it
        if (appointmentDate.year == today.year &&
            appointmentDate.month == today.month &&
            appointmentDate.day == today.day) {
          // Move to today's appointments
          await todaysRef.doc(doc.id).set(data);
          // Remove from upcoming appointments
          await doc.reference.delete();
        }
      }
    } catch (e) {
      debugPrint('Error moving appointments to today: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Dashboard',
            style: TextStyle(
              fontWeight: FontWeight.bold, // Makes the text bold
            ),
          ),
        ),
        backgroundColor: primaryColor,
        actions: [
          IconButton(
            iconSize: 40.0,
            icon: Icon(Icons.account_circle),
            onPressed: () {
              // Navigate to VetProfile with vetEmail
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VetProfile(vetEmail: widget.vetId),
                ),
              );
            },
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Slot availability toggle
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Accepting Appointments:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Switch(
                    value: isSlotAvailable,
                    onChanged: (bool value) {
                      _toggleSlotAvailability(value);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20), // Space between toggle and first card

              // First Card for Registered Pets
              Container(
                height: 200,
                child: Card(
                  elevation: 4.0,
                  margin: const EdgeInsets.symmetric(vertical: 10.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RegisteredPetsPage(vetEmail: widget.vetId),
                        ),
                      );
                    },
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.pets,
                            color: primaryColor,
                            size: 50,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Registered Pet',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Second Card for Appointment Management
              Container(
                height: 200,
                child: Card(
                  elevation: 4.0,
                  margin: const EdgeInsets.symmetric(vertical: 10.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AppointmentManagementPage(vetEmail: widget.vetId),
                        ),
                      );
                    },
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.edit_calendar_rounded,
                            color: primaryColor,
                            size: 50,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Appointment Management',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Third Card for Today's Appointments
              Container(
                height: 200,
                child: Card(
                  elevation: 4.0,
                  margin: const EdgeInsets.symmetric(vertical: 10.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TodaysAppointmentsPage(vetEmail: widget.vetId),
                        ),
                      );
                    },
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.calendar_today,
                            color: primaryColor,
                            size: 50,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Today\'s Appointment',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),Container(
                height: 200,
                child: Card(
                  elevation: 4.0,
                  margin: const EdgeInsets.symmetric(vertical: 10.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UpcomingAppointmentsPage(vetEmail: widget.vetId),
                        ),
                      );
                    },
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.calendar_today_outlined,
                            color: primaryColor,
                            size: 50,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Upcoming Appointment',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),Container(
                height: 200,
                child: Card(
                  elevation: 4.0,
                  margin: const EdgeInsets.symmetric(vertical: 10.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HistoryAppointmentsPage(vetEmail: widget.vetId),
                        ),
                      );
                    },
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.calendar_month_outlined,
                            color: primaryColor,
                            size: 50,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Appointment History',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}