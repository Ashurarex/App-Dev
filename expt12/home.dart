import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatelessWidget {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
        Text('Welcome, \${user?.email ?? user?.phoneNumber ?? 'User'}'),
        SizedBox(height: 12),
        ElevatedButton(
          onPressed: () async {
            await _auth.signOut();
          },
          child: Text('Sign Out'),
        ),
      ])),
    );
  }
}
