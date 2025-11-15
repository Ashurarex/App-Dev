import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/theme_provider.dart';

/// Helper class to get dynamic theme colors throughout the app
class ThemeHelper {
  /// Get the primary color from the current theme
  static Color getPrimaryColor(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    return themeProvider.currentTheme.primaryColor;
  }

  /// Get the secondary color from the current theme
  static Color getSecondaryColor(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    return themeProvider.currentTheme.secondaryColor;
  }

  /// Get the accent color from the current theme
  static Color getAccentColor(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    return themeProvider.currentTheme.accentColor;
  }

  /// Get a gradient using the current theme colors
  static LinearGradient getPrimaryGradient(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    return LinearGradient(
      colors: [
        themeProvider.currentTheme.primaryColor,
        themeProvider.currentTheme.secondaryColor,
      ],
    );
  }

  /// Get a gradient using secondary and accent colors
  static LinearGradient getAccentGradient(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    return LinearGradient(
      colors: [
        themeProvider.currentTheme.accentColor,
        themeProvider.currentTheme.secondaryColor,
      ],
    );
  }
}
