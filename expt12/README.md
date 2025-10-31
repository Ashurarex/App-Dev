# Flutter Firebase Auth Demo (minimal)

This is a minimal Flutter project skeleton demonstrating Firebase Authentication flows:
- Email / Password (implemented)
- Google Sign-In (implemented; requires SHA-1 and OAuth setup)
- Phone Auth (verification flow scaffolded)

## Setup
1. Install Flutter and Android Studio.
2. Create a Firebase project and enable Authentication providers (Email/Password, Google, Phone).
3. Add an Android app in Firebase with the package name you will use.
4. Download `google-services.json` and place it in `android/app/` (replace the placeholder file).
5. Add SHA-1 to Firebase console for Google Sign-In.
6. Run:
   ```
   flutter pub get
   flutter run
   ```

Note: `lib/main.dart` contains a simple StreamBuilder placeholder. Replace the `stream: null` with:
```
stream: FirebaseAuth.instance.authStateChanges(),
```
and `await Firebase.initializeApp()` may require `firebase_options.dart` if you used `flutterfire configure`.

