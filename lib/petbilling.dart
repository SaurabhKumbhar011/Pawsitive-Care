// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:razorpay_flutter/razorpay_flutter.dart';
//
// class PetBillingScreen extends StatefulWidget {
//   @override
//   _PetBillingScreenState createState() => _PetBillingScreenState();
// }
//
// class _PetBillingScreenState extends State<PetBillingScreen> {
//   final String razorpayKey = "rzp_test_OcseqcckGr0cY6";
//   late Razorpay _razorpay;
//   String userEmail = FirebaseAuth.instance.currentUser?.email?.trim().toLowerCase() ?? "";
//
//   @override
//   void initState() {
//     super.initState();
//     print("Fetching bills for: $userEmail"); // Debugging output
//     _razorpay = Razorpay();
//     _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
//     _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
//   }
//
//   @override
//   void dispose() {
//     _razorpay.clear();
//     super.dispose();
//   }
//
//   void _openCheckout(double amount, DocumentReference billRef) {
//     var options = {
//       'key': razorpayKey,
//       'amount': (amount * 100).toInt(),
//       'name': 'Pawsitive Care',
//       'description': 'Veterinary Bill Payment',
//       'prefill': {'email': userEmail},
//       'theme': {'color': "#3399cc"}
//     };
//
//     try {
//       _razorpay.open(options);
//     } catch (e) {
//       debugPrint('Error opening Razorpay: $e');
//     }
//   }
//
//   void _handlePaymentSuccess(PaymentSuccessResponse response) async {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text("Payment Successful: ${response.paymentId}")),
//     );
//
//     FirebaseFirestore.instance
//         .collection('billing')
//         .where('ownerEmail', isEqualTo: userEmail)
//         .where('paymentStatus', isEqualTo: 'Pending')
//         .get()
//         .then((querySnapshot) {
//       for (var doc in querySnapshot.docs) {
//         doc.reference.update({'paymentStatus': 'Paid'});
//       }
//     });
//   }
//
//   void _handlePaymentError(PaymentFailureResponse response) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text("Payment Failed: ${response.message}")),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Billing History")),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance
//             .collection('billing')
//             .where('ownerEmail', isEqualTo: userEmail)
//             .snapshots(),
//         builder: (context, snapshot) {
//           // 🛠 Debugging Step 1: Check Firestore errors
//           if (snapshot.hasError) {
//             print("Firestore Error: ${snapshot.error}");
//             return Center(child: Text("Error loading bills: ${snapshot.error}"));
//           }
//
//           // 🛠 Debugging Step 2: Check if data is empty
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }
//
//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             print("No billing data found for: $userEmail");
//             return Center(child: Text("No billing data found."));
//           }
//
//           var bills = snapshot.data!.docs;
//           print("Fetched ${bills.length} bills from Firestore."); // Debugging output
//
//           var pendingBills = bills.where((doc) {
//             var data = doc.data() as Map<String, dynamic>;
//             return data['paymentStatus'] == 'Pending';
//           }).toList();
//
//           var paidBills = bills.where((doc) {
//             var data = doc.data() as Map<String, dynamic>;
//             return data['paymentStatus'] == 'Paid';
//           }).toList();
//
//           return ListView(
//             children: [
//               if (pendingBills.isNotEmpty)
//                 Padding(
//                   padding: const EdgeInsets.all(10),
//                   child: Text("Pending Bills", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                 ),
//               ...pendingBills.map((bill) {
//                 var billData = bill.data() as Map<String, dynamic>;
//                 print("Pending Bill: ${billData}"); // Debugging output
//
//                 double totalBill = (billData['cost'] as num?)?.toDouble() ?? 0.0;
//                 return Card(
//                   margin: EdgeInsets.all(10),
//                   child: ListTile(
//                     title: Text("Service: ${billData['serviceProvided']}"),
//                     subtitle: Text("Total: ₹$totalBill"),
//                     trailing: ElevatedButton(
//                       onPressed: () => _openCheckout(totalBill, bill.reference),
//                       child: Text("Pay Now"),
//                     ),
//                   ),
//                 );
//               }).toList(),
//
//               if (paidBills.isNotEmpty)
//                 Padding(
//                   padding: const EdgeInsets.all(10),
//                   child: Text("Paid Bills", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                 ),
//               ...paidBills.map((bill) {
//                 var billData = bill.data() as Map<String, dynamic>;
//                 print("Paid Bill: ${billData}"); // Debugging output
//
//                 double totalBill = (billData['cost'] as num?)?.toDouble() ?? 0.0;
//                 return Card(
//                   color: Colors.green[100],
//                   margin: EdgeInsets.all(10),
//                   child: ListTile(
//                     title: Text("Service: ${billData['serviceProvided']}"),
//                     subtitle: Text("Total: ₹$totalBill\nStatus: Paid"),
//                     trailing: Icon(Icons.check_circle, color: Colors.green),
//                   ),
//                 );
//               }).toList(),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:razorpay_flutter/razorpay_flutter.dart';
//
// import 'constant.dart';
//
// class PetBillingScreen extends StatefulWidget {
//   @override
//   _PetBillingScreenState createState() => _PetBillingScreenState();
// }
//
// class _PetBillingScreenState extends State<PetBillingScreen> {
//   final String razorpayKey = "rzp_test_OcseqcckGr0cY6";
//   late Razorpay _razorpay;
//   String userEmail = FirebaseAuth.instance.currentUser?.email?.trim().toLowerCase() ?? "";
//
//   @override
//   void initState() {
//     super.initState();
//     _razorpay = Razorpay();
//     _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
//     _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
//   }
//
//   @override
//   void dispose() {
//     _razorpay.clear();
//     super.dispose();
//   }
//
//   void _openCheckout(double amount, DocumentReference billRef) {
//     var options = {
//       'key': razorpayKey,
//       'amount': (amount * 100).toInt(),
//       'name': 'Pawsitive Care',
//       'description': 'Veterinary Bill Payment',
//       'prefill': {'email': userEmail},
//       'theme': {'color': "#3399cc"}
//     };
//
//     try {
//       _razorpay.open(options);
//     } catch (e) {
//       debugPrint('Error opening Razorpay: $e');
//     }
//   }
//
//   void _handlePaymentSuccess(PaymentSuccessResponse response) async {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text("Payment Successful: ${response.paymentId}")),
//     );
//
//     FirebaseFirestore.instance
//         .collection('billing')
//         .where('ownerEmail', isEqualTo: userEmail)
//         .where('paymentStatus', isEqualTo: 'Pending')
//         .get()
//         .then((querySnapshot) {
//       for (var doc in querySnapshot.docs) {
//         doc.reference.update({
//           'paymentStatus': 'Paid',
//           'paymentDate': Timestamp.now(), // Store payment timestamp
//         });
//       }
//     });
//   }
//
//   void _handlePaymentError(PaymentFailureResponse response) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text("Payment Failed: ${response.message}")),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: primaryColor,
//         title: Text('Billing History'),
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance
//             .collection('billing')
//             .where('ownerEmail', isEqualTo: userEmail)
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.hasError) {
//             return Center(child: Text("Error loading bills: ${snapshot.error}"));
//           }
//
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }
//
//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return Center(child: Text("No billing data found."));
//           }
//
//           var bills = snapshot.data!.docs;
//           var pendingBills = bills.where((doc) => (doc.data() as Map<String, dynamic>)['paymentStatus'] == 'Pending').toList();
//           var paidBills = bills.where((doc) => (doc.data() as Map<String, dynamic>)['paymentStatus'] == 'Paid').toList();
//
//           // Sort paid bills by payment date (most recent at the top)
//           paidBills.sort((a, b) {
//             var dateA = (a.data() as Map<String, dynamic>)['paymentDate'] as Timestamp?;
//             var dateB = (b.data() as Map<String, dynamic>)['paymentDate'] as Timestamp?;
//             return dateB?.compareTo(dateA ?? Timestamp(0, 0)) ?? 0;
//           });
//
//           return ListView(
//             children: [
//               if (pendingBills.isNotEmpty)
//                 Padding(
//                   padding: const EdgeInsets.all(10),
//                   child: Text("Pending Bills", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                 ),
//               ...pendingBills.map((bill) {
//                 var billData = bill.data() as Map<String, dynamic>;
//                 List<dynamic> services = billData['services'] ?? [];
//                 double totalBill = (billData['totalCost'] as num?)?.toDouble() ?? 0.0;
//                 return Card(
//                   margin: EdgeInsets.all(10),
//                   child: ListTile(
//                     title: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text("Pet: ${billData['petName']}", style: TextStyle(fontWeight: FontWeight.bold)),
//                         ...services.map((service) => Text("• $service")),
//                         SizedBox(height: 5),
//                         Text("Total: ₹$totalBill", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
//                       ],
//                     ),
//                     trailing: ElevatedButton(
//                       onPressed: () => _openCheckout(totalBill, bill.reference),
//                       child: Text("Pay Now"),
//                     ),
//                   ),
//                 );
//               }).toList(),
//
//               if (paidBills.isNotEmpty)
//                 Padding(
//                   padding: const EdgeInsets.all(10),
//                   child: Text("Paid Bills", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                 ),
//               ...paidBills.map((bill) {
//                 var billData = bill.data() as Map<String, dynamic>;
//                 List<dynamic> services = billData['services'] ?? [];
//                 double totalBill = (billData['totalCost'] as num?)?.toDouble() ?? 0.0;
//                 Timestamp? paymentDate = billData['date'] as Timestamp?;
//                 String formattedDate = paymentDate != null
//                     ? "${paymentDate.toDate().day}-${paymentDate.toDate().month}-${paymentDate.toDate().year} ${paymentDate.toDate().hour}:${paymentDate.toDate().minute}"
//                     : "Unknown Date";
//
//                 return Card(
//                   color: Colors.green[100],
//                   margin: EdgeInsets.all(10),
//                   child: ListTile(
//                     title: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text("Pet: ${billData['petName']}", style: TextStyle(fontWeight: FontWeight.bold)),
//                         ...services.map((service) => Text("• $service")),
//                         SizedBox(height: 5),
//                         Text("Total: ₹$totalBill", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green[800])),
//                         SizedBox(height: 5),
//                         Text("Paid on: $formattedDate", style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic)),
//                       ],
//                     ),
//                     trailing: Icon(Icons.check_circle, color: Colors.green),
//                   ),
//                 );
//               }).toList(),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }

// 04/03
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import 'constant.dart';

class PetBillingScreen extends StatefulWidget {
  @override
  _PetBillingScreenState createState() => _PetBillingScreenState();
}

class _PetBillingScreenState extends State<PetBillingScreen> {
  final String razorpayKey = "rzp_test_OcseqcckGr0cY6";
  late Razorpay _razorpay;
  String userEmail = FirebaseAuth.instance.currentUser?.email?.trim().toLowerCase() ?? "";

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  void _openCheckout(double amount, DocumentReference billRef) {
    var options = {
      'key': razorpayKey,
      'amount': (amount * 100).toInt(),
      'name': 'Pawsitive Care',
      'description': 'Veterinary Bill Payment',
      'prefill': {'email': userEmail},
      'theme': {'color': "#3399cc"}
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error opening Razorpay: $e');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Payment Successful: ${response.paymentId}")),
    );

    FirebaseFirestore.instance
        .collection('billing')
        .where('ownerEmail', isEqualTo: userEmail)
        .where('paymentStatus', isEqualTo: 'Pending')
        .get()
        .then((querySnapshot) {
      for (var doc in querySnapshot.docs) {
        doc.reference.update({
          'paymentStatus': 'Paid',
          'date': Timestamp.now(), // Store correct payment timestamp
        });
      }
    });
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Payment Failed: ${response.message}")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text('Billing History'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('billing')
            .where('ownerEmail', isEqualTo: userEmail)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text("Error loading bills: ${snapshot.error}"));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No billing data found."));
          }

          var bills = snapshot.data!.docs;
          var pendingBills = bills.where((doc) => (doc.data() as Map<String, dynamic>)['paymentStatus'] == 'Pending').toList();
          var paidBills = bills.where((doc) => (doc.data() as Map<String, dynamic>)['paymentStatus'] == 'Paid').toList();

          // Sort paid bills by payment date (most recent at the top)
          paidBills.sort((a, b) {
            var dateA = (a.data() as Map<String, dynamic>)['date'] as Timestamp?;
            var dateB = (b.data() as Map<String, dynamic>)['date'] as Timestamp?;

            if (dateA == null) return 1; // Put null dates at the bottom
            if (dateB == null) return -1;

            return dateB.compareTo(dateA); // Sort in descending order (newest first)
          });

          return ListView(
            children: [
              if (pendingBills.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text("Pending Bills", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ...pendingBills.map((bill) {
                var billData = bill.data() as Map<String, dynamic>;
                List<dynamic> services = billData['services'] ?? [];
                double totalBill = (billData['totalCost'] as num?)?.toDouble() ?? 0.0;

                return Card(
                  margin: EdgeInsets.all(10),
                  child: ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Pet: ${billData['petName']}", style: TextStyle(fontWeight: FontWeight.bold)),
                        ...services.map((service) => Text("• ${service['serviceProvided']} - ₹${service['cost']}")),
                        SizedBox(height: 5),
                        Text("Total: ₹$totalBill", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
                      ],
                    ),
                    trailing: ElevatedButton(
                      onPressed: () => _openCheckout(totalBill, bill.reference),
                      child: Text("Pay Now"),
                    ),
                  ),
                );
              }).toList(),

              if (paidBills.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text("Paid Bills", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ...paidBills.map((bill) {
                var billData = bill.data() as Map<String, dynamic>;
                List<dynamic> services = billData['services'] ?? [];
                double totalBill = (billData['totalCost'] as num?)?.toDouble() ?? 0.0;
                Timestamp? paymentDate = billData['date'] as Timestamp?;
                String formattedDate = paymentDate != null
                    ? "${paymentDate.toDate().day}-${paymentDate.toDate().month}-${paymentDate.toDate().year} ${paymentDate.toDate().hour}:${paymentDate.toDate().minute}"
                    : "Unknown Date";

                return Card(
                  color: Colors.green[100],
                  margin: EdgeInsets.all(10),
                  child: ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Pet: ${billData['petName']}", style: TextStyle(fontWeight: FontWeight.bold)),
                        ...services.map((service) => Text("• ${service['serviceProvided']} - ₹${service['cost']}")),
                        SizedBox(height: 5),
                        Text("Total: ₹$totalBill", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green[800])),
                        SizedBox(height: 5),
                        Text("Paid on: $formattedDate", style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic)),
                      ],
                    ),
                    trailing: Icon(Icons.check_circle, color: Colors.green),
                  ),
                );
              }).toList(),
            ],
          );
        },
      ),
    );
  }
}
