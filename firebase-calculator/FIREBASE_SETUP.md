# Firebase Setup Instructions

## Prerequisites
1. A Google account
2. Flutter SDK installed
3. Android Studio or VS Code with Flutter extensions

## Step 1: Create a Firebase Project
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Create a project" or "Add project"
3. Enter project name: `firebase-calc` (or any name you prefer)
4. Enable Google Analytics (optional)
5. Click "Create project"

## Step 2: Add Android App to Firebase
1. In your Firebase project, click "Add app" and select Android
2. Enter your Android package name: `com.example.firebase_calc`
3. Enter app nickname: `Firebase Calculator`
4. Click "Register app"

## Step 3: Download Configuration File
1. Download the `google-services.json` file
2. Place it in `android/app/` directory of your Flutter project

## Step 4: Enable Firestore Database
1. In Firebase Console, go to "Firestore Database"
2. Click "Create database"
3. Choose "Start in test mode" (for development)
4. Select a location for your database
5. Click "Done"

## Step 5: Update Android Configuration
1. Open `android/build.gradle.kts` (project level)
2. Add the following in the `dependencies` block:
```kotlin
dependencies {
    classpath("com.google.gms:google-services:4.4.0")
}
```

3. Open `android/app/build.gradle.kts`
4. Add at the top:
```kotlin
plugins {
    id("com.google.gms.google-services")
}
```

## Step 6: Test the App
1. Run `flutter pub get` to install dependencies
2. Run `flutter run` to start the app
3. Perform some calculations and check the HISTORY button
4. Verify calculations are saved in Firestore Database

## Security Rules (Optional)
For production, update Firestore security rules:
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /calculations/{document} {
      allow read, write: if true; // For development only
    }
  }
}
```

## Troubleshooting
- If you get Firebase initialization errors, make sure `google-services.json` is in the correct location
- Check that your package name matches the one in Firebase Console
- Ensure Firestore is enabled in your Firebase project
