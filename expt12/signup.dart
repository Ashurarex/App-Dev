import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpScreen extends StatefulWidget {
  final VoidCallback? onSignedUp;
  SignUpScreen({this.onSignedUp});
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _auth = AuthService();
  bool loading = false;
  String? error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: [
          TextField(controller: _email, decoration: InputDecoration(labelText: 'Email')),
          SizedBox(height: 8),
          TextField(controller: _password, decoration: InputDecoration(labelText: 'Password'), obscureText: true),
          SizedBox(height: 16),
          if (error != null) Text(error!, style: TextStyle(color: Colors.red)),
          ElevatedButton(
            onPressed: loading ? null : () async {
              setState(() { loading = true; error = null; });
              try {
                await _auth.signUpWithEmail(_email.text.trim(), _password.text.trim());
                widget.onSignedUp?.call();
              } on FirebaseAuthException catch (e) {
                setState(() { error = e.message; });
              } finally {
                setState(() { loading = false; });
              }
            },
            child: loading ? CircularProgressIndicator() : Text('Create Account'),
          ),
        ]),
      ),
    );
  }
}
