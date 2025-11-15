import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import '../models/habit.dart';
import '../services/habit_service.dart';
import '../constants/app_theme.dart';
import 'package:flutter_animate/flutter_animate.dart';

class HabitCard extends StatelessWidget {
  final Habit habit;
  const HabitCard({Key? key, required this.habit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final habitService = Provider.of<HabitService>(context, listen: false);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Slidable(
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        extentRatio: 0.3,
        children: [
          SlidableAction(
            onPressed: (_) async {
              habit.completed = !habit.completed;
              final today = DateTime.now();
              final todayStr = today.toIso8601String().split('T')[0];

              if (habit.completed) {
                if (!habit.completedDates.contains(todayStr)) {
                  habit.completedDates.add(todayStr);
                }
              } else {
                habit.completedDates.remove(todayStr);
              }

              habit.streak = habit.calculateStreak();
              await habitService.updateHabit(habit);
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
            onPressed: (_) => habitService.deleteHabit(habit.id),
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
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Theme.of(context).cardColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        habit.completed = !habit.completed;
                        final today = DateTime.now();
                        final todayStr = today.toIso8601String().split('T')[0];

                        if (habit.completed) {
                          if (!habit.completedDates.contains(todayStr)) {
                            habit.completedDates.add(todayStr);
                          }
                        } else {
                          habit.completedDates.remove(todayStr);
                        }

                        habit.streak = habit.calculateStreak();
                        await habitService.updateHabit(habit);
                      },
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: habit.completed
                                ? AppTheme.success
                                : Colors.grey[400]!,
                            width: 2,
                          ),
                          color: habit.completed
                              ? AppTheme.success
                              : Colors.transparent,
                        ),
                        child: habit.completed
                            ? const Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 16,
                              )
                            : null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        habit.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        habit.frequency.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const SizedBox(width: 40),
                    Expanded(
                      child: Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 12,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${habit.daysTracked} tracked',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey[600],
                            ),
                          ),
                          if (habit.streak > 0) ...[
                            const SizedBox(width: 12),
                            Icon(
                              Icons.local_fire_department,
                              size: 14,
                              color: Colors.orange[700],
                            ),
                            const SizedBox(width: 2),
                            Text(
                              '${habit.streak} day streak',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Colors.orange[700],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/habit-reminder',
                          arguments: habit,
                        );
                      },
                      child: Icon(
                        habit.reminderEnabled
                            ? Icons.notifications_active
                            : Icons.notifications_none,
                        size: 20,
                        color: habit.reminderEnabled
                            ? AppTheme.accent
                            : Colors.grey[400],
                      ),
                    ),
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/habit-details',
                          arguments: habit,
                        );
                      },
                      child: const Icon(
                        Icons.arrow_forward,
                        size: 20,
                        color: AppTheme.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 300.ms)
        .slideX(begin: 0.1, duration: 300.ms);
  }
}
