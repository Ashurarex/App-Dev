import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../services/habit_service.dart';
import '../services/premium_service.dart';
import '../services/export_service.dart';
import '../models/habit.dart';
import '../constants/app_theme.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:share_plus/share_plus.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    final habitService = Provider.of<HabitService>(context, listen: false);
    final user = auth.currentUser;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('Please log in to view statistics')),
      );
    }

    final premiumService = Provider.of<PremiumService>(context);
    final isPremium = premiumService.isPremium;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Statistics',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          if (isPremium)
            IconButton(
              icon: const Icon(Icons.analytics_rounded),
              tooltip: 'Advanced Analytics',
              onPressed: () => Navigator.pushNamed(context, '/advanced-analytics'),
            ),
          if (isPremium)
            PopupMenuButton(
              icon: const Icon(Icons.more_vert_rounded),
              itemBuilder: (context) => [
                PopupMenuItem(
                  child: const Row(
                    children: [
                      Icon(Icons.file_download_rounded, size: 20),
                      SizedBox(width: 12),
                      Text('Export Data'),
                    ],
                  ),
                  onTap: () async {
                    final navigator = Navigator.of(context);
                    final habitsSnapshot = await habitService
                        .streamHabits(user.uid)
                        .first;
                    if (!navigator.mounted) return;
                    _showExportDialog(
                      navigator.context,
                      habitsSnapshot,
                      premiumService,
                    );
                  },
                ),
                PopupMenuItem(
                  child: const Row(
                    children: [
                      Icon(Icons.share_rounded, size: 20),
                      SizedBox(width: 12),
                      Text('Share Report'),
                    ],
                  ),
                  onTap: () async {
                    final navigator = Navigator.of(context);
                    final habitsSnapshot = await habitService
                        .streamHabits(user.uid)
                        .first;
                    if (!navigator.mounted) return;
                    _shareReport(navigator.context, habitsSnapshot);
                  },
                ),
              ],
            ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [
                    const Color(0xFF831843), // Deep pink
                    const Color(0xFFEC4899), // Vibrant pink
                    const Color(0xFFDB2777), // Bright pink
                    const Color(0xFFBE185D), // Medium pink
                  ]
                : [
                    const Color(0xFFFBCFE8), // Soft pink
                    const Color(0xFFF9A8D4), // Pastel pink
                    const Color(0xFFF472B6), // Vibrant pink
                    const Color(0xFFEC4899), // Bright pink
                    const Color(0xFFFBCFE8), // Back to soft pink
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

          if (habits.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF6366F1).withOpacity(0.2),
                          const Color(0xFF8B5CF6).withOpacity(0.2),
                        ],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.bar_chart_rounded,
                      size: 64,
                      color: isDark ? Colors.grey[300] : Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No habits to analyze yet',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.grey[300] : Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Add some habits to see your statistics',
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            );
          }

          // Calculate statistics
          final totalHabits = habits.length;
          final completedHabits = habits.where((h) => h.completed).length;
          final totalDaysTracked = habits.fold<int>(
            0,
            (sum, habit) => sum + habit.daysTracked,
          );
          final totalStreak = habits.fold<int>(
            0,
            (sum, habit) => sum + habit.streak,
          );
          final avgCompletionRate = totalHabits > 0
              ? (habits.fold<double>(
                      0,
                      (sum, habit) =>
                          sum + (habit.daysTracked > 0 ? 1.0 : 0.0)) /
                  totalHabits * 100)
              : 0.0;

          // Get top performing habits
          final topHabits = List<Habit>.from(habits)
            ..sort((a, b) => b.daysTracked.compareTo(a.daysTracked));

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Overview Cards
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        'Total Habits',
                        totalHabits.toString(),
                        Icons.checklist_rounded,
                        AppTheme.primary,
                        isDark,
                      ).animate().fadeIn(delay: 100.ms).scale(),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        'Days Tracked',
                        totalDaysTracked.toString(),
                        Icons.calendar_today_rounded,
                        AppTheme.secondary,
                        isDark,
                      ).animate().fadeIn(delay: 200.ms).scale(),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        'Total Streak',
                        totalStreak.toString(),
                        Icons.local_fire_department_rounded,
                        AppTheme.accent,
                        isDark,
                      ).animate().fadeIn(delay: 300.ms).scale(),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        'Active Today',
                        completedHabits.toString(),
                        Icons.today_rounded,
                        AppTheme.success,
                        isDark,
                      ).animate().fadeIn(delay: 400.ms).scale(),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Completion Rate Chart
                _buildCompletionRateCard(habits, avgCompletionRate, isDark)
                    .animate()
                    .fadeIn(delay: 500.ms)
                    .moveY(begin: 20, end: 0),
                const SizedBox(height: 24),
                // Top Habits
                Text(
                  'Top Performing Habits',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                )
                    .animate()
                    .fadeIn(delay: 600.ms)
                    .moveX(begin: -20, end: 0),
                const SizedBox(height: 12),
                ...topHabits.take(5).map((habit) {
                  final index = topHabits.indexOf(habit);
                  return _buildHabitStatCard(habit, index + 1, isDark)
                      .animate()
                      .fadeIn(delay: (700 + index * 100).ms)
                      .moveX(begin: -20, end: 0);
                }),
              ],
            ),
          );
        },
        ),
      ),
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    IconData icon,
    Color color,
    bool isDark,
  ) {
    // Create gradient colors based on the base color
    final gradientColors = _getGradientForColor(color);
    
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  Colors.grey[850]!,
                  Colors.grey[800]!,
                  Colors.grey[850]!,
                ]
              : [
                  Colors.white,
                  color.withOpacity(0.05),
                  color.withOpacity(0.1),
                  Colors.white,
                ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.2),
            blurRadius: 16,
            offset: const Offset(0, 4),
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: gradientColors,
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 26),
          ),
          const SizedBox(height: 14),
          Text(
            value,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: isDark ? Colors.grey[400] : Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  List<Color> _getGradientForColor(Color baseColor) {
    if (baseColor == AppTheme.primary) {
      return [const Color(0xFF6366F1), const Color(0xFF8B5CF6)];
    } else if (baseColor == AppTheme.secondary) {
      return [const Color(0xFF8B5CF6), const Color(0xFFEC4899)];
    } else if (baseColor == AppTheme.accent) {
      return [const Color(0xFFEC4899), const Color(0xFFF472B6)];
    } else if (baseColor == AppTheme.success) {
      return [const Color(0xFF10B981), const Color(0xFF14B8A6)];
    }
    return [baseColor, baseColor.withOpacity(0.7)];
  }

  Widget _buildCompletionRateCard(
    List<Habit> habits,
    double avgRate,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  Colors.grey[850]!,
                  Colors.grey[800]!,
                  Colors.grey[850]!,
                ]
              : [
                  Colors.white,
                  const Color(0xFFFCE7F3).withOpacity(0.4),
                  const Color(0xFFFBCFE8).withOpacity(0.3),
                  Colors.white,
                ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF6366F1).withOpacity(0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6366F1).withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 6),
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Completion Rate',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: PieChart(
              PieChartData(
                sections: habits.map((habit) {
                  final rate = habit.daysTracked > 0 ? 1.0 : 0.0;
                  return PieChartSectionData(
                    value: rate,
                    title: '',
                    color: _getHabitColor(habit, habits.indexOf(habit)),
                    radius: 60,
                  );
                }).toList(),
                sectionsSpace: 2,
                centerSpaceRadius: 60,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF6366F1),
                        Color(0xFF8B5CF6),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF6366F1).withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Text(
                    '${avgRate.toStringAsFixed(1)}%',
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                Text(
                  'Average Completion',
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHabitStatCard(Habit habit, int rank, bool isDark) {
    final percentage = habit.daysTracked > 0
        ? (habit.daysTracked / 30.0 * 100).clamp(0.0, 100.0)
        : 0.0;

    // Different gradient colors for different ranks
    final rankGradients = [
      [const Color(0xFFF59E0B), const Color(0xFFEF4444)], // Gold for #1
      [const Color(0xFF6366F1), const Color(0xFF8B5CF6)], // Indigo for #2
      [const Color(0xFF10B981), const Color(0xFF14B8A6)], // Emerald for #3
      [const Color(0xFF8B5CF6), const Color(0xFFEC4899)], // Violet for others
      [const Color(0xFFEC4899), const Color(0xFFF472B6)], // Pink for others
    ];
    final rankGradient = rankGradients[(rank - 1).clamp(0, rankGradients.length - 1)];

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  Colors.grey[850]!,
                  Colors.grey[800]!,
                  Colors.grey[850]!,
                ]
              : [
                  Colors.white,
                  rankGradient[0].withOpacity(0.08),
                  rankGradient[1].withOpacity(0.05),
                  Colors.white,
                ],
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: rankGradient[0].withOpacity(0.4),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: rankGradient[0].withOpacity(0.2),
            blurRadius: 12,
            offset: const Offset(0, 4),
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: rankGradient,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: rankGradient[0].withOpacity(0.4),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Center(
              child: Text(
                '#$rank',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  habit.title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: percentage / 100,
                          backgroundColor: isDark
                              ? Colors.grey[700]
                              : Colors.grey[200],
                          valueColor: AlwaysStoppedAnimation<Color>(
                            rankGradient[0],
                          ),
                          minHeight: 10,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            rankGradient[0].withOpacity(0.2),
                            rankGradient[1].withOpacity(0.2),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${habit.daysTracked} days',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: rankGradient[0],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (habit.streak > 0) ...[
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFFEF4444).withOpacity(0.2),
                    const Color(0xFFF59E0B).withOpacity(0.2),
                  ],
                ),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: const Color(0xFFEF4444).withOpacity(0.3),
                  width: 1.5,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.local_fire_department_rounded,
                    size: 18,
                    color: Color(0xFFEF4444),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${habit.streak}',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFEF4444),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Color _getHabitColor(Habit habit, int index) {
    final colors = [
      const Color(0xFF6366F1), // Indigo
      const Color(0xFF8B5CF6), // Violet
      const Color(0xFFEC4899), // Pink
      const Color(0xFF10B981), // Emerald
      const Color(0xFFF59E0B), // Amber
      const Color(0xFFEF4444), // Red
      const Color(0xFF14B8A6), // Teal
      const Color(0xFF06B6D4), // Cyan
    ];
    return colors[index % colors.length];
  }

  static void _showExportDialog(
    BuildContext context,
    List<Habit> habits,
    PremiumService premiumService,
  ) {
    if (!premiumService.isPremium) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Export is a Premium feature. Upgrade to access.'),
          backgroundColor: AppTheme.accent,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Export Data'),
        content: const Text('Choose export format:'),
        actions: [
          TextButton.icon(
            onPressed: () async {
              Navigator.pop(context);
              final exportService = ExportService();
              final jsonData = await exportService.exportToJson(habits);
              await exportService.copyToClipboard(jsonData);
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Data copied to clipboard (JSON)'),
                  backgroundColor: AppTheme.success,
                ),
              );
            },
            icon: const Icon(Icons.code_rounded),
            label: const Text('JSON'),
          ),
          TextButton.icon(
            onPressed: () async {
              Navigator.pop(context);
              final exportService = ExportService();
              final csvData = exportService.exportToCsv(habits);
              await exportService.copyToClipboard(csvData);
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Data copied to clipboard (CSV)'),
                  backgroundColor: AppTheme.success,
                ),
              );
            },
            icon: const Icon(Icons.table_chart_rounded),
            label: const Text('CSV'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  static void _shareReport(BuildContext context, List<Habit> habits) {
    final totalHabits = habits.length;
    final totalCompletions = habits.fold<int>(
      0,
      (sum, habit) => sum + habit.daysTracked,
    );
    final avgStreak = habits.isEmpty
        ? 0.0
        : habits.fold<int>(0, (sum, habit) => sum + habit.streak) / habits.length;

    final report = '''
📊 Habit Tracker Report

Total Habits: $totalHabits
Total Completions: $totalCompletions
Average Streak: ${avgStreak.toStringAsFixed(1)} days

Top Habits:
${habits.take(5).map((h) => '• ${h.title}: ${h.streak} day streak').join('\n')}

Generated on ${DateTime.now().toString().split('.')[0]}
''';

    Share.share(report, subject: 'My Habit Tracker Report');
  }
}



