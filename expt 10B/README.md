# React Native ToDo List (Expo) + Firebase Firestore

This is a minimal React Native ToDo List app (Expo) that stores tasks in Firebase Firestore.

## Features
- Add, delete, and toggle done status of tasks
- Real-time sync with Firestore using onSnapshot
- Simple, clean UI
- Placeholder Firebase config — replace with your own project config

## Setup (quick)
1. Install Expo CLI: `npm install -g expo-cli`
2. Extract the project and run `npm install`
3. Create a Firebase Project in Firebase Console.
4. In the Firebase Console, add a **Web app** and copy the firebase config (apiKey, authDomain, projectId, etc.).
   Paste that object into `App.js` replacing the `firebaseConfig` placeholder.
5. Run `expo start` and open on your device or emulator.

## Firestore rules (for development only)
```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /todos/{docId} {
      allow read, write: if true;
    }
  }
}
```
**Important:** These rules are permissive and only for testing. Do not use in production.

## Notes
- This project uses the modular Firebase JS SDK (v9+) which works in Expo-managed workflow.
- Replace the firebaseConfig in `App.js` with your project's config.
