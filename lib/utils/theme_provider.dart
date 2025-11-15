import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/firestore_service.dart';
import '../models/custom_theme.dart';

class ThemeProvider extends ChangeNotifier {
  static const _keyDark = 'habit_theme_dark';
  static const _keyAccent = 'habit_theme_accent_color_value';
  static const _keyThemeId = 'habit_theme_id';
  
  bool isDark = false;
  Color? accentColor;
  String currentThemeId = 'default';
  CustomTheme? _customTheme;

  CustomTheme get currentTheme {
    return _customTheme ?? CustomTheme.getThemeById(currentThemeId);
  }

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    isDark = prefs.getBool(_keyDark) ?? false;
    currentThemeId = prefs.getString(_keyThemeId) ?? 'default';
    _customTheme = CustomTheme.getThemeById(currentThemeId);
    
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

  Future<void> setTheme(String themeId) async {
    currentThemeId = themeId;
    _customTheme = CustomTheme.getThemeById(themeId);
    
    // Auto-switch to dark mode for dark themes
    if (themeId == 'midnight' || themeId == 'amoled' || themeId == 'cyberpunk') {
      isDark = true;
    } else if (themeId != 'default') {
      // Keep current dark mode setting for other themes
    }
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyThemeId, themeId);
    await prefs.setBool(_keyDark, isDark);
    notifyListeners();
  }

  ThemeData getThemeData(bool dark) {
    final theme = currentTheme;
    
    if (dark) {
      return ThemeData.dark().copyWith(
        primaryColor: theme.primaryColor,
        colorScheme: ColorScheme.dark(
          primary: theme.primaryColor,
          secondary: theme.secondaryColor,
          tertiary: theme.accentColor,
          background: theme.backgroundColor,
          surface: theme.cardColor,
          error: const Color(0xFFEF4444),
        ),
        scaffoldBackgroundColor: theme.backgroundColor,
        cardColor: theme.cardColor,
        appBarTheme: AppBarTheme(
          backgroundColor: theme.backgroundColor,
          foregroundColor: theme.textColor,
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.primaryColor,
            foregroundColor: Colors.white,
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: theme.primaryColor,
          foregroundColor: Colors.white,
        ),
        progressIndicatorTheme: ProgressIndicatorThemeData(
          color: theme.primaryColor,
        ),
        switchTheme: SwitchThemeData(
          thumbColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return theme.primaryColor;
            }
            return null;
          }),
          trackColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return theme.primaryColor.withOpacity(0.5);
            }
            return null;
          }),
        ),
        checkboxTheme: CheckboxThemeData(
          fillColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return theme.primaryColor;
            }
            return null;
          }),
        ),
        radioTheme: RadioThemeData(
          fillColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return theme.primaryColor;
            }
            return null;
          }),
        ),
      );
    } else {
      return ThemeData.light().copyWith(
        primaryColor: theme.primaryColor,
        colorScheme: ColorScheme.light(
          primary: theme.primaryColor,
          secondary: theme.secondaryColor,
          tertiary: theme.accentColor,
          background: theme.backgroundColor,
          surface: theme.cardColor,
          error: const Color(0xFFEF4444),
        ),
        scaffoldBackgroundColor: theme.backgroundColor,
        cardColor: theme.cardColor,
        appBarTheme: AppBarTheme(
          backgroundColor: theme.backgroundColor,
          foregroundColor: theme.textColor,
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.primaryColor,
            foregroundColor: Colors.white,
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: theme.primaryColor,
          foregroundColor: Colors.white,
        ),
        progressIndicatorTheme: ProgressIndicatorThemeData(
          color: theme.primaryColor,
        ),
        switchTheme: SwitchThemeData(
          thumbColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return theme.primaryColor;
            }
            return null;
          }),
          trackColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return theme.primaryColor.withOpacity(0.5);
            }
            return null;
          }),
        ),
        checkboxTheme: CheckboxThemeData(
          fillColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return theme.primaryColor;
            }
            return null;
          }),
        ),
        radioTheme: RadioThemeData(
          fillColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return theme.primaryColor;
            }
            return null;
          }),
        ),
      );
    }
  }
}
