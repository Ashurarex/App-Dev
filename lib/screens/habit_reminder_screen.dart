import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/habit.dart';
import '../models/habit_reminder.dart';
import '../services/habit_service.dart';
import '../services/enhanced_notification_service.dart';
import '../constants/app_theme.dart';
import 'package:flutter_animate/flutter_animate.dart';

class HabitReminderScreen extends StatefulWidget {
  final Habit habit;

  const HabitReminderScreen({Key? key, required this.habit}) : super(key: key);

  @override
  State<HabitReminderScreen> createState() => _HabitReminderScreenState();
}

class _HabitReminderScreenState extends State<HabitReminderScreen> {
  late bool _reminderEnabled;
  late TimeOfDay _selectedTime;
  late Set<int> _selectedDays;
  late TextEditingController _messageController;
  final _notificationService = EnhancedNotificationService();
  bool _permissionGranted = false;

  @override
  void initState() {
    super.initState();
    _reminderEnabled = widget.habit.reminderEnabled;
    _selectedTime = TimeOfDay(
      hour: widget.habit.reminderHour ?? 9,
      minute: widget.habit.reminderMinute ?? 0,
    );
    _selectedDays = (widget.habit.reminderDays ?? [1, 2, 3, 4, 5, 6, 7]).toSet();
    _messageController = TextEditingController(
      text: widget.habit.reminderMessage ?? '',
    );
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    final granted = await _notificationService.requestPermissions();
    setState(() {
      _permissionGranted = granted;
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Set Reminder',
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
                    const Color(0xFF1E293B),
                    const Color(0xFF334155),
                    const Color(0xFF475569),
                  ]
                : [
                    const Color(0xFFF0F9FF),
                    const Color(0xFFE0F2FE),
                    const Color(0xFFBAE6FD),
                  ],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Habit Info Card
              _buildHabitInfoCard(isDark),
              const SizedBox(height: 24),

              // Permission Warning
              if (!_permissionGranted)
                _buildPermissionWarning(isDark)
                    .animate()
                    .fadeIn()
                    .shake(),
              if (!_permissionGranted) const SizedBox(height: 16),

              // Enable Reminder Toggle
              _buildEnableToggle(isDark),
              const SizedBox(height: 24),

              if (_reminderEnabled) ...[
                // Time Picker
                _buildTimePicker(isDark),
                const SizedBox(height: 24),

                // Days of Week
                _buildDaysSelector(isDark),
                const SizedBox(height: 24),

                // Custom Message
                _buildCustomMessage(isDark),
                const SizedBox(height: 32),

                // Save Button
                _buildSaveButton(isDark),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHabitInfoCard(bool isDark) {
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
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppTheme.primary, AppTheme.secondary],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.notifications_active_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.habit.title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Set up reminders for this habit',
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
    ).animate().fadeIn().scale();
  }

  Widget _buildPermissionWarning(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.orange, width: 2),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning_rounded, color: Colors.orange, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Notification Permission Required',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Please enable notifications to receive reminders',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.grey[400] : Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: _checkPermissions,
            child: const Text('Enable'),
          ),
        ],
      ),
    );
  }

  Widget _buildEnableToggle(bool isDark) {
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
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            _reminderEnabled ? Icons.alarm_on_rounded : Icons.alarm_off_rounded,
            color: _reminderEnabled ? AppTheme.success : Colors.grey,
            size: 28,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Enable Reminder',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                Text(
                  _reminderEnabled ? 'Reminders are active' : 'No reminders set',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: _reminderEnabled,
            onChanged: (value) {
              setState(() {
                _reminderEnabled = value;
              });
            },
            activeColor: AppTheme.success,
          ),
        ],
      ),
    ).animate().fadeIn(delay: 100.ms);
  }

  Widget _buildTimePicker(bool isDark) {
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
            color: Colors.black.withOpacity(0.05),
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
              const Icon(Icons.access_time_rounded, color: AppTheme.primary),
              const SizedBox(width: 12),
              Text(
                'Reminder Time',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          InkWell(
            onTap: () async {
              final time = await showTimePicker(
                context: context,
                initialTime: _selectedTime,
              );
              if (time != null) {
                setState(() {
                  _selectedTime = time;
                });
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppTheme.primary, AppTheme.secondary],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.schedule_rounded, color: Colors.white),
                  const SizedBox(width: 12),
                  Text(
                    _selectedTime.format(context),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms);
  }

  Widget _buildDaysSelector(bool isDark) {
    const days = [
      {'num': 1, 'name': 'Mon'},
      {'num': 2, 'name': 'Tue'},
      {'num': 3, 'name': 'Wed'},
      {'num': 4, 'name': 'Thu'},
      {'num': 5, 'name': 'Fri'},
      {'num': 6, 'name': 'Sat'},
      {'num': 7, 'name': 'Sun'},
    ];

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
            color: Colors.black.withOpacity(0.05),
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
              const Icon(Icons.calendar_today_rounded, color: AppTheme.primary),
              const SizedBox(width: 12),
              Text(
                'Repeat On',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: days.map((day) {
              final isSelected = _selectedDays.contains(day['num']);
              return InkWell(
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      _selectedDays.remove(day['num']);
                    } else {
                      _selectedDays.add(day['num'] as int);
                    }
                  });
                },
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: isSelected
                        ? const LinearGradient(
                            colors: [AppTheme.primary, AppTheme.secondary],
                          )
                        : null,
                    color: isSelected
                        ? null
                        : (isDark ? Colors.grey[700] : Colors.grey[200]),
                    shape: BoxShape.circle,
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: AppTheme.primary.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                  child: Center(
                    child: Text(
                      day['name'] as String,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: isSelected
                            ? Colors.white
                            : (isDark ? Colors.grey[400] : Colors.grey[700]),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 300.ms);
  }

  Widget _buildCustomMessage(bool isDark) {
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
            color: Colors.black.withOpacity(0.05),
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
              const Icon(Icons.message_rounded, color: AppTheme.primary),
              const SizedBox(width: 12),
              Text(
                'Custom Message (Optional)',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _messageController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'e.g., Time to work on your goals!',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: isDark ? Colors.grey[800] : Colors.grey[50],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 400.ms);
  }

  Widget _buildSaveButton(bool isDark) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _saveReminder,
        icon: const Icon(Icons.save_rounded, color: Colors.white),
        label: const Text(
          'Save Reminder',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 18),
          backgroundColor: AppTheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    ).animate().fadeIn(delay: 500.ms).scale();
  }

  Future<void> _saveReminder() async {
    if (_selectedDays.isEmpty && _reminderEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one day'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Update habit with reminder settings
    widget.habit.reminderEnabled = _reminderEnabled;
    widget.habit.reminderHour = _selectedTime.hour;
    widget.habit.reminderMinute = _selectedTime.minute;
    widget.habit.reminderDays = _selectedDays.toList()..sort();
    widget.habit.reminderMessage = _messageController.text.trim().isEmpty
        ? null
        : _messageController.text.trim();

    // Save to database
    final habitService = Provider.of<HabitService>(context, listen: false);
    await habitService.updateHabit(widget.habit);

    // Schedule/cancel notifications
    if (_reminderEnabled && _permissionGranted) {
      final reminder = HabitReminder(
        id: widget.habit.id,
        habitId: widget.habit.id,
        habitTitle: widget.habit.title,
        hour: _selectedTime.hour,
        minute: _selectedTime.minute,
        enabled: true,
        daysOfWeek: widget.habit.reminderDays!,
        customMessage: widget.habit.reminderMessage,
      );
      await _notificationService.scheduleHabitReminder(reminder);
    } else {
      await _notificationService.cancelReminder(widget.habit.id);
    }

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _reminderEnabled
              ? '✓ Reminder set successfully!'
              : '✓ Reminder disabled',
        ),
        backgroundColor: AppTheme.success,
      ),
    );

    Navigator.pop(context);
  }
}
