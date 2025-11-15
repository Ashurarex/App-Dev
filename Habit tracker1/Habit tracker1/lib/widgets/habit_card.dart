import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../models/habit.dart';
import '../services/firestore_service.dart';
import '../constants/app_theme.dart';
import 'package:flutter_animate/flutter_animate.dart';

class HabitCard extends StatelessWidget {
  final Habit habit;
  const HabitCard({Key? key, required this.habit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final fs = FirestoreService();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Slidable(
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        extentRatio: 0.3,
        children: [
          SlidableAction(
            onPressed: (_) async {
              habit.completed = !habit.completed;

              // Track completion date
              final today = DateTime.now();
              final todayStr = today.toIso8601String().split('T')[0];

              if (habit.completed) {
                // Add today's date if not already present
                if (!habit.completedDates.contains(todayStr)) {
                  habit.completedDates.add(todayStr);
                }
              } else {
                // Remove today's date if uncompleting
                habit.completedDates.remove(todayStr);
              }

              // Recalculate streak
              habit.streak = habit.calculateStreak();

              await fs.updateHabit(habit);
            },
            backgroundColor: AppTheme.success,
            foregroundColor: Colors.white,
            icon: habit.completed ? Icons.close_rounded : Icons.check_rounded,
            label: habit.completed ? 'Undo' : 'Complete',
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          SlidableAction(
            onPressed: (_) => fs.deleteHabit(habit.id),
            backgroundColor: AppTheme.error,
            foregroundColor: Colors.white,
            icon: Icons.delete_rounded,
            label: 'Delete',
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
        ],
      ),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutCubic,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Theme.of(context).cardColor,
          border: habit.completed
              ? Border.all(
                  color: AppTheme.success.withOpacity(0.3),
                  width: 2,
                )
              : null,
          boxShadow: [
            BoxShadow(
              color: habit.completed
                  ? AppTheme.success.withOpacity(0.1)
                  : Colors.black.withOpacity(0.1),
              blurRadius: habit.completed ? 8 : 12,
              offset: const Offset(0, 4),
            ),
          ],
          gradient: habit.completed
              ? LinearGradient(
                  colors: [
                    AppTheme.success.withOpacity(0.1),
                    Colors.transparent,
                  ],
                )
              : null,
        ),
        child: Card(
          elevation: 0,
          color: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  GestureDetector(
                    onTap: () async {
                      habit.completed = !habit.completed;

                      // Track completion date
                      final today = DateTime.now();
                      final todayStr = today.toIso8601String().split('T')[0];

                      if (habit.completed) {
                        // Add today's date if not already present
                        if (!habit.completedDates.contains(todayStr)) {
                          habit.completedDates.add(todayStr);
                        }
                      } else {
                        // Remove today's date if uncompleting
                        habit.completedDates.remove(todayStr);
                      }

                      // Recalculate streak
                      habit.streak = habit.calculateStreak();

                      await fs.updateHabit(habit);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOutCubic,
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: habit.completed
                              ? AppTheme.success
                              : (isDark
                                  ? Colors.grey[600]!
                                  : Colors.grey[300]!),
                          width: 2,
                        ),
                        color: habit.completed
                            ? AppTheme.success
                            : Colors.transparent,
                      ),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        transitionBuilder: (child, animation) {
                          return ScaleTransition(
                            scale: animation,
                            child: child,
                          );
                        },
                        child: habit.completed
                            ? const Icon(
                                Icons.check_rounded,
                                key: ValueKey('check'),
                                color: Colors.white,
                                size: 18,
                              )
                            : const SizedBox(key: ValueKey('empty')),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          habit.title,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            decoration: habit.completed
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                            color: habit.completed
                                ? (isDark
                                    ? Colors.grey[500]
                                    : Colors.grey[600])
                                : (isDark ? Colors.white : Colors.black87),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Wrap(
                          spacing: 8,
                          runSpacing: 4,
                          children: [
                            if (habit.streak > 0)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppTheme.success.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.local_fire_department_rounded,
                                      size: 16,
                                      color: AppTheme.success,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${habit.streak} day${habit.streak == 1 ? '' : 's'}',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: AppTheme.success,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.calendar_today_rounded,
                                    size: 14,
                                    color: AppTheme.primary,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${habit.daysTracked} tracked',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: AppTheme.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        if (habit.notes.isNotEmpty) ...[
                          const SizedBox(height: 6),
                          Text(
                            habit.notes,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14,
                              color: isDark
                                  ? Colors.grey[400]
                                  : Colors.grey[600],
                              decoration: habit.completed
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: _getFrequencyColor(habit.frequency)
                              .withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _getFrequencyIcon(habit.frequency),
                              size: 16,
                              color: _getFrequencyColor(habit.frequency),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              habit.frequency.toUpperCase(),
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: _getFrequencyColor(habit.frequency),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: isDark ? Colors.grey[800] : Colors.grey[100],
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.edit_rounded,
                            size: 22,
                            color: AppTheme.primary,
                          ),
                          padding: const EdgeInsets.all(8),
                          constraints: const BoxConstraints(),
                          onPressed: () {
                            // TODO: open edit form prefilled with habit data
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ).animate().fadeIn(duration: 300.ms).scale(
          begin: const Offset(0.95, 0.95),
          duration: 400.ms,
          curve: Curves.easeOutCubic,
        );
  }

  Color _getFrequencyColor(String frequency) {
    switch (frequency.toLowerCase()) {
      case 'daily':
        return AppTheme.primary;
      case 'weekly':
        return AppTheme.secondary;
      case 'custom':
        return AppTheme.accent;
      default:
        return AppTheme.primary;
    }
  }

  IconData _getFrequencyIcon(String frequency) {
    switch (frequency.toLowerCase()) {
      case 'daily':
        return Icons.today_rounded;
      case 'weekly':
        return Icons.calendar_view_week_rounded;
      case 'custom':
        return Icons.schedule_rounded;
      default:
        return Icons.today_rounded;
    }
  }
}
