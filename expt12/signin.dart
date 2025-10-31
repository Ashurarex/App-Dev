import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'signup.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  final AuthService _auth = AuthService();
  bool loading = false;
  String? error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign In')),
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
                await _auth.signInWithEmail(_email.text.trim(), _password.text.trim());
              } catch (e) {
                setState(() { error = e.toString(); });
              } finally {
                setState(() { loading = false; });
              }
            },
            child: loading ? CircularProgressIndicator() : Text('Sign In'),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => SignUpScreen()));
            },
            child: Text('Create account'),
          ),
          SizedBox(height: 12),
          ElevatedButton.icon(
            icon: Icon(Icons.login),
            label: Text('Sign in with Google'),
            onPressed: () async {
              try {
                final cred = await _auth.signInWithGoogle();
                if (cred == null) {
                  // user cancelled
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Google sign-in failed: \$e')));
              }
            },
          ),
          SizedBox(height: 8),
          ElevatedButton.icon(
            icon: Icon(Icons.phone),
            label: Text('Sign in with Phone'),
            onPressed: () {
              _showPhoneDialog(context);
            },
          ),
        ]),
      ),
    );
  }

  void _showPhoneDialog(BuildContext context) {
    final phoneController = TextEditingController();
    final codeController = TextEditingController();
    String? verificationId;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Phone Sign In'),
        content: StatefulBuilder(builder: (context, setState) {
          return Column(mainAxisSize: MainAxisSize.min, children: [
            TextField(controller: phoneController, decoration: InputDecoration(labelText: '+91xxxxxxxxxx')),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: () async {
                await _auth.verifyPhone(
                  phone: phoneController.text.trim(),
                  onVerified: (credential) async {
                    try {
                      await _auth.signInWithSmsCode(credential.verificationId ?? '', credential.smsCode ?? '');
                      Navigator.of(context).pop();
                    } catch (e) {}
                  },
                  onFailed: (e) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed: \${e.message}')));
                  },
                  onCodeSent: (verId, _) {
                    setState(() { verificationId = verId; });
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Code sent')));
                  },
                  onAutoRetrievalTimeout: (verId) {
                    verificationId = verId;
                  },
                );
              },
              child: Text('Send code'),
            ),
            if (verificationId != null) ...[
              SizedBox(height: 8),
              TextField(controller: codeController, decoration: InputDecoration(labelText: 'SMS Code')),
              ElevatedButton(
                onPressed: () async {
                  try {
                    await _auth.signInWithSmsCode(verificationId!, codeController.text.trim());
                    Navigator.of(context).pop();
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Code sign-in failed: \$e')));
                  }
                },
                child: Text('Verify code'),
              )
            ]
          ]);
        }),
      ),
    );
  }
}
