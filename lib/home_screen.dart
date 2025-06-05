import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'package:paw1/User/UserProfile.dart';
import 'package:paw1/petbilling.dart';
import 'package:paw1/veterinary/VeterinarianDetailsPage.dart';
import 'User/AppointmentScreen.dart';
import 'YoutubeScreen.dart';
import 'article_screen.dart';
import 'default_widget.dart';
import 'petprofile_screen.dart';
import 'constant.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0; // Current index for BottomNavigationBar

  // Screens for BottomNavigationBar
  final List<Widget> _screens = [
    HomeContent(),
    AppointmentScreen(),
    PetBillingScreen(),
    UserProfile(),

  ];
//-----------------------------------------------Bottom Navigation Bar-----------------------------------------
  Future<bool> _onWillPop() async {
    // Prevent navigating back to the login screen
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: _screens[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month),
              label: 'Appointment',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.payments),
              label: 'Payment',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
          currentIndex: _currentIndex,
          selectedItemColor: primaryColor,
          unselectedItemColor: Colors.grey,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          backgroundColor: primaryColor,
          centerTitle: false,
          title: RichText(
            text: const TextSpan(
              children: [
                TextSpan(
                  text: 'Hi \n',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: 'Welcome!',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ],
              style: TextStyle(
                fontSize: 20,
                color: Colors.black87,
              ),
            ),
          ),
        ),
        // Pet Profile Section
        SliverList(
          delegate: SliverChildListDelegate([
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: primaryColor,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    spreadRadius: 3,
                    offset: Offset(0, 10),
                  ),
                ],
                image: const DecorationImage(
                  image: AssetImage('images/panel.png'),
                  alignment: Alignment.centerRight,
                ),
              ),
              height: 170,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Care \nYour Pet',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      height: 1,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      String emailId =
                          FirebaseAuth.instance.currentUser?.email ??
                              'No email found';
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              PetProfileScreen(emailId: emailId),
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(top: 10),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            spreadRadius: 3,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: const Text(
                        'Pet Profile',
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ]),
        ),
        SliverToBoxAdapter(
          child: Container(
            padding: const EdgeInsets.only(left: 16, top: 6, bottom: 12),
            // padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Category',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(left: 16, top: 6, bottom: 16, right: 8),
            child: Row(
              children: [
                Expanded(
                  child: GridOption(
                    image: 'images/article (1).png',
                    title: 'Articles',
                    isSelected: true,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ArticleScreen(),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 2),
                Expanded(
                  child: GridOption(
                    image: 'images/yt.png',
                    title: 'Videos',
                    isSelected: true,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => YoutubeScreen(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),

        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 14),
            child: Text(
              'Available Veterinary',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
        ),

        // Available Veterinary
        SliverFillRemaining(
          hasScrollBody: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 6),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              color: primaryColor,
              child: InkWell(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    builder: (context) => DraggableScrollableSheet(
                      expand: false,
                      initialChildSize: 0.75,
                      minChildSize: 0.4,
                      maxChildSize: 0.95,
                      builder: (context, scrollController) => Container(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Text(
                              'Nearby Veterinary',
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            const SizedBox(height: 10),
                            Expanded(
                              child: DoctorList(scrollController: scrollController),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(20),
                child: Stack(
                  children: [
                    // Background image using DecorationImage
                    Positioned(
                      left: 115,
                      top: 0,
                      bottom: 30,
                      child: Container(
                        width: 225,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          image: const DecorationImage(
                            image: AssetImage('images/clinic2.png'),
                            fit: BoxFit.contain,
                            alignment: Alignment.center,
                          ),
                        ),
                      ),
                    ),
                    // Text at bottom-left
                    const Positioned(
                      left: 16,
                      bottom: 16,
                      child: Text(
                        'View\nAvailable Vets',
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        )


      ],
    );
  }
}


// class DoctorList extends StatelessWidget {
//   final Stream<QuerySnapshot> _listStream =
//   FirebaseFirestore.instance.collection('veterinarians').snapshots();
//
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<QuerySnapshot>(
//       stream: _listStream,
//       builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(child: CircularProgressIndicator());
//         }
//         if (snapshot.hasError) {
//           return Center(child: Text('Error: ${snapshot.error}'));
//         }
//
//         final vetDocs = snapshot.data!.docs;
//
//         return ListView.builder(
//           itemCount: vetDocs.length,
//           itemBuilder: (context, index) {
//             final vetData = vetDocs[index].data() as Map<String, dynamic>;
//             final String name = vetData['fullName'] ?? 'Unknown';
//             final String specialty =
//                 vetData['specializations'] ?? 'Specialty Not Available';
//             final String imageUrl =
//                 vetData['imageUrl'] ?? 'images/dr.png'; // Base64 URL
//
//             return DrListContainer(
//               name: name,
//               specialty: specialty,
//               imageUrl: imageUrl,
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) =>
//                         VeterinarianDetailsPage(vetId: vetDocs[index].id),
//                   ),
//                 );
//               },
//             );
//           },
//         );
//       },
//     );
//   }
// }

//Nearby veterinary fetching by tracing users live location only

class DoctorList extends StatefulWidget {
  final ScrollController? scrollController;

  const DoctorList({this.scrollController});

  @override
  _DoctorListState createState() => _DoctorListState();
}

class _DoctorListState extends State<DoctorList> {
  LocationData? _userLocation;
  final Location location = Location();
  List<DocumentSnapshot> _nearbyVets = [];
  List<DocumentSnapshot> _allVets = [];

  bool _showNearby = true;
  bool _locationEnabled = true;

  @override
  void initState() {
    super.initState();
    _initLocationAndFetchVets();
    _fetchAllVets();
  }

  Future<void> _initLocationAndFetchVets() async {
    final userLoc = await _getUserLocation();
    if (userLoc != null) {
      setState(() {
        _userLocation = userLoc;
        _showNearby = true;
        _locationEnabled = true;
      });
      _fetchNearbyVets(userLoc);
    } else {
      setState(() {
        _locationEnabled = false;
        _showNearby = false; // fallback to show all vets
      });
    }
  }

  Future<LocationData?> _getUserLocation() async {
    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) return null;
    }

    PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) return null;
    }

    return await location.getLocation();
  }

  Future<void> _fetchNearbyVets(LocationData userLoc) async {
    final snapshot =
    await FirebaseFirestore.instance.collection('veterinarians').get();

    List<DocumentSnapshot> filtered = [];

    for (var doc in snapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;

      if (data.containsKey('location')) {
        final location = data['location'] as Map<String, dynamic>;

        if (location.containsKey('latitude') &&
            location.containsKey('longitude')) {
          final double vetLat = location['latitude'];
          final double vetLng = location['longitude'];

          final double distanceInKm = Geolocator.distanceBetween(
            userLoc.latitude!,
            userLoc.longitude!,
            vetLat,
            vetLng,
          ) /
              1000;

          if (distanceInKm <= 10) {
            filtered.add(doc);
          }
        }
      }
    }

    setState(() {
      _nearbyVets = filtered;
    });
  }

  Future<void> _fetchAllVets() async {
    final snapshot =
    await FirebaseFirestore.instance.collection('veterinarians').get();
    setState(() {
      _allVets = snapshot.docs;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<DocumentSnapshot> displayList =
    _showNearby ? _nearbyVets : _allVets;

    if (_showNearby && _userLocation == null && _nearbyVets.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (displayList.isEmpty) {
      return const Center(child: Text('No veterinarians found.'));
    }

    return Column(
      children: [
        if (_locationEnabled)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Show Nearby"),
              Switch(
                value: _showNearby,
                onChanged: (value) {
                  setState(() {
                    _showNearby = value;
                  });
                },
              ),
            ],
          ),
        if (!_locationEnabled)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              'Location not enabled. Showing all veterinarians.',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
        Expanded(
          child: ListView.builder(
            controller: widget.scrollController,
            itemCount: displayList.length,
            itemBuilder: (context, index) {
              final vetData =
              displayList[index].data() as Map<String, dynamic>;
              final String name = vetData['fullName'] ?? 'Unknown';
              final String specialty =
                  vetData['specializations'] ?? 'Not Available';
              final String imageUrl = vetData['imageUrl'] ?? '';

              return DrListContainer(
                name: name,
                specialty: specialty,
                imageUrl: imageUrl,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VeterinarianDetailsPage(
                        vetId: displayList[index].id,
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}





class DrListContainer extends StatelessWidget {
  final String name;
  final String specialty;
  final String imageUrl;
  final VoidCallback onPressed;

  const DrListContainer({
    Key? key,
    required this.name,
    required this.specialty,
    required this.imageUrl,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: secondryColor,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 5,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[300],
              image: DecorationImage(
                image: MemoryImage(base64Decode(imageUrl)),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  specialty,
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 40,
            child: Container(
              decoration: BoxDecoration(
                color: primaryColor,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.chevron_right, color: Colors.white),
                onPressed: onPressed,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GridOption extends StatelessWidget {
  const GridOption({
    Key? key,
    required this.image,
    required this.title,
    this.isSelected = false,
    required this.onTap,
  }) : super(key: key);

  final String image;
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: isSelected ? primaryColor : secondryColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 3,
            ),
          ],
        ),
        width: 100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              image,
              width: 50,
              height: 50,
            ),
            const SizedBox(height: 5),
            Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

