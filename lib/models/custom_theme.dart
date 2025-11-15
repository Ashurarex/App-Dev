import 'package:flutter/material.dart';

class CustomTheme {
  final String id;
  final String name;
  final Color primaryColor;
  final Color secondaryColor;
  final Color accentColor;
  final Color backgroundColor;
  final Color cardColor;
  final Color textColor;
  final bool isPremium;
  final String? previewImage;

  CustomTheme({
    required this.id,
    required this.name,
    required this.primaryColor,
    required this.secondaryColor,
    required this.accentColor,
    required this.backgroundColor,
    required this.cardColor,
    required this.textColor,
    this.isPremium = false,
    this.previewImage,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'primaryColor': primaryColor.value,
        'secondaryColor': secondaryColor.value,
        'accentColor': accentColor.value,
        'backgroundColor': backgroundColor.value,
        'cardColor': cardColor.value,
        'textColor': textColor.value,
        'isPremium': isPremium,
        'previewImage': previewImage,
      };

  factory CustomTheme.fromMap(Map<String, dynamic> map) {
    return CustomTheme(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      primaryColor: Color(map['primaryColor'] ?? 0xFF6366F1),
      secondaryColor: Color(map['secondaryColor'] ?? 0xFF8B5CF6),
      accentColor: Color(map['accentColor'] ?? 0xFFEC4899),
      backgroundColor: Color(map['backgroundColor'] ?? 0xFFFFFFFF),
      cardColor: Color(map['cardColor'] ?? 0xFFF9FAFB),
      textColor: Color(map['textColor'] ?? 0xFF1F2937),
      isPremium: map['isPremium'] ?? false,
      previewImage: map['previewImage'],
    );
  }

  // Predefined themes
  static final List<CustomTheme> predefinedThemes = [
    // Free themes
    CustomTheme(
      id: 'default',
      name: 'Default',
      primaryColor: const Color(0xFF6366F1),
      secondaryColor: const Color(0xFF8B5CF6),
      accentColor: const Color(0xFFEC4899),
      backgroundColor: const Color(0xFFFFFFFF),
      cardColor: const Color(0xFFF9FAFB),
      textColor: const Color(0xFF1F2937),
      isPremium: false,
    ),
    CustomTheme(
      id: 'ocean',
      name: 'Ocean Blue',
      primaryColor: const Color(0xFF0EA5E9),
      secondaryColor: const Color(0xFF06B6D4),
      accentColor: const Color(0xFF3B82F6),
      backgroundColor: const Color(0xFFFFFFFF),
      cardColor: const Color(0xFFF0F9FF),
      textColor: const Color(0xFF1E293B),
      isPremium: false,
    ),
    CustomTheme(
      id: 'forest',
      name: 'Forest Green',
      primaryColor: const Color(0xFF10B981),
      secondaryColor: const Color(0xFF14B8A6),
      accentColor: const Color(0xFF059669),
      backgroundColor: const Color(0xFFFFFFFF),
      cardColor: const Color(0xFFF0FDF4),
      textColor: const Color(0xFF064E3B),
      isPremium: false,
    ),
    // Premium themes
    CustomTheme(
      id: 'sunset',
      name: 'Sunset',
      primaryColor: const Color(0xFFF59E0B),
      secondaryColor: const Color(0xFFEF4444),
      accentColor: const Color(0xFFF97316),
      backgroundColor: const Color(0xFFFFFFFF),
      cardColor: const Color(0xFFFFF7ED),
      textColor: const Color(0xFF7C2D12),
      isPremium: true,
    ),
    CustomTheme(
      id: 'midnight',
      name: 'Midnight',
      primaryColor: const Color(0xFF6366F1),
      secondaryColor: const Color(0xFF8B5CF6),
      accentColor: const Color(0xFFA78BFA),
      backgroundColor: const Color(0xFF0F172A),
      cardColor: const Color(0xFF1E293B),
      textColor: const Color(0xFFF1F5F9),
      isPremium: true,
    ),
    CustomTheme(
      id: 'rose',
      name: 'Rose Garden',
      primaryColor: const Color(0xFFEC4899),
      secondaryColor: const Color(0xFFF472B6),
      accentColor: const Color(0xFFDB2777),
      backgroundColor: const Color(0xFFFFFFFF),
      cardColor: const Color(0xFFFDF2F8),
      textColor: const Color(0xFF831843),
      isPremium: true,
    ),
    CustomTheme(
      id: 'amoled',
      name: 'AMOLED Black',
      primaryColor: const Color(0xFF6366F1),
      secondaryColor: const Color(0xFF8B5CF6),
      accentColor: const Color(0xFFEC4899),
      backgroundColor: const Color(0xFF000000),
      cardColor: const Color(0xFF0A0A0A),
      textColor: const Color(0xFFFFFFFF),
      isPremium: true,
    ),
    CustomTheme(
      id: 'lavender',
      name: 'Lavender Dreams',
      primaryColor: const Color(0xFF8B5CF6),
      secondaryColor: const Color(0xFFA78BFA),
      accentColor: const Color(0xFFC4B5FD),
      backgroundColor: const Color(0xFFFFFFFF),
      cardColor: const Color(0xFFFAF5FF),
      textColor: const Color(0xFF4C1D95),
      isPremium: true,
    ),
    CustomTheme(
      id: 'cyberpunk',
      name: 'Cyberpunk',
      primaryColor: const Color(0xFF06B6D4),
      secondaryColor: const Color(0xFFEC4899),
      accentColor: const Color(0xFFF59E0B),
      backgroundColor: const Color(0xFF0F172A),
      cardColor: const Color(0xFF1E293B),
      textColor: const Color(0xFF06B6D4),
      isPremium: true,
    ),
  ];

  static CustomTheme getThemeById(String id) {
    return predefinedThemes.firstWhere(
      (theme) => theme.id == id,
      orElse: () => predefinedThemes[0],
    );
  }
}
