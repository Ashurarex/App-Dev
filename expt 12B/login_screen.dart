import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _authService = AuthService();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  final _phoneCtrl = TextEditingController();
  final _smsCtrl = TextEditingController();
  String? _verificationId;
  bool _isPhoneFlow = false;
  bool _loading = false;

  void _showSnack(String t) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t)));
  }

  Future<void> _loginEmail() async {
    setState(() => _loading = true);
    try {
      await _authService.signInWithEmail(_emailCtrl.text.trim(), _passCtrl.text.trim());
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      _showSnack(e.toString());
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _googleSignIn() async {
    setState(() => _loading = true);
    try {
      final userCred = await _authService.signInWithGoogle();
      if (userCred != null) {
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (e) {
      _showSnack(e.toString());
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _startPhoneFlow() async {
    setState(() => _isPhoneFlow = true);
    try {
      await _authService.verifyPhone(
        _phoneCtrl.text.trim(),
        codeSent: (verificationId, _) {
          _verificationId = verificationId;
          _showSnack('Code sent. Enter OTP.');
        },
        verificationFailed: (e) {
          _showSnack('Verification failed: ' + (e.message ?? e.code));
        },
        autoRetrieved: (vid) {
          _verificationId = vid;
        },
      );
    } catch (e) {
      _showSnack(e.toString());
    }
  }

  Future<void> _submitSms() async {
    if (_verificationId == null) {
      _showSnack('No verification id. Request code first.');
      return;
    }
    try {
      await _authService.signInWithSms(_verificationId!, _smsCtrl.text.trim());
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      _showSnack(e.toString());
    }
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _phoneCtrl.dispose();
    _smsCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),
                const Text('Login', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                const SizedBox(height: 24),
                // Email login
                TextField(
                  controller: _emailCtrl,
                  decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _passCtrl,
                  decoration: const InputDecoration(labelText: 'Password', border: OutlineInputBorder()),
                  obscureText: true,
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _loading ? null : _loginEmail,
                    child: _loading ? const CircularProgressIndicator() : const Text('Login'),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.pushNamed(context, '/signup'),
                  child: const Text('Don\'t have an account? Sign up'),
                ),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 8),
                // Google Sign-In
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: _loading ? null : _googleSignIn,
                    child: const Text('Sign in with Google'),
                  ),
                ),
                const SizedBox(height: 12),
                // Phone
                const Text('OR', style: TextStyle(fontWeight: FontWeight.w500)),
                const SizedBox(height: 12),
                if (!_isPhoneFlow) ...[
                  TextField(
                    controller: _phoneCtrl,
                    decoration: const InputDecoration(labelText: 'Phone (E.164, e.g. +911234567890)', border: OutlineInputBorder()),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: _startPhoneFlow,
                      child: const Text('Send OTP'),
                    ),
                  ),
                ] else ...[
                  TextField(
                    controller: _smsCtrl,
                    decoration: const InputDecoration(labelText: 'Enter OTP', border: OutlineInputBorder()),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: _submitSms,
                      child: const Text('Verify OTP'),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
