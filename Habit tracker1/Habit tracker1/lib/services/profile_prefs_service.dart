import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePrefsService extends ChangeNotifier {
  static const _keyAvatarIcon = 'profile_avatar_icon_code';
  static const _keyAvatarColor = 'profile_avatar_color_value';

  int avatarIconCodePoint = Icons.person_rounded.codePoint;
  Color avatarColor = const Color(0xFF6366F1);
  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  ProfilePrefsService() {
    _initialize();
  }

  Future<void> _initialize() async {
    await load();
  }

  Future<void> load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      avatarIconCodePoint =
          prefs.getInt(_keyAvatarIcon) ?? Icons.person_rounded.codePoint;
      final colorValue = prefs.getInt(_keyAvatarColor);
      if (colorValue != null) {
        avatarColor = Color(colorValue);
      }
      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading profile preferences: $e');
      // Use default values if loading fails
      _isInitialized = true;
      notifyListeners();
    }
  }

  Future<void> loadFromFirestore(Map<String, dynamic>? settings) async {
    if (settings == null) return;

    try {
      if (settings['avatarIconCodePoint'] != null) {
        avatarIconCodePoint = settings['avatarIconCodePoint'] as int;
      }
      if (settings['avatarColorValue'] != null) {
        avatarColor = Color(settings['avatarColorValue'] as int);
      }

      // Save to local preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_keyAvatarIcon, avatarIconCodePoint);
      await prefs.setInt(_keyAvatarColor, avatarColor.value);

      notifyListeners();
    } catch (e) {
      debugPrint('Error loading profile from Firestore: $e');
    }
  }

  Future<void> setIcon(IconData icon) async {
    avatarIconCodePoint = icon.codePoint;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyAvatarIcon, avatarIconCodePoint);
    notifyListeners();
  }

  Future<void> setColor(Color color) async {
    avatarColor = color;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyAvatarColor, color.value);
    notifyListeners();
  }
}
