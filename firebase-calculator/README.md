# firebase_calc

A new Flutter project.

## Getting Started

# Flutter Calculator with Firebase Storage

## Overview
This is a Flutter calculator app that performs basic arithmetic operations like addition, subtraction, multiplication, and division. It integrates with Firebase to persist calculation history in Firestore, enabling cloud storage and real-time synchronization.

## Features
- Basic calculator functionality with a user-friendly interface.
- Stores calculation results and history in Firebase Firestore.
- Real-time data storage and retrieval via Firebase.
- Cross-platform support for Android and iOS devices.

## Setup Instructions
1. Clone the repository.
2. Create a Firebase project in the Firebase Console.
3. Enable Firestore in your Firebase project.
4. Add Firebase to your Flutter app by configuring the `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) files.
5. Add Firebase dependencies in `pubspec.yaml` and initialize Firebase in the app (`main.dart`).
6. Run `flutter pub get` to install dependencies.
7. Launch the app on emulator or physical device.
8. Use the calculator to perform operations; calculation history is automatically saved in Firebase Firestore.

## Technologies
- Flutter SDK for app development.
- Firebase Firestore for cloud data storage.

## Notes
Firebase allows seamless cloud integration for your Flutter app, providing scalable and real-time persistence. Be sure to secure your Firebase project and restrict database access appropriately.

