# Firebase Backend Setup - Step by Step Guide

Follow these steps to set up Firebase for your Habit Tracker app.

## Part 1: Create Firebase Project

### Step 1: Go to Firebase Console
1. Open your browser and go to: https://console.firebase.google.com/
2. Sign in with your Google account (or create one if needed)

### Step 2: Create a New Project
1. Click **"Add project"** or **"Create a project"** button
2. Enter project name: `habit-tracker` (or any name you like)
3. Click **"Continue"**
4. **Google Analytics** (optional):
   - You can disable it for now by toggling it off
   - Or enable it if you want analytics
5. Click **"Create project"**
6. Wait for project creation (takes ~30 seconds)
7. Click **"Continue"** when done

## Part 2: Add Web App to Firebase

### Step 3: Register Web App
1. In your Firebase project dashboard, you'll see icons for different platforms
2. Click the **Web icon** (`</>`) or click **"Add app"** → **Web**
3. Register your app:
   - **App nickname**: `Habit Tracker Web` (or any name)
   - **Firebase Hosting**: Leave unchecked for now (optional)
4. Click **"Register app"**

### Step 4: Copy Firebase Configuration
You'll see a screen with your Firebase config. It looks like this:

```javascript
const firebaseConfig = {
  apiKey: "AIzaSyXXXXXXXXXXXXXXXXXXXXXXXXXXXXX",
  authDomain: "your-project-id.firebaseapp.com",
  projectId: "your-project-id",
  storageBucket: "your-project-id.appspot.com",
  messagingSenderId: "123456789012",
  appId: "1:123456789012:web:abcdef1234567890"
};
```

**IMPORTANT**: Keep this page open or copy these values - you'll need them!

## Part 3: Enable Firebase Services

### Step 5: Enable Authentication

1. In Firebase Console, click **"Authentication"** in the left sidebar
2. Click **"Get started"** button
3. Go to **"Sign-in method"** tab
4. Enable **Email/Password**:
   - Click on **"Email/Password"**
   - Toggle **"Enable"** to ON
   - Click **"Save"**
5. Enable **Google** sign-in:
   - Click on **"Google"**
   - Toggle **"Enable"** to ON
   - Enter a **Project support email** (your email)
   - Click **"Save"**

### Step 6: Enable Firestore Database

1. In Firebase Console, click **"Firestore Database"** in the left sidebar
2. Click **"Create database"** button
3. Choose **"Start in test mode"** (for development)
   - ⚠️ **Note**: This allows anyone to read/write. For production, you'll need security rules.
4. Click **"Next"**
5. Select a **location** (choose the one closest to your users)
   - Example: `us-central` or `europe-west`
6. Click **"Enable"**
7. Wait for database creation (~1 minute)

## Part 4: Configure Flutter App

### Step 7: Install FlutterFire CLI

Open your terminal/PowerShell in the project directory and run:

```bash
dart pub global activate flutterfire_cli
```

If you get a PATH error, add Flutter to your PATH or use:
```bash
flutter pub global activate flutterfire_cli
```

### Step 8: Run FlutterFire Configuration

```bash
flutterfire configure
```

This will:
1. Ask you to sign in to Firebase (opens browser)
2. Show list of your Firebase projects
3. Ask you to select a project (choose the one you just created)
4. Ask which platforms to configure:
   - Select: **web**, **android**, **ios** (or just web if you only need web)
5. Automatically create `lib/firebase_options.dart` with your config

**If flutterfire configure doesn't work**, see Manual Setup below.

## Part 5: Verify Setup

### Step 9: Check Generated File

After running `flutterfire configure`, you should see:
- `lib/firebase_options.dart` file created
- File contains your Firebase configuration

### Step 10: Test Your App

1. Run your app:
   ```bash
   flutter run -d chrome
   ```

2. You should see:
   - Splash screen
   - Login screen (not white screen!)
   - No Firebase errors in console

3. Try creating an account:
   - Enter email and password
   - Click "Create account"
   - Should work without errors!

## Manual Setup (If FlutterFire CLI doesn't work)

If `flutterfire configure` doesn't work, you can set up manually:

### Option A: Create firebase_options.dart manually

1. Create file: `lib/firebase_options.dart`
2. Copy this template and fill in your values from Step 4:

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
    apiKey: 'YOUR_API_KEY_HERE',
    appId: 'YOUR_APP_ID_HERE',
    messagingSenderId: 'YOUR_MESSAGING_SENDER_ID_HERE',
    projectId: 'YOUR_PROJECT_ID_HERE',
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

3. Replace all `YOUR_XXX_HERE` with values from Step 4

4. Update `lib/main.dart` to use it:

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

## Security Rules (Important for Production)

### Firestore Security Rules

Go to **Firestore Database** → **Rules** tab and update:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can only read/write their own habits
    match /habits/{habitId} {
      allow read, write: if request.auth != null 
        && request.auth.uid == resource.data.userId;
    }
  }
}
```

Click **"Publish"** to save rules.

## Troubleshooting

### Problem: White screen
- **Solution**: Check browser console (F12) for errors
- Make sure Firebase is initialized properly

### Problem: "Firebase not initialized"
- **Solution**: Make sure `firebase_options.dart` exists and is imported

### Problem: "Permission denied" in Firestore
- **Solution**: Check Firestore security rules (see above)

### Problem: Google Sign-In not working
- **Solution**: Make sure Google sign-in is enabled in Firebase Console
- Check that OAuth consent screen is configured (if needed)

### Problem: Can't run `flutterfire configure`
- **Solution**: Use manual setup (see Option A above)

## Next Steps

Once Firebase is set up:
1. ✅ Test email/password sign-up
2. ✅ Test email/password sign-in
3. ✅ Test Google sign-in
4. ✅ Create a habit (should save to Firestore)
5. ✅ View your habits in Firebase Console → Firestore Database

## Need Help?

- Firebase Docs: https://firebase.google.com/docs/flutter/setup
- FlutterFire Docs: https://firebase.flutter.dev/
- Check browser console (F12) for detailed error messages

---

**You're all set!** 🎉 Your Habit Tracker app now has a Firebase backend!

