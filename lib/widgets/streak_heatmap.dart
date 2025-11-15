import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/habit.dart';
import '../constants/app_theme.dart';
import 'package:flutter_animate/flutter_animate.dart';

class StreakHeatmap extends StatelessWidget {
  final Habit habit;
  final int weeks;

  const StreakHeatmap({
    Key? key,
    required this.habit,
    this.weeks = 12,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final today = DateTime.now();
    final startDate = today.subtract(Duration(days: weeks * 7));

    // Create a map of dates to completion status
    final completionMap = <String, bool>{};
    for (var dateStr in habit.completedDates) {
      completionMap[dateStr] = true;
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [Colors.grey[850]!, Colors.grey[800]!]
              : [Colors.white, const Color(0xFFF0F9FF)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppTheme.primary, AppTheme.secondary],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.grid_on_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Activity Heatmap',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              const Spacer(),
              Text(
                '${habit.completedDates.length} days',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.success,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Month labels
          _buildMonthLabels(startDate, today, isDark),
          const SizedBox(height: 8),
          // Heatmap grid
          _buildHeatmapGrid(startDate, today, completionMap, isDark),
          const SizedBox(height: 16),
          // Legend
          _buildLegend(isDark),
        ],
      ),
    );
  }

  Widget _buildMonthLabels(DateTime start, DateTime end, bool isDark) {
    final months = <String>[];
    var current = DateTime(start.year, start.month, 1);
    final endMonth = DateTime(end.year, end.month, 1);

    while (current.isBefore(endMonth) || current.isAtSameMomentAs(endMonth)) {
      months.add(DateFormat('MMM').format(current));
      current = DateTime(current.year, current.month + 1, 1);
    }

    return Row(
      children: [
        const SizedBox(width: 30), // Space for day labels
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: months.map((month) {
              return Text(
                month,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildHeatmapGrid(
    DateTime start,
    DateTime end,
    Map<String, bool> completionMap,
    bool isDark,
  ) {
    // Build grid by weeks
    final weeks = <List<DateTime>>[];
    var currentDate = start;

    // Align to Monday
    while (currentDate.weekday != DateTime.monday) {
      currentDate = currentDate.subtract(const Duration(days: 1));
    }

    while (currentDate.isBefore(end) || currentDate.isAtSameMomentAs(end)) {
      final week = <DateTime>[];
      for (int i = 0; i < 7; i++) {
        week.add(currentDate);
        currentDate = currentDate.add(const Duration(days: 1));
      }
      weeks.add(week);
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Day labels
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: ['Mon', 'Wed', 'Fri'].map((day) {
            return Container(
              height: 16,
              margin: const EdgeInsets.only(bottom: 4),
              child: Text(
                day,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(width: 8),
        // Heatmap cells
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: weeks.asMap().entries.map((entry) {
                final weekIndex = entry.key;
                final week = entry.value;
                return Column(
                  children: week.asMap().entries.map((dayEntry) {
                    final dayIndex = dayEntry.key;
                    final date = dayEntry.value;
                    final dateStr = date.toIso8601String().split('T')[0];
                    final isCompleted = completionMap[dateStr] ?? false;
                    final isFuture = date.isAfter(DateTime.now());
                    final isToday = dateStr ==
                        DateTime.now().toIso8601String().split('T')[0];

                    // Only show Mon, Wed, Fri labels
                    final showDay = dayIndex == 0 || dayIndex == 2 || dayIndex == 4;

                    return Tooltip(
                      message: '${DateFormat('MMM d, yyyy').format(date)}\n${isCompleted ? 'Completed ✓' : 'Not completed'}',
                      child: Container(
                        width: 14,
                        height: showDay ? 14 : 14,
                        margin: const EdgeInsets.only(right: 4, bottom: 4),
                        decoration: BoxDecoration(
                          color: isFuture
                              ? (isDark ? Colors.grey[800] : Colors.grey[200])
                              : isCompleted
                                  ? _getIntensityColor(isToday)
                                  : (isDark
                                      ? Colors.grey[800]
                                      : Colors.grey[200]),
                          borderRadius: BorderRadius.circular(3),
                          border: isToday
                              ? Border.all(
                                  color: AppTheme.accent,
                                  width: 2,
                                )
                              : null,
                        ),
                      ).animate(delay: (weekIndex * 50 + dayIndex * 10).ms).fadeIn().scale(
                            begin: const Offset(0.8, 0.8),
                          ),
                    );
                  }).toList(),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLegend(bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          'Less',
          style: TextStyle(
            fontSize: 11,
            color: isDark ? Colors.grey[400] : Colors.grey[600],
          ),
        ),
        const SizedBox(width: 8),
        ...List.generate(5, (index) {
          return Container(
            width: 14,
            height: 14,
            margin: const EdgeInsets.only(left: 4),
            decoration: BoxDecoration(
              color: index == 0
                  ? (isDark ? Colors.grey[800] : Colors.grey[200])
                  : _getIntensityColor(false, intensity: index / 4),
              borderRadius: BorderRadius.circular(3),
            ),
          );
        }),
        const SizedBox(width: 8),
        Text(
          'More',
          style: TextStyle(
            fontSize: 11,
            color: isDark ? Colors.grey[400] : Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Color _getIntensityColor(bool isToday, {double intensity = 1.0}) {
    if (isToday) {
      return AppTheme.accent;
    }
    return Color.lerp(
      const Color(0xFF86EFAC), // Light green
      const Color(0xFF10B981), // Dark green
      intensity,
    )!;
  }
}
