# Enhanced Reminder System Setup Guide

## Overview

Your habit tracker now has a comprehensive reminder system with:
- ✅ Per-habit custom reminders
- ✅ Time-based notifications
- ✅ Day-of-week selection
- ✅ Custom reminder messages
- ✅ Daily summary notifications
- ✅ Streak warning notifications
- ✅ Sound and vibration control

## What Was Added

### 1. New Models
- `lib/models/habit_reminder.dart` - Reminder data model

### 2. Enhanced Services
- `lib/services/enhanced_notification_service.dart` - Full notification system with:
  - Scheduled reminders
  - Daily summaries
  - Streak warnings
  - Instant notifications

### 3. New Screen
- `lib/screens/habit_reminder_screen.dart` - Beautiful UI for setting reminders

### 4. Updated Models
- `lib/models/habit.dart` - Added reminder fields:
  - `reminderEnabled`
  - `reminderHour`
  - `reminderMinute`
  - `reminderDays`
  - `reminderMessage`

### 5. Updated Components
- `lib/widgets/habit_card.dart` - Added reminder button
- `lib/routes.dart` - Added reminder screen route
- `lib/main.dart` - Added route generation

## Setup Instructions

### 1. Install Dependencies

```bash
flutter pub get
```

New packages added:
- `flutter_local_notifications: ^17.0.0` - Local notifications
- `timezone: ^0.9.2` - Timezone support
- `permission_handler: ^11.0.1` - Permission management

### 2. Android Configuration

The `AndroidManifest.xml` has been created with required permissions:
- `POST_NOTIFICATIONS` - Show notifications
- `SCHEDULE_EXACT_ALARM` - Exact timing
- `RECEIVE_BOOT_COMPLETED` - Persist after reboot
- `VIBRATE` - Vibration support

### 3. iOS Configuration

Add to `ios/Runner/Info.plist`:

```xml
<key>UIBackgroundModes</key>
<array>
    <string>fetch</string>
    <string>remote-notification</string>
</array>
<key>NSUserNotificationsUsageDescription</key>
<string>We need notification permission to remind you about your habits</string>
```

### 4. Initialize Notification Service

The service is automatically initialized when first used. No manual setup needed!

## Features

### 1. Per-Habit Reminders

Each habit can have its own reminder with:
- **Custom time** - Set any time of day
- **Days of week** - Choose which days (Mon-Sun)
- **Custom message** - Personalize the notification text
- **Enable/disable** - Toggle reminders on/off

### 2. Smart Scheduling

- Reminders repeat weekly on selected days
- Automatically reschedules after device reboot
- Handles timezone changes
- Exact alarm timing (not approximate)

### 3. Daily Summary

Schedule a daily summary notification showing:
- Total habits
- Completed habits
- Motivational message

### 4. Streak Warnings

Get notified when you're at risk of breaking a streak:
- Customizable time
- Shows current streak count
- Motivates you to maintain consistency

### 5. Instant Notifications

Show immediate notifications for:
- Habit completion celebrations
- Milestone achievements
- Important updates

## Usage

### Setting Up a Reminder

1. **Open Dashboard** - View your habits
2. **Tap Bell Icon** - On any habit card
3. **Enable Reminder** - Toggle the switch
4. **Set Time** - Choose when to be reminded
5. **Select Days** - Pick which days of the week
6. **Custom Message** (optional) - Add personal touch
7. **Save** - Reminder is scheduled!

### Managing Reminders

- **Edit**: Tap the bell icon again to modify
- **Disable**: Toggle off the reminder switch
- **Delete**: Disable reminder or delete the habit

### Viewing Pending Notifications

```dart
final service = EnhancedNotificationService();
final pending = await service.getPendingNotifications();
print('Pending: ${pending.length} notifications');
```

## API Reference

### Schedule Habit Reminder

```dart
final service = EnhancedNotificationService();

final reminder = HabitReminder(
  id: 'unique-id',
  habitId: habit.id,
  habitTitle: habit.title,
  hour: 9,
  minute: 0,
  enabled: true,
  daysOfWeek: [1, 2, 3, 4, 5], // Weekdays
  customMessage: 'Time to exercise!',
);

await service.scheduleHabitReminder(reminder);
```

### Schedule Daily Summary

```dart
await service.scheduleDailySummary(
  hour: 20,
  minute: 0,
  totalHabits: 5,
  completedHabits: 3,
);
```

### Schedule Streak Warning

```dart
await service.scheduleStreakReminder(
  habitTitle: 'Exercise',
  streak: 7,
  hour: 21,
  minute: 0,
);
```

### Show Instant Notification

```dart
await service.showInstantNotification(
  title: '🎉 Congratulations!',
  body: 'You completed all habits today!',
);
```

### Cancel Reminders

```dart
// Cancel specific reminder
await service.cancelReminder(reminderId);

// Cancel all reminders
await service.cancelAllReminders();
```

## Notification Channels

The app uses separate channels for different notification types:

1. **habit_reminders** - Individual habit reminders
2. **daily_summary** - Daily completion summaries
3. **streak_reminders** - Streak maintenance warnings
4. **instant_notifications** - Immediate notifications

## Permissions

### Android 13+ (API 33+)

Automatically requests `POST_NOTIFICATIONS` permission on first use.

### iOS

Requests notification permissions on first use with:
- Alert
- Badge
- Sound

## Testing

### Test Notifications Locally

```dart
// Test instant notification
final service = EnhancedNotificationService();
await service.showInstantNotification(
  title: 'Test Notification',
  body: 'This is a test!',
);
```

### Test Scheduled Notification

Set a reminder for 1 minute from now and wait to see if it appears.

### Check Pending Notifications

```dart
final pending = await service.getPendingNotifications();
for (var notification in pending) {
  print('ID: ${notification.id}');
  print('Title: ${notification.title}');
  print('Body: ${notification.body}');
}
```

## Troubleshooting

### Notifications Not Showing

1. **Check Permissions**
   - Android: Settings → Apps → Habitual → Notifications
   - iOS: Settings → Habitual → Notifications

2. **Check Battery Optimization**
   - Android: Disable battery optimization for the app
   - Settings → Battery → Battery Optimization

3. **Check Do Not Disturb**
   - Ensure DND is off or app is allowed

### Reminders Not Persisting After Reboot

- Ensure `RECEIVE_BOOT_COMPLETED` permission is in AndroidManifest.xml
- Check that the boot receiver is registered

### Wrong Timezone

The app uses device timezone automatically. If issues persist:
```dart
import 'package:timezone/timezone.dart' as tz;
tz.setLocalLocation(tz.getLocation('Your/Timezone'));
```

## Best Practices

1. **Request Permissions Early** - Ask when user first enables a reminder
2. **Clear Messaging** - Explain why notifications are needed
3. **Respect User Preferences** - Allow easy disable/enable
4. **Test Thoroughly** - Test on different Android versions and iOS
5. **Handle Errors Gracefully** - Catch and log notification errors

## Future Enhancements

Consider adding:
- [ ] Notification sound selection
- [ ] Notification priority levels
- [ ] Snooze functionality
- [ ] Smart timing (ML-based optimal times)
- [ ] Notification history
- [ ] Batch notification management
- [ ] Notification templates
- [ ] Rich notifications with actions

## Platform-Specific Notes

### Android

- Requires exact alarm permission on Android 12+
- Notifications may be delayed on some devices with aggressive battery optimization
- Test on multiple manufacturers (Samsung, Xiaomi, etc.)

### iOS

- Notifications require explicit user permission
- Background notifications may be delayed
- Test on both simulator and real device

## Support

If you encounter issues:
1. Check device notification settings
2. Verify permissions are granted
3. Check app logs for errors
4. Test with instant notifications first
5. Ensure timezone is set correctly

## Summary

Your habit tracker now has a professional-grade reminder system that:
- ✅ Sends timely notifications
- ✅ Respects user preferences
- ✅ Works across device reboots
- ✅ Handles timezones correctly
- ✅ Provides beautiful UI for management
- ✅ Supports multiple notification types

Users can now stay on track with their habits through smart, customizable reminders! 🎯
