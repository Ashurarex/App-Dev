import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/firestore_service.dart';

class ThemeProvider extends ChangeNotifier {
  static const _keyDark = 'habit_theme_dark';
  static const _keyAccent = 'habit_theme_accent_color_value';
  bool isDark = false;
  Color? accentColor;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    isDark = prefs.getBool(_keyDark) ?? false;
    final v = prefs.getInt(_keyAccent);
    if (v != null) {
      accentColor = Color(v);
    }
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final fs = FirestoreService();
      final settings = await fs.getUserSettings(user.uid);
      final remoteAccent = settings?['accentColorValue'] as int?;
      if (remoteAccent != null) {
        accentColor = Color(remoteAccent);
        await prefs.setInt(_keyAccent, remoteAccent);
      }
    }
    notifyListeners();
  }

  Future<void> toggle() async {
    isDark = !isDark;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyDark, isDark);
    notifyListeners();
  }

  Future<void> setAccent(Color color) async {
    accentColor = color;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyAccent, color.value);
    notifyListeners();
  }
}
