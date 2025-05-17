import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music/services/spotify_service.dart';
import 'package:music/services/gemini_service.dart';
import 'package:music/models/track.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _moodController = TextEditingController();
  final _spotifyService = SpotifyService();
  final _geminiService = GeminiService();
  bool _isLoading = false;
  String _errorMessage = '';
  List<Track> _tracks = [];
  String _currentMood = '';

  @override
  void dispose() {
    _moodController.dispose();
    super.dispose();
  }

  Future<void> _generatePlaylist() async {
    if (_moodController.text.isEmpty) {
      setState(() => _errorMessage = 'Please enter a mood or vibe');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
      _tracks = [];
      _currentMood = _moodController.text;
    });

    try {
      final moodInterpretation = await _geminiService.interpretMood(_currentMood);
      print('Mood interpretation: $moodInterpretation');

      final tracks = await _spotifyService.getMoodBasedTracks(moodInterpretation);
      
      if (tracks.isEmpty) {
        setState(() => _errorMessage = 'No tracks found for this mood. Try a different description.');
      } else {
        setState(() => _tracks = tracks);
      }
    } catch (e) {
      setState(() => _errorMessage = 'Error: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mood Music'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _moodController,
              decoration: const InputDecoration(
                labelText: 'What is your mood?',
                hintText: 'e.g., "Happy and Jolly"',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              enabled: !_isLoading,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isLoading ? null : _generatePlaylist,
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    )
                  : const Text('Generate Playlist'),
            ),
            if (_errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(
                  _errorMessage,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              ),
            const SizedBox(height: 24),
            if (_tracks.isNotEmpty) ...[
              Text(
                'Playlist for: $_currentMood',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: _tracks.length,
                  itemBuilder: (context, index) {
                    final track = _tracks[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: CachedNetworkImage(
                            imageUrl: track.albumArt,
                            width: 56,
                            height: 56,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => const Center(
                              child: CircularProgressIndicator(),
                            ),
                            errorWidget: (context, url, error) => const Icon(Icons.error),
                          ),
                        ),
                        title: Text(track.name),
                        subtitle: Text(track.artist),
                        trailing: IconButton(
                          icon: const Icon(Icons.play_arrow),
                          onPressed: () {
                            // TODO: Implement track preview playback
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
} 