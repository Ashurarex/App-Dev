import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../services/habit_service.dart';
import '../models/habit.dart';
import '../constants/app_theme.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    final habitService = Provider.of<HabitService>(context, listen: false);
    final user = auth.currentUser;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('Please log in to view achievements')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Achievements',
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
                    const Color(0xFF4C1D95), // Deep purple
                    const Color(0xFF7C3AED), // Vibrant purple
                    const Color(0xFF9333EA), // Bright purple
                    const Color(0xFFA855F7), // Light purple
                  ]
                : [
                    const Color(0xFFE9D5FF), // Lavender
                    const Color(0xFFDDD6FE), // Soft purple
                    const Color(0xFFC4B5FD), // Medium purple
                    const Color(0xFFA78BFA), // Vibrant purple
                    const Color(0xFFE9D5FF), // Back to lavender
                  ],
          ),
        ),
        child: StreamBuilder<List<Habit>>(
        stream: habitService.streamHabits(user.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final habits = snapshot.data ?? [];
          final achievements = _calculateAchievements(habits);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Summary
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF6366F1),
                        Color(0xFF8B5CF6),
                        Color(0xFFEC4899),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF6366F1).withOpacity(0.4),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.25),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.emoji_events_rounded,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${achievements.where((a) => a['unlocked'] == true).length} / ${achievements.length}',
                              style: const TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 1.2,
                              ),
                            ),
                            const Text(
                              'Achievements Unlocked',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
                    .animate()
                    .fadeIn(delay: 100.ms)
                    .scale(delay: 100.ms, begin: const Offset(0.9, 0.9)),
                const SizedBox(height: 24),
                Text(
                  'All Achievements',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                )
                    .animate()
                    .fadeIn(delay: 200.ms)
                    .moveX(begin: -20, end: 0),
                const SizedBox(height: 12),
                ...achievements.asMap().entries.map((entry) {
                  final index = entry.key;
                  final achievement = entry.value;
                  return _buildAchievementCard(
                    achievement,
                    isDark,
                    index,
                  ).animate().fadeIn(delay: (300 + index * 100).ms).moveX(
                        begin: -20,
                        end: 0,
                      );
                }),
              ],
            ),
          );
        },
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _calculateAchievements(List<Habit> habits) {
    final totalHabits = habits.length;
    final totalDaysTracked = habits.fold<int>(
      0,
      (sum, habit) => sum + habit.daysTracked,
    );
    final maxStreak = habits.isEmpty
        ? 0
        : habits.map((h) => h.streak).reduce((a, b) => a > b ? a : b);
    final completedToday = habits.where((h) => h.completed).length;

    return [
      {
        'id': 'first_habit',
        'title': 'Getting Started',
        'description': 'Create your first habit',
        'icon': Icons.rocket_launch_rounded,
        'unlocked': totalHabits >= 1,
        'progress': totalHabits >= 1 ? 1.0 : 0.0,
        'color': const Color(0xFF6366F1), // Indigo
        'gradient': [const Color(0xFF6366F1), const Color(0xFF8B5CF6)],
      },
      {
        'id': 'five_habits',
        'title': 'Habit Collector',
        'description': 'Create 5 habits',
        'icon': Icons.workspace_premium_rounded,
        'unlocked': totalHabits >= 5,
        'progress': (totalHabits / 5.0).clamp(0.0, 1.0),
        'color': const Color(0xFF8B5CF6), // Violet
        'gradient': [const Color(0xFF8B5CF6), const Color(0xFFEC4899)],
      },
      {
        'id': 'ten_habits',
        'title': 'Habit Master',
        'description': 'Create 10 habits',
        'icon': Icons.emoji_events_rounded,
        'unlocked': totalHabits >= 10,
        'progress': (totalHabits / 10.0).clamp(0.0, 1.0),
        'color': const Color(0xFFF59E0B), // Amber
        'gradient': [const Color(0xFFF59E0B), const Color(0xFFEF4444)],
      },
      {
        'id': 'week_streak',
        'title': 'Week Warrior',
        'description': 'Maintain a 7-day streak',
        'icon': Icons.local_fire_department_rounded,
        'unlocked': maxStreak >= 7,
        'progress': (maxStreak / 7.0).clamp(0.0, 1.0),
        'color': const Color(0xFFEF4444), // Red
        'gradient': [const Color(0xFFEF4444), const Color(0xFFF59E0B)],
      },
      {
        'id': 'month_streak',
        'title': 'Month Master',
        'description': 'Maintain a 30-day streak',
        'icon': Icons.celebration_rounded,
        'unlocked': maxStreak >= 30,
        'progress': (maxStreak / 30.0).clamp(0.0, 1.0),
        'color': const Color(0xFFEC4899), // Pink
        'gradient': [const Color(0xFFEC4899), const Color(0xFF8B5CF6)],
      },
      {
        'id': 'century',
        'title': 'Century Club',
        'description': 'Track 100 total days',
        'icon': Icons.diamond_rounded,
        'unlocked': totalDaysTracked >= 100,
        'progress': (totalDaysTracked / 100.0).clamp(0.0, 1.0),
        'color': const Color(0xFF14B8A6), // Teal
        'gradient': [const Color(0xFF14B8A6), const Color(0xFF06B6D4)],
      },
      {
        'id': 'perfect_day',
        'title': 'Perfect Day',
        'description': 'Complete all habits in one day',
        'icon': Icons.verified_rounded,
        'unlocked': totalHabits > 0 && completedToday == totalHabits,
        'progress': totalHabits > 0 ? (completedToday / totalHabits) : 0.0,
        'color': const Color(0xFF10B981), // Emerald
        'gradient': [const Color(0xFF10B981), const Color(0xFF14B8A6)],
      },
      {
        'id': 'dedication',
        'title': 'Dedication',
        'description': 'Track 50 days total',
        'icon': Icons.favorite_rounded,
        'unlocked': totalDaysTracked >= 50,
        'progress': (totalDaysTracked / 50.0).clamp(0.0, 1.0),
        'color': const Color(0xFFEC4899), // Pink
        'gradient': [const Color(0xFFEC4899), const Color(0xFFF472B6)],
      },
    ];
  }

  Widget _buildAchievementCard(
    Map<String, dynamic> achievement,
    bool isDark,
    int index,
  ) {
    final unlocked = achievement['unlocked'] as bool;
    final progress = achievement['progress'] as double;
    final color = achievement['color'] as Color;
    final gradient = achievement['gradient'] as List<Color>?;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: unlocked && gradient != null
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  gradient[0].withOpacity(0.1),
                  gradient[1].withOpacity(0.05),
                ],
              )
            : null,
        color: unlocked
            ? null
            : (isDark ? Colors.grey[850] : Colors.grey[100]),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: unlocked
              ? color.withOpacity(0.5)
              : Colors.grey.withOpacity(0.2),
          width: unlocked ? 2.5 : 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: unlocked
                ? color.withOpacity(0.3)
                : Colors.black.withOpacity(0.05),
            blurRadius: unlocked ? 16 : 8,
            offset: const Offset(0, 4),
            spreadRadius: unlocked ? 1 : 0,
          ),
        ],
      ),
      child: Row(
        children: [
          // Badge Icon
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              gradient: unlocked && gradient != null
                  ? LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: gradient,
                    )
                  : null,
              color: unlocked ? null : (isDark ? Colors.grey[700] : Colors.grey[300]),
              shape: BoxShape.circle,
              boxShadow: unlocked
                  ? [
                      BoxShadow(
                        color: color.withOpacity(0.4),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                        spreadRadius: 2,
                      ),
                    ]
                  : null,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Icon(
                  achievement['icon'] as IconData,
                  color: unlocked ? Colors.white : (isDark ? Colors.grey[600] : Colors.grey[500]),
                  size: 32,
                ),
                if (unlocked)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: AppTheme.success,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 12,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        achievement['title'] as String,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: unlocked
                              ? (isDark ? Colors.white : Colors.black87)
                              : (isDark ? Colors.grey[500] : Colors.grey[600]),
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  achievement['description'] as String,
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: isDark
                        ? Colors.grey[700]
                        : Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      unlocked ? color : Colors.grey[400]!,
                    ),
                    minHeight: 8,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  unlocked
                      ? '✓ Unlocked!'
                      : '${(progress * 100).toStringAsFixed(0)}% complete',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: unlocked ? color : (isDark ? Colors.grey[500] : Colors.grey[600]),
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

