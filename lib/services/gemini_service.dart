import 'dart:convert';
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  late final GenerativeModel _model;

  GeminiService() {
    _model = GenerativeModel(
      model: 'gemini-pro',
      apiKey: 'AIzaSyCK94NDavD7k0E2chGeS7DO2XKNN5mNSv4',
    );
  }

  Future<String> interpretMood(String prompt) async {
    try {
      final content = [
        Content.text(
          'Given the following mood or vibe description, provide a list of music genres and characteristics that would match this mood. '
          'Format the response as a JSON object with "genres" and "characteristics" arrays. '
          'Example response format: {"genres": ["pop", "rock"], "characteristics": ["upbeat", "energetic"]}. '
          'Mood description: $prompt',
        ),
      ];

      final response = await _model.generateContent(content);
      final responseText = response.text ?? '{"genres": [], "characteristics": []}';
      
      final jsonResponse = json.decode(responseText);
      
      final genres = (jsonResponse['genres'] as List?)?.join(' ') ?? '';
      final characteristics = (jsonResponse['characteristics'] as List?)?.join(' ') ?? '';
      
      return '$genres $characteristics'.trim();
    } catch (e) {
      print('Error interpreting mood: $e');
      return prompt;
    }
  }
} 