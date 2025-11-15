class HabitReminder {
  final String id;
  final String habitId;
  final String habitTitle;
  final int hour;
  final int minute;
  final bool enabled;
  final List<int> daysOfWeek; // 1=Monday, 7=Sunday
  final String? customMessage;
  final bool soundEnabled;
  final bool vibrationEnabled;

  HabitReminder({
    required this.id,
    required this.habitId,
    required this.habitTitle,
    required this.hour,
    required this.minute,
    this.enabled = true,
    List<int>? daysOfWeek,
    this.customMessage,
    this.soundEnabled = true,
    this.vibrationEnabled = true,
  }) : daysOfWeek = daysOfWeek ?? [1, 2, 3, 4, 5, 6, 7]; // All days by default

  Map<String, dynamic> toMap() => {
        'id': id,
        'habitId': habitId,
        'habitTitle': habitTitle,
        'hour': hour,
        'minute': minute,
        'enabled': enabled,
        'daysOfWeek': daysOfWeek,
        'customMessage': customMessage,
        'soundEnabled': soundEnabled,
        'vibrationEnabled': vibrationEnabled,
      };

  factory HabitReminder.fromMap(Map<String, dynamic> map) {
    return HabitReminder(
      id: map['id'] ?? '',
      habitId: map['habitId'] ?? '',
      habitTitle: map['habitTitle'] ?? '',
      hour: map['hour'] ?? 9,
      minute: map['minute'] ?? 0,
      enabled: map['enabled'] ?? true,
      daysOfWeek: (map['daysOfWeek'] as List<dynamic>?)
              ?.map((e) => e as int)
              .toList() ??
          [1, 2, 3, 4, 5, 6, 7],
      customMessage: map['customMessage'],
      soundEnabled: map['soundEnabled'] ?? true,
      vibrationEnabled: map['vibrationEnabled'] ?? true,
    );
  }

  HabitReminder copyWith({
    String? id,
    String? habitId,
    String? habitTitle,
    int? hour,
    int? minute,
    bool? enabled,
    List<int>? daysOfWeek,
    String? customMessage,
    bool? soundEnabled,
    bool? vibrationEnabled,
  }) {
    return HabitReminder(
      id: id ?? this.id,
      habitId: habitId ?? this.habitId,
      habitTitle: habitTitle ?? this.habitTitle,
      hour: hour ?? this.hour,
      minute: minute ?? this.minute,
      enabled: enabled ?? this.enabled,
      daysOfWeek: daysOfWeek ?? this.daysOfWeek,
      customMessage: customMessage ?? this.customMessage,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
    );
  }

  String get timeString {
    final h = hour.toString().padLeft(2, '0');
    final m = minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  String get daysString {
    if (daysOfWeek.length == 7) return 'Every day';
    if (daysOfWeek.length == 5 &&
        daysOfWeek.contains(1) &&
        daysOfWeek.contains(2) &&
        daysOfWeek.contains(3) &&
        daysOfWeek.contains(4) &&
        daysOfWeek.contains(5)) {
      return 'Weekdays';
    }
    if (daysOfWeek.length == 2 &&
        daysOfWeek.contains(6) &&
        daysOfWeek.contains(7)) {
      return 'Weekends';
    }

    const dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return daysOfWeek.map((d) => dayNames[d - 1]).join(', ');
  }
}
