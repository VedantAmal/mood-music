# Mood Music - AI-Powered Music Playlist Generator

A Flutter application that uses Google's Gemini AI to interpret your mood and generate personalized music playlists using Spotify's API.

## 🎵 Features

- **Mood Interpretation**: Enter how you're feeling, and Gemini AI will interpret it into music characteristics
- **Smart Playlist Generation**: Get personalized playlists based on your mood
- **Beautiful UI**: Modern, responsive interface with dark theme support
- **Track Details**: View track information including:
  - Album artwork
  - Artist name
  - Track title
  - Preview URL (coming soon)

## 🛠️ Technology Stack

- **Frontend**: Flutter
- **State Management**: Flutter Riverpod
- **AI Integration**: Google Gemini AI
- **Music API**: Spotify Web API
- **Image Caching**: Cached Network Image
- **Secure Storage**: Flutter Secure Storage

## 📋 Prerequisites

- Flutter SDK (latest version)
- Dart SDK (latest version)
- Spotify Developer Account
- Google Cloud Account (for Gemini AI)

## 🔧 Setup Instructions

1. **Clone the repository**
   ```bash
   git clone https://github.com/VedantAmal/mood-music.git
   cd mood-music
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure API Keys**
   - API keys are hardcoded in the code for now.
   - Add your API keys:
     ```
     SPOTIFY_CLIENT_ID=your_spotify_client_id
     SPOTIFY_CLIENT_SECRET=your_spotify_client_secret
     GEMINI_API_KEY=your_gemini_api_key
     ```

4. **Run the app**
   ```bash
   flutter run
   ```

## 🚀 Getting Started

1. Launch the app
2. Enter your mood or how you're feeling in the text field
   - Example: "I want to feel energized and motivated"
   - Example: "I'm feeling sad and need some comfort"
3. Click "Generate Playlist"
4. Browse through the generated tracks

## 📱 Screenshots
<img width="318" alt="home-screen" src="https://github.com/user-attachments/assets/749a7e33-0181-4224-ac8b-533585250908" />
<img width="329" alt="playlist-results" src="https://github.com/user-attachments/assets/20250229-dffb-429d-983e-f2047487a00a" />




## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

