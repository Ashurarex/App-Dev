import 'package:cloud_firestore/cloud_firestore.dart';

class Habit {
  String id;
  final String userId;
  String title;
  String notes;
  bool completed;
  DateTime createdAt;
  String frequency; // daily / weekly / custom
  List<String> completedDates; // List of dates when habit was completed (YYYY-MM-DD format)
  int streak; // Current streak count
  
  // Reminder fields
  bool reminderEnabled;
  int? reminderHour;
  int? reminderMinute;
  List<int>? reminderDays; // Days of week (1=Monday, 7=Sunday)
  String? reminderMessage;
  
  // Customization fields
  String? customIconId;
  int? customColor;

  Habit({
    this.id = '',
    required this.userId,
    required this.title,
    this.notes = '',
    this.completed = false,
    DateTime? createdAt,
    this.frequency = 'daily',
    List<String>? completedDates,
    this.streak = 0,
    this.reminderEnabled = false,
    this.reminderHour,
    this.reminderMinute,
    this.reminderDays,
    this.reminderMessage,
    this.customIconId,
    this.customColor,
  })  : createdAt = createdAt ?? DateTime.now(),
        completedDates = completedDates ?? [];

  int get daysTracked => completedDates.length;

  // Calculate current streak
  int calculateStreak() {
    if (completedDates.isEmpty) return 0;
    
    final sortedDates = completedDates.map((d) => DateTime.parse(d)).toList()
      ..sort((a, b) => b.compareTo(a)); // Sort descending
    
    if (sortedDates.isEmpty) return 0;
    
    int currentStreak = 0;
    DateTime? lastDate = DateTime.now();
    
    // Check if today or yesterday was completed
    final today = DateTime(lastDate.year, lastDate.month, lastDate.day);
    final yesterday = today.subtract(const Duration(days: 1));
    
    final todayStr = today.toIso8601String().split('T')[0];
    final yesterdayStr = yesterday.toIso8601String().split('T')[0];
    
    if (!completedDates.contains(todayStr) && !completedDates.contains(yesterdayStr)) {
      return 0; // No recent completion, streak is broken
    }
    
    // Start counting from most recent completion
    DateTime checkDate = sortedDates[0];
    final checkDateOnly = DateTime(checkDate.year, checkDate.month, checkDate.day);
    
    // If most recent is today or yesterday, start counting
    if (checkDateOnly == today || checkDateOnly == yesterday) {
      currentStreak = 1;
      DateTime expectedDate = checkDateOnly.subtract(const Duration(days: 1));
      
      for (int i = 1; i < sortedDates.length; i++) {
        final dateOnly = DateTime(
          sortedDates[i].year,
          sortedDates[i].month,
          sortedDates[i].day,
        );
        
        if (dateOnly == expectedDate) {
          currentStreak++;
          expectedDate = expectedDate.subtract(const Duration(days: 1));
        } else {
          break; // Streak broken
        }
      }
    }
    
    return currentStreak;
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'userId': userId,
        'title': title,
        'notes': notes,
        'completed': completed,
        'createdAt': createdAt, // Store as DateTime, Firestore will convert to Timestamp
        'frequency': frequency,
        'completedDates': completedDates,
        'streak': streak,
        'reminderEnabled': reminderEnabled,
        'reminderHour': reminderHour,
        'reminderMinute': reminderMinute,
        'reminderDays': reminderDays,
        'reminderMessage': reminderMessage,
        'customIconId': customIconId,
        'customColor': customColor,
      };

  factory Habit.fromMap(Map<String, dynamic> m) {
    DateTime createdAt;
    if (m['createdAt'] == null) {
      createdAt = DateTime.now();
    } else if (m['createdAt'] is DateTime) {
      createdAt = m['createdAt'] as DateTime;
    } else if (m['createdAt'] is Timestamp) {
      createdAt = (m['createdAt'] as Timestamp).toDate();
    } else {
      // Try parsing as string
      try {
        createdAt = DateTime.parse(m['createdAt'].toString());
      } catch (e) {
        createdAt = DateTime.now();
      }
    }
    
    final habit = Habit(
      id: m['id'] ?? '',
      userId: m['userId'] ?? '',
      title: m['title'] ?? '',
      notes: m['notes'] ?? '',
      completed: m['completed'] ?? false,
      createdAt: createdAt,
      frequency: m['frequency'] ?? 'daily',
      completedDates: (m['completedDates'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      streak: m['streak'] ?? 0,
      reminderEnabled: m['reminderEnabled'] ?? false,
      reminderHour: m['reminderHour'],
      reminderMinute: m['reminderMinute'],
      reminderDays: (m['reminderDays'] as List<dynamic>?)
              ?.map((e) => e as int)
              .toList(),
      reminderMessage: m['reminderMessage'],
      customIconId: m['customIconId'],
      customColor: m['customColor'],
    );
    // Recalculate streak from completedDates
    habit.streak = habit.calculateStreak();
    return habit;
  }
}
