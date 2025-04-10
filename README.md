# Muslim Helper App

## Introduction
The **Muslim Helper App** is a Flutter-based mobile application designed to support Muslims in their daily spiritual practices. It provides a range of essential features including a Hadith reader, nearest Masjid locator, accurate prayer times based on location, and Firebase Authentication for secure user access.

## Setup Instructions

### Prerequisites
Ensure you have the following installed:
- Flutter SDK
- Dart
- Android Studio/Xcode (for mobile development)
- A GitHub account with repository access

### Installation Steps
1. Clone the repository:
   git clone https://github.com/muhdhafiizz/muslim-companion-app.git
2. cd muslim-companion-app
3. flutter pub get
4. flutter run

## Architecture Overview
The app follows the Clean Architecture principle and uses Provider for state management.

### Layers:
Presentation Layer: UI components built using Flutter widgets.

Application Layer: Contains business logic and manages app state using Provider.

Data Layer: Responsible for API integrations and local data management.

### Technologies Used
State Management: Provider

Authentication: Firebase Authentication

Location Services: geolocator & Google Maps API

Networking: HTTP

Local Storage: SharedPreferences (optional)

### Features
🔐 Firebase Authentication: Sign in and register with email & password.

📖 Hadith Reader: Browse and read authenticated Hadiths.

🕌 Nearest Masjid Locator: Find Masjids near your current location.

🕋 Prayer Times: Automatically detect and show accurate prayer times based on your location.

🌙 Islamic UI: Clean and user-friendly design with a spiritual touch.

## Future Improvements
Add Quran reader with audio and tafsir support.

Implement dark mode for better night-time usability.

Add support for multilingual content.
