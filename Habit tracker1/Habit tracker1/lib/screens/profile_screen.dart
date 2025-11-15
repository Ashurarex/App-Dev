import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../services/premium_service.dart';
import '../services/reminder_service.dart';
import '../services/profile_prefs_service.dart';
import '../services/notification_service.dart';
import '../services/firestore_service.dart';
import '../utils/theme_provider.dart';
import '../constants/app_theme.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isLoading = true;
  bool _hasError = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    try {
      debugPrint('ProfileScreen: Loading profile data...');
      final profilePrefs =
          Provider.of<ProfilePrefsService>(context, listen: false);
      await profilePrefs.load();
      debugPrint('ProfileScreen: Profile data loaded successfully');

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('ProfileScreen: Error loading profile data: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
          _hasError = true;
          _errorMessage = 'Failed to load profile data: ${e.toString()}';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('ProfileScreen: build called, _isLoading=$_isLoading, _hasError=$_hasError');
    
    if (_isLoading) {
      debugPrint('ProfileScreen: Showing loading indicator');
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Profile & Settings',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_hasError) {
      debugPrint('ProfileScreen: Showing error: $_errorMessage');
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Profile & Settings',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 48),
                const SizedBox(height: 16),
                Text(
                  'Error loading profile',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  _errorMessage ?? 'An unknown error occurred',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _loadProfileData,
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    debugPrint('ProfileScreen: Rendering main content');
    final auth = Provider.of<AuthService>(context);
    final themeProv = Provider.of<ThemeProvider>(context);
    final profilePrefs = Provider.of<ProfilePrefsService>(context);
    final firestore = Provider.of<FirestoreService>(context, listen: false);
    final user = auth.currentUser;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    debugPrint('ProfileScreen: user=${user?.email}, isDark=$isDark');

    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Profile & Settings',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Login Required',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Please log in to manage your profile and settings',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? Colors.grey[400] : Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () =>
                                Navigator.pushNamed(context, '/login'),
                            icon: const Icon(Icons.login_rounded),
                            label: const Text('Go to Login'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile & Settings',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [
                    const Color(0xFF1E293B),
                    const Color(0xFF334155),
                    const Color(0xFF475569),
                    const Color(0xFF1E293B),
                  ]
                : [
                    const Color(0xFFF0F9FF),
                    const Color(0xFFE0F2FE),
                    const Color(0xFFBAE6FD),
                    const Color(0xFFF0F9FF),
                  ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Dark Mode Toggle Card
                    Card(
                      color: isDark ? Colors.grey[850] : Colors.white,
                      elevation: 4,
                      child: ListTile(
                        leading: Icon(
                          themeProv.isDark
                              ? Icons.light_mode_rounded
                              : Icons.dark_mode_rounded,
                          color: AppTheme.primary,
                        ),
                        title: Text(
                          'Dark Mode',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                        trailing: Switch(
                          value: themeProv.isDark,
                          onChanged: (_) => themeProv.toggle(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Profile Header
                    Center(
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: isDark ? Colors.grey[800] : Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: AppTheme.primary.withOpacity(0.3),
                                  blurRadius: 20,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Icon(
                              IconData(profilePrefs.avatarIconCodePoint,
                                  fontFamily: 'MaterialIcons'),
                              size: 60,
                              color: profilePrefs.avatarColor,
                            ),
                          ),
                          const SizedBox(height: 20),
                          FutureBuilder<String?>(
                            future: firestore.getDisplayName(user.uid),
                            builder: (context, snapshot) {
                              final dn =
                                  snapshot.data ?? user.displayName ?? 'User';
                              return Text(
                                dn,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? Colors.white : Colors.black87,
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 8),
                          Text(
                            user.email ?? '—',
                            style: TextStyle(
                              fontSize: 16,
                              color: isDark ? Colors.grey[300] : Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    // Edit Display Name Card
                    Card(
                      color: isDark ? Colors.grey[850] : Colors.white,
                      elevation: 4,
                      child: ListTile(
                        leading: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppTheme.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.edit_rounded,
                            color: AppTheme.primary,
                            size: 24,
                          ),
                        ),
                        title: Text(
                          'Display Name',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                        subtitle: FutureBuilder<String?>(
                          future: firestore.getDisplayName(user.uid),
                          builder: (context, snapshot) {
                            final dn = snapshot.data ?? user.displayName ?? '—';
                            return Text(
                              dn,
                              style: TextStyle(
                                fontSize: 12,
                                color: isDark ? Colors.grey[400] : Colors.grey[600],
                              ),
                            );
                          },
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                        onTap: () async {
                          final controller = TextEditingController(
                              text: user.displayName ?? '');
                          final result = await showDialog<String>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Edit Display Name'),
                              content: TextField(
                                controller: controller,
                                decoration: const InputDecoration(
                                  hintText: 'Enter your name',
                                  border: OutlineInputBorder(),
                                ),
                                autofocus: true,
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Cancel'),
                                ),
                                ElevatedButton(
                                  onPressed: () => Navigator.pop(
                                      context, controller.text.trim()),
                                  child: const Text('Save'),
                                ),
                              ],
                            ),
                          );
                          if (result != null && result.isNotEmpty) {
                            await user.updateDisplayName(result);
                            await firestore.setUserSettings(
                              user.uid,
                              displayName: result,
                            );
                            if (mounted) {
                              setState(() {});
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text('Display name updated'),
                                  backgroundColor: AppTheme.success,
                                ),
                              );
                            }
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Theme Accent Color Card
                    Card(
                      color: isDark ? Colors.grey[850] : Colors.white,
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: AppTheme.secondary.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(
                                    Icons.palette_rounded,
                                    color: AppTheme.secondary,
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  'Theme Accent Color',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: isDark ? Colors.white : Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Wrap(
                              spacing: 12,
                              runSpacing: 12,
                              children: [
                                const Color(0xFF6366F1), // Indigo
                                const Color(0xFF8B5CF6), // Purple
                                const Color(0xFFEC4899), // Pink
                                const Color(0xFF10B981), // Green
                                const Color(0xFFF59E0B), // Amber
                                const Color(0xFFEF4444), // Red
                                const Color(0xFF14B8A6), // Teal
                                const Color(0xFF06B6D4), // Cyan
                              ].map((color) {
                                final isSelected = themeProv.accentColor?.value == color.value;
                                return GestureDetector(
                                  onTap: () async {
                                    await themeProv.setAccent(color);
                                    await firestore.setUserSettings(
                                      user.uid,
                                      accentColorValue: color.value,
                                    );
                                    if (mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: const Text('Theme color updated'),
                                          backgroundColor: color,
                                          duration: const Duration(seconds: 1),
                                        ),
                                      );
                                    }
                                  },
                                  child: Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: color,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: isSelected
                                            ? (isDark ? Colors.white : Colors.black)
                                            : Colors.transparent,
                                        width: 3,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: color.withOpacity(0.4),
                                          blurRadius: 8,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: isSelected
                                        ? const Icon(
                                            Icons.check_rounded,
                                            color: Colors.white,
                                            size: 24,
                                          )
                                        : null,
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    // Logout Button
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.logout_rounded),
                        label: const Text(
                          'Logout',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        onPressed: () async {
                          final navigator = Navigator.of(context);
                          await auth.signOut();
                          if (!mounted) return;
                          navigator.pushNamedAndRemoveUntil(
                            '/login',
                            (route) => false,
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          side: const BorderSide(color: AppTheme.error, width: 2),
                          foregroundColor: AppTheme.error,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
