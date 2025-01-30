import 'dart:convert';
import 'package:http/http.dart' as http;

class YouTubeService {
  final String apiKey = 'AIzaSyAvV6B_dWQlY7r1v0Ruw3-WaSm0XNHRe3g'; // Your API key

  // Method to fetch video title and thumbnail by video URL
  Future<Map<String, String>> fetchVideoDetails(String videoUrl) async {
    final videoId = extractVideoId(videoUrl);
    if (videoId == null) {
      throw Exception('Invalid YouTube URL');
    }

    // Request the video details from YouTube API
    final response = await http.get(
      Uri.parse(
          'https://www.googleapis.com/youtube/v3/videos?part=snippet&id=$videoId&key=$apiKey'
      ),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final snippet = data['items'][0]['snippet'];
      return {
        'title': snippet['title'],
        'thumbnail': snippet['thumbnails']['high']['url'], // High-resolution thumbnail
      };
    } else {
      throw Exception('Failed to fetch video details');
    }
  }

  // Helper method to extract the video ID from the YouTube URL
  String extractVideoId(String url) {
    final Uri uri = Uri.parse(url);
    if (uri.host == 'youtu.be') {
      return uri.pathSegments.isNotEmpty ? uri.pathSegments[0] : '';
    } else if (uri.host == 'www.youtube.com' && uri.path == '/watch') {
      return uri.queryParameters['v'] ?? '';
    }
    return '';
  }
}
