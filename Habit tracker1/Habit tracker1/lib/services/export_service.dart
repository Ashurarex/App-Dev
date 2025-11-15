import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/habit.dart';

class ExportService {
  /// Export habits to JSON format
  Future<String> exportToJson(List<Habit> habits) async {
    final data = {
      'exportDate': DateTime.now().toIso8601String(),
      'totalHabits': habits.length,
      'habits': habits.map((h) => {
        'title': h.title,
        'notes': h.notes,
        'frequency': h.frequency,
        'streak': h.streak,
        'daysTracked': h.daysTracked,
        'completedDates': h.completedDates,
        'createdAt': h.createdAt.toIso8601String(),
      }).toList(),
    };
    return const JsonEncoder.withIndent('  ').convert(data);
  }

  /// Export habits to CSV format
  String exportToCsv(List<Habit> habits) {
    final buffer = StringBuffer();
    buffer.writeln('Title,Notes,Frequency,Streak,Days Tracked,Created At');
    
    for (final habit in habits) {
      buffer.writeln([
        _escapeCsv(habit.title),
        _escapeCsv(habit.notes),
        habit.frequency,
        habit.streak.toString(),
        habit.daysTracked.toString(),
        habit.createdAt.toIso8601String(),
      ].join(','));
    }
    
    return buffer.toString();
  }

  String _escapeCsv(String value) {
    if (value.contains(',') || value.contains('"') || value.contains('\n')) {
      return '"${value.replaceAll('"', '""')}"';
    }
    return value;
  }

  /// Copy to clipboard
  Future<void> copyToClipboard(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
  }
}

