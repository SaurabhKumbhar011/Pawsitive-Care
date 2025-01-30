import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:paw1/apis/youtube_api.dart';
import 'package:paw1/constant.dart'; // Ensure you have this file for primaryColor
import 'package:url_launcher/url_launcher.dart'; // Import your API service

class YoutubeScreen extends StatefulWidget {
  const YoutubeScreen({Key? key}) : super(key: key);

  @override
  _YoutubeScreenState createState() => _YoutubeScreenState();
}

class _YoutubeScreenState extends State<YoutubeScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Method to fetch video URLs from Firestore
  Future<List<String>> fetchVideoUrls() async {
    QuerySnapshot querySnapshot = await _firestore.collection('videos').get();
    return querySnapshot.docs.map((doc) => doc['url'] as String).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text('YouTube Videos'),
      ),
      body: FutureBuilder<List<String>>(
        future: fetchVideoUrls(),  // Fetch video URLs from Firestore
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No videos found.'));
          } else {
            List<String> video = snapshot.data!;
            return ListView.builder(
              itemCount: video.length,
              itemBuilder: (context, index) {
                return FutureBuilder<Map<String, String>>(
                  future: YouTubeService().fetchVideoDetails(video[index]), // Fetch video details for each URL
                  builder: (context, videoSnapshot) {
                    if (videoSnapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (videoSnapshot.hasError) {
                      return Center(child: Text('Error: ${videoSnapshot.error}'));
                    } else if (!videoSnapshot.hasData) {
                      return const Center(child: Text('No data available'));
                    } else {
                      final data = videoSnapshot.data!;
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          elevation: 4,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12.0),  // Border radius for the thumbnail
                                child: Image.network(
                                  data['thumbnail']!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  data['title']!,
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: primaryColor,  // Background color for button
                                  ),
                                  onPressed: () {
                                    // Navigate to the YouTube video in the browser
                                    _launchURL(video[index]);
                                  },
                                  child: const Text('Watch on YouTube', style: TextStyle(color: Colors.white),),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                  },
                );
              },
            );
          }
        },
      ),
    );
  }

  // Function to launch the YouTube video in the browser
  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }
}
