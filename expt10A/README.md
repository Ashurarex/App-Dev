# Flutter Calculator with Firestore

This is a minimal Flutter calculator app that saves calculation history to Firebase Firestore.

## Features
- Basic arithmetic: + - * /
- Simple expression evaluator (supports parentheses)
- Saves each calculation to Firestore with a timestamp
- Shows recent history (up to 50 items)

## Setup steps

1. Install Flutter SDK (stable).
2. Create a Firebase project in the Firebase Console: https://console.firebase.google.com/
3. Add an Android and/or iOS app in the Firebase project.
   - For Android, download the `google-services.json` file and place it at `android/app/google-services.json` in this project.
   - For iOS, download `GoogleService-Info.plist` and add it to Xcode Runner.
4. In `android/build.gradle` add `classpath 'com.google.gms:google-services:4.3.15'` in dependencies.
   In `android/app/build.gradle` apply plugin: `com.google.gms.google-services` at the bottom.
5. Add Firebase SDK initialization if you use generated Firebase options (optional). This project calls `Firebase.initializeApp()` which works once native config files are present.
6. Run `flutter pub get`.
7. Run on an emulator or device: `flutter run`.

## Firestore rules (for testing only)
```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /calculations/{docId} {
      allow read, write: if true;
    }
  }
}
```
**Important:** Do not use these permissive rules in production.

## Notes
- This project includes a placeholder `android/app/google-services.json` file (dummy). Replace it with your project's actual file.
- The expression evaluator is simple and intended for basic calculations only.
