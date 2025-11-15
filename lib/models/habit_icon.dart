import 'package:flutter/material.dart';

class HabitIcon {
  final String id;
  final IconData icon;
  final String name;
  final String category;
  final bool isPremium;

  HabitIcon({
    required this.id,
    required this.icon,
    required this.name,
    required this.category,
    this.isPremium = false,
  });

  static final List<HabitIcon> allIcons = [
    // Free - Health & Fitness
    HabitIcon(
      id: 'fitness',
      icon: Icons.fitness_center_rounded,
      name: 'Fitness',
      category: 'Health',
    ),
    HabitIcon(
      id: 'run',
      icon: Icons.directions_run_rounded,
      name: 'Running',
      category: 'Health',
    ),
    HabitIcon(
      id: 'water',
      icon: Icons.water_drop_rounded,
      name: 'Water',
      category: 'Health',
    ),
    HabitIcon(
      id: 'meditation',
      icon: Icons.self_improvement_rounded,
      name: 'Meditation',
      category: 'Health',
    ),
    HabitIcon(
      id: 'sleep',
      icon: Icons.bedtime_rounded,
      name: 'Sleep',
      category: 'Health',
    ),

    // Free - Productivity
    HabitIcon(
      id: 'book',
      icon: Icons.menu_book_rounded,
      name: 'Reading',
      category: 'Productivity',
    ),
    HabitIcon(
      id: 'work',
      icon: Icons.work_rounded,
      name: 'Work',
      category: 'Productivity',
    ),
    HabitIcon(
      id: 'study',
      icon: Icons.school_rounded,
      name: 'Study',
      category: 'Productivity',
    ),
    HabitIcon(
      id: 'write',
      icon: Icons.edit_rounded,
      name: 'Writing',
      category: 'Productivity',
    ),

    // Free - Lifestyle
    HabitIcon(
      id: 'music',
      icon: Icons.music_note_rounded,
      name: 'Music',
      category: 'Lifestyle',
    ),
    HabitIcon(
      id: 'coffee',
      icon: Icons.coffee_rounded,
      name: 'Coffee',
      category: 'Lifestyle',
    ),
    HabitIcon(
      id: 'home',
      icon: Icons.home_rounded,
      name: 'Home',
      category: 'Lifestyle',
    ),

    // Premium - Health & Fitness
    HabitIcon(
      id: 'yoga',
      icon: Icons.spa_rounded,
      name: 'Yoga',
      category: 'Health',
      isPremium: true,
    ),
    HabitIcon(
      id: 'bike',
      icon: Icons.directions_bike_rounded,
      name: 'Cycling',
      category: 'Health',
      isPremium: true,
    ),
    HabitIcon(
      id: 'swim',
      icon: Icons.pool_rounded,
      name: 'Swimming',
      category: 'Health',
      isPremium: true,
    ),
    HabitIcon(
      id: 'heart',
      icon: Icons.favorite_rounded,
      name: 'Heart Health',
      category: 'Health',
      isPremium: true,
    ),
    HabitIcon(
      id: 'food',
      icon: Icons.restaurant_rounded,
      name: 'Healthy Eating',
      category: 'Health',
      isPremium: true,
    ),
    HabitIcon(
      id: 'vitamin',
      icon: Icons.medication_rounded,
      name: 'Vitamins',
      category: 'Health',
      isPremium: true,
    ),

    // Premium - Productivity
    HabitIcon(
      id: 'code',
      icon: Icons.code_rounded,
      name: 'Coding',
      category: 'Productivity',
      isPremium: true,
    ),
    HabitIcon(
      id: 'language',
      icon: Icons.translate_rounded,
      name: 'Language',
      category: 'Productivity',
      isPremium: true,
    ),
    HabitIcon(
      id: 'art',
      icon: Icons.palette_rounded,
      name: 'Art',
      category: 'Productivity',
      isPremium: true,
    ),
    HabitIcon(
      id: 'camera',
      icon: Icons.camera_alt_rounded,
      name: 'Photography',
      category: 'Productivity',
      isPremium: true,
    ),
    HabitIcon(
      id: 'design',
      icon: Icons.design_services_rounded,
      name: 'Design',
      category: 'Productivity',
      isPremium: true,
    ),

    // Premium - Lifestyle
    HabitIcon(
      id: 'travel',
      icon: Icons.flight_rounded,
      name: 'Travel',
      category: 'Lifestyle',
      isPremium: true,
    ),
    HabitIcon(
      id: 'garden',
      icon: Icons.local_florist_rounded,
      name: 'Gardening',
      category: 'Lifestyle',
      isPremium: true,
    ),
    HabitIcon(
      id: 'pet',
      icon: Icons.pets_rounded,
      name: 'Pet Care',
      category: 'Lifestyle',
      isPremium: true,
    ),
    HabitIcon(
      id: 'clean',
      icon: Icons.cleaning_services_rounded,
      name: 'Cleaning',
      category: 'Lifestyle',
      isPremium: true,
    ),
    HabitIcon(
      id: 'cook',
      icon: Icons.restaurant_menu_rounded,
      name: 'Cooking',
      category: 'Lifestyle',
      isPremium: true,
    ),
    HabitIcon(
      id: 'shopping',
      icon: Icons.shopping_bag_rounded,
      name: 'Shopping',
      category: 'Lifestyle',
      isPremium: true,
    ),
    HabitIcon(
      id: 'game',
      icon: Icons.sports_esports_rounded,
      name: 'Gaming',
      category: 'Lifestyle',
      isPremium: true,
    ),
    HabitIcon(
      id: 'movie',
      icon: Icons.movie_rounded,
      name: 'Movies',
      category: 'Lifestyle',
      isPremium: true,
    ),

    // Premium - Social & Mindfulness
    HabitIcon(
      id: 'family',
      icon: Icons.family_restroom_rounded,
      name: 'Family Time',
      category: 'Social',
      isPremium: true,
    ),
    HabitIcon(
      id: 'friends',
      icon: Icons.group_rounded,
      name: 'Friends',
      category: 'Social',
      isPremium: true,
    ),
    HabitIcon(
      id: 'volunteer',
      icon: Icons.volunteer_activism_rounded,
      name: 'Volunteering',
      category: 'Social',
      isPremium: true,
    ),
    HabitIcon(
      id: 'pray',
      icon: Icons.church_rounded,
      name: 'Prayer',
      category: 'Mindfulness',
      isPremium: true,
    ),
    HabitIcon(
      id: 'journal',
      icon: Icons.book_rounded,
      name: 'Journaling',
      category: 'Mindfulness',
      isPremium: true,
    ),
    HabitIcon(
      id: 'gratitude',
      icon: Icons.emoji_emotions_rounded,
      name: 'Gratitude',
      category: 'Mindfulness',
      isPremium: true,
    ),
  ];

  static List<HabitIcon> getIconsByCategory(String category) {
    return allIcons.where((icon) => icon.category == category).toList();
  }

  static List<String> get categories {
    return allIcons.map((icon) => icon.category).toSet().toList();
  }

  static HabitIcon getIconById(String id) {
    return allIcons.firstWhere(
      (icon) => icon.id == id,
      orElse: () => allIcons[0],
    );
  }
}
