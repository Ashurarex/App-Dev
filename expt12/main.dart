import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/signin.dart';
import 'screens/home.dart';
// If you used FlutterFire CLI, uncomment the import below and the initializeApp options.
// import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    // options: DefaultFirebaseOptions.currentPlatform, // uncomment if using flutterfire configure
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Auth Demo',
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: AuthGate(),
    );
  }
}

class AuthGate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: null, // replace with FirebaseAuth.instance.authStateChanges()
      builder: (context, snapshot) {
        // This simple scaffold assumes not-signed-in state. Replace stream with FirebaseAuth.
        return SignInScreen();
      },
    );
  }
}
