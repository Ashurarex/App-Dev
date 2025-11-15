import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReminderService extends ChangeNotifier {
  static const _keyEnabled = 'reminder_enabled';
  static const _keyHour = 'reminder_hour';
  static const _keyMinute = 'reminder_minute';

  bool enabled = false;
  int hour = 9;
  int minute = 0;

  ReminderService() {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    enabled = prefs.getBool(_keyEnabled) ?? false;
    hour = prefs.getInt(_keyHour) ?? 9;
    minute = prefs.getInt(_keyMinute) ?? 0;
    notifyListeners();
  }

  Future<void> setEnabled(bool v) async {
    enabled = v;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyEnabled, v);
    notifyListeners();
  }

  Future<void> setTime(int h, int m) async {
    hour = h;
    minute = m;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyHour, h);
    await prefs.setInt(_keyMinute, m);
    notifyListeners();
  }
}