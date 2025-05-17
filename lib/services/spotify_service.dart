import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:music/models/track.dart';

class SpotifyService {
  final String _clientId = 'da92c9e5f5274ee585a862cbe9084bfc';
  final String _clientSecret = '369a31c0c2dd48f58aebb9556ba12753';
  final _storage = const FlutterSecureStorage();
  static const _tokenKey = 'spotify_token';
  String? _accessToken;

  SpotifyService() {
    _getAccessToken();
  }

  Future<void> _getAccessToken() async {
    try {
      final response = await http.post(
        Uri.parse('https://accounts.spotify.com/api/token'),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'grant_type': 'client_credentials',
          'client_id': _clientId,
          'client_secret': _clientSecret,
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _accessToken = data['access_token'];
      } else {
        print('Error getting access token: ${response.body}');
      }
    } catch (e) {
      print('Error getting access token: $e');
    }
  }

  Future<List<Track>> getMoodBasedTracks(String mood) async {
    try {
      if (_accessToken == null) {
        await _getAccessToken();
      }

      print('Searching for tracks with mood: $mood');
      
      final response = await http.get(
        Uri.parse('https://api.spotify.com/v1/search?q=$mood&type=track&limit=20'),
        headers: {
          'Authorization': 'Bearer $_accessToken',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final tracks = <Track>[];

        for (var item in data['tracks']['items']) {
          try {
            final track = Track(
              id: item['id'] ?? '',
              name: item['name'] ?? 'Unknown Track',
              artist: item['artists'][0]['name'] ?? 'Unknown Artist',
              albumArt: item['album']['images'][0]['url'] ?? '',
              previewUrl: item['preview_url'] ?? '',
            );
            tracks.add(track);
          } catch (e) {
            print('Error converting track: $e');
          }
        }

        print('Found ${tracks.length} tracks');
        return tracks;
      } else {
        print('Error searching tracks: ${response.body}');
        return [];
      }
    } catch (e) {
      print('Error searching tracks: $e');
      return [];
    }
  }

  Future<void> createPlaylist(String name, List<Track> tracks) async {
    try {
    } catch (e) {
      print('Error creating playlist: $e');
    }
  }
} 