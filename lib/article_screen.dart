import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:paw1/constant.dart';
import 'package:url_launcher/url_launcher.dart';

class ArticleScreen extends StatefulWidget {
  const ArticleScreen({Key? key}) : super(key: key);

  @override
  _ArticleScreenState createState() => _ArticleScreenState();
}

class _ArticleScreenState extends State<ArticleScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Method to fetch articles from Firestore
  Future<List<Map<String, String>>> fetchArticles() async {
    // Fetch data from Firestore
    QuerySnapshot querySnapshot = await _firestore.collection('article').get();

    // Map the documents to the expected format and return
    return querySnapshot.docs.map((doc) {
      return {
        'title': doc['title'] as String,  // Ensure it's a String
        'link': doc['link'] as String,    // Ensure it's a String
      };
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text('Articles'),
      ),
      body: FutureBuilder<List<Map<String, String>>>(
        future: fetchArticles(),  // Calling the fetchArticles method
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No articles found.'));
          } else {
            // Display the articles in Card view
            List<Map<String, String>> article = snapshot.data!;
            return ListView.builder(
              itemCount: article.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(15),
                    title: Text(article[index]['title'] ?? 'No Title'),
                    trailing: Icon(Icons.arrow_forward),
                    onTap: () {
                      _launchURL(article[index]['link']!); // Launch the corresponding link
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  // Function to launch the URL
  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }
}
