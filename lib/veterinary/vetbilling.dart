// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class VetBillingPage extends StatefulWidget {
//   final String petName;
//   final String vetEmail;
//   final String ownerEmail;
//
//   const VetBillingPage({
//     Key? key,
//     required this.petName,
//     required this.vetEmail,
//     required this.ownerEmail,
//   }) : super(key: key);
//
//   @override
//   _VetBillingPageState createState() => _VetBillingPageState();
// }
//
// class _VetBillingPageState extends State<VetBillingPage> {
//   final TextEditingController serviceController = TextEditingController();
//   final TextEditingController costController = TextEditingController();
//   double totalBill = 0.0;
//
//   void _sendBillToOwner() async {
//     String service = serviceController.text.trim();
//     double cost = double.tryParse(costController.text.trim()) ?? 0.0;
//
//     if (service.isEmpty || cost <= 0) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Enter valid service and cost.")),
//       );
//       return;
//     }
//
//     final newBill = {
//       'vetEmail': widget.vetEmail,
//       'ownerEmail': widget.ownerEmail,
//       'petName': widget.petName,
//       'serviceProvided': service,
//       'cost': cost,
//       'paymentStatus': 'Pending',
//       'date': Timestamp.now(),
//     };
//
//     await FirebaseFirestore.instance.collection('billing').add(newBill);
//
//     setState(() {
//       serviceController.clear();
//       costController.clear();
//     });
//   }
//
//   void _updatePaymentStatus(DocumentSnapshot serviceDoc) async {
//     await serviceDoc.reference.update({'paymentStatus': 'Paid'});
//     setState(() {});
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Billing for ${widget.petName}')),
//       body: Padding(
//         padding: const EdgeInsets.all(12.0),
//         child: Column(
//           children: [
//             Card(
//               elevation: 4,
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   children: [
//                     TextField(controller: serviceController, decoration: const InputDecoration(labelText: 'Service Provided')),
//                     TextField(controller: costController, decoration: const InputDecoration(labelText: 'Cost (₹)'), keyboardType: TextInputType.number),
//                     const SizedBox(height: 10),
//                     ElevatedButton(onPressed: _sendBillToOwner, child: const Text('Send Bill')),
//                   ],
//                 ),
//               ),
//             ),
//             const SizedBox(height: 10),
//             Expanded(
//               child: StreamBuilder<QuerySnapshot>(
//                 stream: FirebaseFirestore.instance
//                     .collection('billing')
//                     .where('vetEmail', isEqualTo: widget.vetEmail)
//                     .where('petName', isEqualTo: widget.petName)
//                     .snapshots(),
//                 builder: (context, snapshot) {
//                   if (snapshot.hasError) {
//                     return Center(child: Text("Error loading bills: ${snapshot.error}"));
//                   }
//
//                   if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                     return const Center(child: Text("No billing data found."));
//                   }
//
//                   final services = snapshot.data!.docs;
//
//                   return ListView.builder(
//                     itemCount: services.length,
//                     itemBuilder: (context, index) {
//                       final data = services[index].data() as Map<String, dynamic>;
//                       double cost = (data['cost'] as num?)?.toDouble() ?? 0.0;
//                       String status = data['paymentStatus'] ?? 'Unknown';
//
//                       return Card(
//                         margin: EdgeInsets.all(10),
//                         child: ListTile(
//                           title: Text("Service: ${data['serviceProvided']}"),
//                           subtitle: Text("Cost: ₹$cost\nStatus: $status"),
//                           trailing: status == 'Pending'
//                               ? ElevatedButton(
//                             onPressed: () => _updatePaymentStatus(services[index]),
//                             child: Text("Mark as Paid"),
//                           )
//                               : Icon(Icons.check_circle, color: Colors.green),
//                         ),
//                       );
//                     },
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//


import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VetBillingPage extends StatefulWidget {
  final String petName;
  final String vetEmail;
  final String ownerEmail;

  const VetBillingPage({
    Key? key,
    required this.petName,
    required this.vetEmail,
    required this.ownerEmail,
  }) : super(key: key);

  @override
  _VetBillingPageState createState() => _VetBillingPageState();
}

class _VetBillingPageState extends State<VetBillingPage> {
  final List<Map<String, dynamic>> services = [];
  final TextEditingController serviceController = TextEditingController();
  final TextEditingController costController = TextEditingController();

  void _addService() {
    String service = serviceController.text.trim();
    double cost = double.tryParse(costController.text.trim()) ?? 0.0;

    if (service.isEmpty || cost <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter valid service and cost.")),
      );
      return;
    }

    setState(() {
      services.add({
        'serviceProvided': service,
        'cost': cost,
      });
      serviceController.clear();
      costController.clear();
    });
  }

  void _sendBillToOwner() async {
    if (services.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please add at least one service.")),
      );
      return;
    }

    double totalCost = services.fold(0.0, (sum, item) => sum + item['cost']);

    final newBill = {
      'vetEmail': widget.vetEmail,
      'ownerEmail': widget.ownerEmail,
      'petName': widget.petName,
      'services': services,
      'totalCost': totalCost,
      'paymentStatus': 'Pending',
      'date': Timestamp.now(),
    };

    await FirebaseFirestore.instance.collection('billing').add(newBill);

    setState(() {
      services.clear();
    });
  }

  void _updatePaymentStatus(DocumentSnapshot billDoc) async {
    await billDoc.reference.update({'paymentStatus': 'Paid'});
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Billing for ${widget.petName}')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextField(controller: serviceController, decoration: const InputDecoration(labelText: 'Service Provided')),
                    TextField(controller: costController, decoration: const InputDecoration(labelText: 'Cost (₹)'), keyboardType: TextInputType.number),
                    const SizedBox(height: 10),
                    ElevatedButton(onPressed: _addService, child: const Text('Add Service')),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('billing')
                    .where('vetEmail', isEqualTo: widget.vetEmail)
                    .where('petName', isEqualTo: widget.petName)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text("Error loading bills: ${snapshot.error}"));
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text("No billing data found."));
                  }

                  final bills = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: bills.length,
                    itemBuilder: (context, index) {
                      final data = bills[index].data() as Map<String, dynamic>;
                      double totalCost = (data['totalCost'] as num?)?.toDouble() ?? 0.0;
                      String status = data['paymentStatus'] ?? 'Unknown';
                      List<dynamic> serviceList = data['services'] ?? [];

                      return Card(
                        margin: const EdgeInsets.all(10),
                        child: ListTile(
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Total Bill: ₹$totalCost"),
                              if (serviceList.length == 1)
                                Text("Service: ${serviceList[0]['serviceProvided']}"),
                              if (serviceList.length > 1)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: serviceList.map((service) => Text("- ${service['serviceProvided']} (₹${service['cost']})")).toList(),
                                ),
                              Text("Status: $status"),
                            ],
                          ),
                          trailing: status == 'Pending'
                              ? ElevatedButton(
                            onPressed: () => _updatePaymentStatus(bills[index]),
                            child: const Text("Mark as Paid"),
                          )
                              : const Icon(Icons.check_circle, color: Colors.green),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            if (services.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text("Total Bill: ₹${services.fold(0.0, (sum, item) => sum + item['cost'])}",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ElevatedButton(
              onPressed: _sendBillToOwner,
              child: const Text('Send Bill'),
            ),
          ],
        ),
      ),
    );
  }
}