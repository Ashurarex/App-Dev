# Firebase Setup Guide for Habit Tracker

## Step 1: Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click **"Add project"** or **"Create a project"**
3. Enter project name: `habit-tracker` (or any name you prefer)
4. Disable Google Analytics (optional, you can enable later)
5. Click **"Create project"**

## Step 2: Add Web App to Firebase

1. In your Firebase project, click the **Web icon** (`</>`) or **"Add app"** → **Web**
2. Register your app:
   - App nickname: `Habit Tracker Web`
   - Check "Also set up Firebase Hosting" (optional)
3. Click **"Register app"**
4. **Copy the Firebase configuration** - you'll see something like:

```javascript
const firebaseConfig = {
  apiKey: "AIza...",
  authDomain: "your-project.firebaseapp.com",
  projectId: "your-project-id",
  storageBucket: "your-project.appspot.com",
  messagingSenderId: "123456789",
  appId: "1:123456789:web:abc123"
};
```

## Step 3: Configure Firebase in Your Flutter App

### Option A: Using FlutterFire CLI (Recommended)

1. Install FlutterFire CLI:
   ```bash
   dart pub global activate flutterfire_cli
   ```

2. Run configuration:
   ```bash
   flutterfire configure
   ```
   
3. Select your Firebase project and platforms (web, android, ios)

4. This will automatically create `lib/firebase_options.dart`

### Option B: Manual Configuration (For Web)

1. Create `lib/firebase_options.dart`:
   ```dart
   import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
   import 'package:flutter/foundation.dart'
       show defaultTargetPlatform, kIsWeb, TargetPlatform;

   class DefaultFirebaseOptions {
     static FirebaseOptions get currentPlatform {
       if (kIsWeb) {
         return web;
       }
       switch (defaultTargetPlatform) {
         case TargetPlatform.android:
           return android;
         case TargetPlatform.iOS:
           return ios;
         default:
           throw UnsupportedError(
             'DefaultFirebaseOptions are not supported for this platform.',
           );
       }
     }

     static const FirebaseOptions web = FirebaseOptions(
       apiKey: 'YOUR_API_KEY',
       appId: 'YOUR_APP_ID',
       messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
       projectId: 'YOUR_PROJECT_ID',
       authDomain: 'YOUR_PROJECT_ID.firebaseapp.com',
       storageBucket: 'YOUR_PROJECT_ID.appspot.com',
     );

     static const FirebaseOptions android = FirebaseOptions(
       apiKey: 'YOUR_ANDROID_API_KEY',
       appId: 'YOUR_ANDROID_APP_ID',
       messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
       projectId: 'YOUR_PROJECT_ID',
       storageBucket: 'YOUR_PROJECT_ID.appspot.com',
     );

     static const FirebaseOptions ios = FirebaseOptions(
       apiKey: 'YOUR_IOS_API_KEY',
       appId: 'YOUR_IOS_APP_ID',
       messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
       projectId: 'YOUR_PROJECT_ID',
       storageBucket: 'YOUR_PROJECT_ID.appspot.com',
       iosBundleId: 'com.example.habitTracker',
     );
   }
   ```

2. Replace the placeholder values with your actual Firebase config values

3. Update `lib/main.dart`:
   ```dart
   import 'firebase_options.dart';
   
   void main() async {
     WidgetsFlutterBinding.ensureInitialized();
     await Firebase.initializeApp(
       options: DefaultFirebaseOptions.currentPlatform,
     );
     // ... rest of your code
   }
   ```

## Step 4: Enable Firebase Services

### Enable Authentication

1. In Firebase Console, go to **Authentication** → **Get started**
2. Enable **Email/Password** sign-in method:
   - Click "Email/Password"
   - Toggle "Enable"
   - Click "Save"
3. Enable **Google** sign-in method:
   - Click "Google"
   - Toggle "Enable"
   - Set support email
   - Click "Save"

### Enable Firestore Database

1. In Firebase Console, go to **Firestore Database** → **Create database**
2. Choose **"Start in test mode"** (for development)
3. Select a location (choose closest to your users)
4. Click **"Enable"**

**Important:** For production, update Firestore security rules:
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /habits/{habitId} {
      allow read, write: if request.auth != null && request.auth.uid == resource.data.userId;
    }
  }
}
```

## Step 5: Test Your Setup

1. Run your app:
   ```bash
   flutter run -d chrome
   ```

2. You should see the splash screen, then login screen
3. Try creating an account with email/password
4. Try signing in with Google

## Troubleshooting

- **White screen**: Check browser console (F12) for errors
- **Firebase not initialized**: Make sure `firebase_options.dart` exists and is imported
- **Auth not working**: Verify Authentication is enabled in Firebase Console
- **Database errors**: Check Firestore is enabled and rules are set

## Next Steps

- Add Android app: Firebase Console → Add app → Android
- Add iOS app: Firebase Console → Add app → iOS
- Configure OAuth for Google Sign-In (if needed)

