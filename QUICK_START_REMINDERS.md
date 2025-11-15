# Quick Start: Enhanced Reminders 🔔

## What's New?

Your habit tracker now has a powerful reminder system! Each habit can have custom reminders with:
- ⏰ Custom time selection
- 📅 Day-of-week scheduling
- 💬 Personalized messages
- 🔔 Sound & vibration control

## Setup (2 minutes)

### 1. Install Dependencies
```bash
flutter pub get
```

### 2. iOS Setup (iOS only)
Add to `ios/Runner/Info.plist`:
```xml
<key>NSUserNotificationsUsageDescription</key>
<string>We need notification permission to remind you about your habits</string>
```

### 3. Run the App
```bash
flutter run
```

That's it! The Android configuration is already done.

## How to Use

### Setting a Reminder

1. **Open your app** and go to Dashboard
2. **Tap the bell icon** 🔔 on any habit card
3. **Enable the reminder** toggle
4. **Set your preferred time** (e.g., 9:00 AM)
5. **Choose days** (Mon-Sun, or select specific days)
6. **Add custom message** (optional)
7. **Tap "Save Reminder"**

Done! You'll now get notifications at your chosen time.

### Example Use Cases

**Morning Exercise**
- Time: 7:00 AM
- Days: Mon, Wed, Fri
- Message: "Time to get moving! 💪"

**Evening Reading**
- Time: 8:00 PM
- Days: Every day
- Message: "30 minutes of reading before bed 📚"

**Weekday Meditation**
- Time: 6:30 AM
- Days: Mon-Fri
- Message: "Start your day with mindfulness 🧘"

## Features

### Per-Habit Reminders
- Each habit has its own reminder settings
- Enable/disable anytime
- Edit without losing settings

### Smart Scheduling
- Repeats weekly on selected days
- Survives app restarts
- Handles timezone changes

### Visual Indicators
- Bell icon shows reminder status
- Active reminders show filled bell 🔔
- Inactive show outline bell 🔕

## Testing

### Test Immediately
```dart
// In your code, add this to test:
final service = EnhancedNotificationService();
await service.showInstantNotification(
  title: '🎉 Test',
  body: 'Notifications are working!',
);
```

### Test Scheduled Reminder
1. Set a reminder for 1 minute from now
2. Close the app
3. Wait for notification

## Troubleshooting

### Not Receiving Notifications?

**Android:**
1. Go to Settings → Apps → Habitual → Notifications
2. Ensure notifications are enabled
3. Check "Do Not Disturb" is off

**iOS:**
1. Go to Settings → Habitual → Notifications
2. Enable "Allow Notifications"
3. Check notification style preferences

### Notifications Delayed?

Some Android devices (Samsung, Xiaomi) have aggressive battery optimization:
1. Settings → Battery → Battery Optimization
2. Find "Habitual"
3. Select "Don't optimize"

## What's Next?

Future enhancements coming:
- Daily summary notifications
- Streak warning alerts
- Smart timing suggestions
- Notification history
- Snooze functionality

## Need Help?

Check the full documentation in `REMINDER_SETUP.md` for:
- Detailed API reference
- Advanced configuration
- Platform-specific notes
- Troubleshooting guide

---

**Enjoy your new reminder system! 🎯**

Never miss a habit again with smart, personalized notifications.
