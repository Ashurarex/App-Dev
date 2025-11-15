import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_service.dart';
import '../utils/validators.dart';
import '../constants/app_theme.dart';
import 'package:flutter_animate/flutter_animate.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  bool _rememberMe = false;
  final TextEditingController _emailController = TextEditingController();

  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _loadRememberMe();
  }

  Future<void> _loadRememberMe() async {
    final prefs = await SharedPreferences.getInstance();
    _rememberMe = prefs.getBool('remember_me') ?? false;
    if (_rememberMe) {
      _email = prefs.getString('remember_email') ?? '';
      _emailController.text = _email;
    }
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context, listen: false);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [
                    const Color(0xFF0F172A),
                    const Color(0xFF1E293B),
                  ]
                : [
                    const Color(0xFFF8FAFC),
                    const Color(0xFFFFFFFF),
                  ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 40),
                    // Logo/Icon
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [AppTheme.primary, AppTheme.secondary],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primary.withOpacity(0.3),
                            blurRadius: 20,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.login_rounded,
                        size: 40,
                        color: Colors.white,
                      ),
                    )
                        .animate()
                        .scale(delay: 100.ms, duration: 500.ms)
                        .fadeIn(duration: 400.ms),
                    const SizedBox(height: 32),
                    const Text(
                      'Welcome back',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    )
                        .animate()
                        .fadeIn(delay: 200.ms, duration: 600.ms)
                        .moveY(begin: 20, end: 0, duration: 600.ms),
                    const SizedBox(height: 8),
                    Text(
                      'Sign in to continue your journey',
                      style: TextStyle(
                        fontSize: 16,
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                        fontWeight: FontWeight.w400,
                      ),
                    )
                        .animate()
                        .fadeIn(delay: 300.ms, duration: 600.ms)
                        .moveY(begin: 20, end: 0, duration: 600.ms),
                    const SizedBox(height: 40),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Email',
                              prefixIcon: const Icon(Icons.email_outlined),
                              suffixIcon: Icon(
                                Icons.check_circle,
                                color: _email.isNotEmpty && _email.contains('@')
                                    ? AppTheme.success
                                    : Colors.transparent,
                              ),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            validator: emailValidator,
                            controller: _emailController,
                            onChanged: (v) => setState(() => _email = v),
                            onSaved: (v) => _email = v ?? '',
                          )
                              .animate()
                              .fadeIn(delay: 400.ms, duration: 600.ms)
                              .moveX(begin: -20, end: 0, duration: 600.ms),
                          const SizedBox(height: 20),
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Password',
                              prefixIcon: Icon(Icons.lock_outline_rounded),
                            ),
                            obscureText: true,
                            validator: passwordValidator,
                            onSaved: (v) => _password = v ?? '',
                          )
                              .animate()
                              .fadeIn(delay: 500.ms, duration: 600.ms)
                              .moveX(begin: -20, end: 0, duration: 600.ms),
                          const SizedBox(height: 16),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: [
                                Checkbox(
                                  value: _rememberMe,
                                  onChanged: (v) {
                                    setState(() => _rememberMe = v ?? false);
                                  },
                                ),
                                const Text('Remember me'),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              icon: _busy
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor:
                                        AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                )
                              : const Icon(Icons.login_rounded, size: 22),
                          label: Text(
                            _busy ? 'Signing in...' : 'Sign In',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          onPressed: _busy
                              ? null
                              : () async {
                                  if (_formKey.currentState!.validate()) {
                                    _formKey.currentState!.save();
                                    setState(() => _busy = true);
                                    final messenger =
                                        ScaffoldMessenger.of(context);
                                    final navigator = Navigator.of(context);
                                    try {
                                      await auth.setWebPersistence(_rememberMe);
                                      await auth.signInWithEmail(
                                          _email, _password);
                                      final prefs = await SharedPreferences.getInstance();
                                      if (_rememberMe) {
                                        await prefs.setBool('remember_me', true);
                                        await prefs.setString('remember_email', _email);
                                      } else {
                                        await prefs.remove('remember_me');
                                        await prefs.remove('remember_email');
                                      }
                                      if (!mounted) return;
                                      navigator.pushReplacementNamed('/dashboard');
                                    } catch (e) {
                                      if (!mounted) return;
                                      messenger.showSnackBar(
                                        SnackBar(
                                          content: Row(
                                            children: [
                                              const Icon(Icons.error_outline,
                                                  color: Colors.white),
                                              const SizedBox(width: 12),
                                              Expanded(
                                                child: Text('Login failed: $e'),
                                              ),
                                            ],
                                          ),
                                          backgroundColor: AppTheme.error,
                                          behavior: SnackBarBehavior.floating,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                        ),
                                      );
                                      if (!mounted) return;
                                      setState(() => _busy = false);
                                    }
                                  }
                                },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 18),
                              ),
                            ),
                          )
                              .animate()
                              .fadeIn(delay: 600.ms, duration: 600.ms)
                              .moveY(begin: 20, end: 0, duration: 600.ms),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: Divider(
                                  color: isDark ? Colors.grey[700] : Colors.grey[300],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: Text(
                                  'OR',
                                  style: TextStyle(
                                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Divider(
                                  color: isDark ? Colors.grey[700] : Colors.grey[300],
                                ),
                              ),
                        ],
                      )
                          .animate()
                          .fadeIn(delay: 700.ms, duration: 600.ms),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              icon: const Icon(Icons.g_mobiledata, size: 28),
                              label: const Text(
                                'Continue with Google',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              onPressed: () async {
                            final messenger = ScaffoldMessenger.of(context);
                            final navigator = Navigator.of(context);
                            try {
                              await auth.setWebPersistence(true);
                              await auth.signInWithGoogle();
                              if (!mounted) return;
                              navigator.pushReplacementNamed('/dashboard');
                            } catch (e) {
                              if (!mounted) return;
                              messenger.showSnackBar(
                                SnackBar(
                                  content: Row(
                                    children: [
                                      const Icon(Icons.error_outline,
                                          color: Colors.white),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text('Google sign-in failed: $e'),
                                      ),
                                    ],
                                  ),
                                  backgroundColor: AppTheme.error,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              );
                            }
                          },
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 18),
                              ),
                            ),
                          )
                              .animate()
                              .fadeIn(delay: 800.ms, duration: 600.ms)
                              .moveY(begin: 20, end: 0, duration: 600.ms),
                          const SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Don\'t have an account? ',
                                style: TextStyle(
                                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                                ),
                              ),
                              TextButton(
                            onPressed: () => Navigator.pushNamed(context, '/signup'),
                            child: const Text(
                              'Sign up',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      )
                          .animate()
                          .fadeIn(delay: 900.ms, duration: 600.ms),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ).animate().fadeIn();
  }
}
