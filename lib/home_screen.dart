import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:paw1/User/UserProfile.dart';
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
                  image: AssetImage('images/community-bg.png'),
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
                      fontSize: 22,
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
                        style: TextStyle(fontSize: 12, color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ]),
        ),
        sliverList(
          child: Container(
            padding: const EdgeInsets.only(left: 16,top: 8,bottom: 8),
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Category',
                      style: Theme.of(context).textTheme.titleLarge, // Updated property
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        sliverList(
          child: SizedBox(
            height: 120,
            child: ListView(
              shrinkWrap: true,
              primary: false,
              padding: const EdgeInsets.all(0),
              scrollDirection: Axis.horizontal,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Container(
                    width: 180,
                    child: GridOption(
                      image: 'images/vet.png',
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
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Container(
                    width: 180,
                    child: GridOption(
                      image: 'images/youtube.png',
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
                ),
              ],
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildListDelegate([
            Container(
              padding: const EdgeInsets.only(left: 20,right: 20,top: 8),
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Available Veterinary',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 240,
                    child: DoctorList(),
                  ),
                ],
              ),
            ),
          ]),
        ),
      ],
    );
  }
}

class DoctorList extends StatelessWidget {
  final Stream<QuerySnapshot> _listStream =
  FirebaseFirestore.instance.collection('veterinarians').snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _listStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final vetDocs = snapshot.data!.docs;

        return ListView.builder(
          itemCount: vetDocs.length,
          itemBuilder: (context, index) {
            final vetData = vetDocs[index].data() as Map<String, dynamic>;
            final String name = vetData['fullName'] ?? 'Unknown';
            final String specialty =
                vetData['specializations'] ?? 'Specialty Not Available';
            final String imageUrl =
                vetData['imageUrl'] ?? 'images/dr.png'; // Base64 URL

            return DrListContainer(
              name: name,
              specialty: specialty,
              imageUrl: imageUrl,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        VeterinarianDetailsPage(vetId: vetDocs[index].id),
                  ),
                );
              },
            );
          },
        );
      },
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

