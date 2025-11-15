import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/premium_screen.dart';
import 'screens/advanced_analytics_screen.dart';
import 'screens/statistics_screen.dart';
import 'screens/calendar_screen.dart';
import 'screens/achievements_screen.dart';
import 'screens/habit_reminder_screen.dart';
import 'screens/habit_details_screen.dart';
import 'screens/theme_customization_screen.dart';
import 'models/habit.dart';

class Routes {
  static const String splash = '/';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String dashboard = '/dashboard';
  static const String profile = '/profile';
  static const String premium = '/premium';
  static const String advancedAnalytics = '/advanced-analytics';
  static const String statistics = '/statistics';
  static const String calendar = '/calendar';
  static const String achievements = '/achievements';
  static const String habitReminder = '/habit-reminder';
  static const String habitDetails = '/habit-details';
  static const String themeCustomization = '/theme-customization';

  static final Map<String, WidgetBuilder> map = {
    splash: (_) => const SplashScreen(),
    login: (_) => const LoginScreen(),
    signup: (_) => const SignupScreen(),
    dashboard: (_) => const DashboardScreen(),
    profile: (_) => const ProfileScreen(),
    premium: (_) => const PremiumScreen(),
    advancedAnalytics: (_) => const AdvancedAnalyticsScreen(),
    statistics: (_) => const StatisticsScreen(),
    calendar: (_) => const CalendarScreen(),
    achievements: (_) => const AchievementsScreen(),
    themeCustomization: (_) => const ThemeCustomizationScreen(),
  };

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    if (settings.name == habitReminder) {
      final habit = settings.arguments as Habit;
      return MaterialPageRoute(
        builder: (_) => HabitReminderScreen(habit: habit),
      );
    }
    if (settings.name == habitDetails) {
      final habit = settings.arguments as Habit;
      return MaterialPageRoute(
        builder: (_) => HabitDetailsScreen(habit: habit),
      );
    }
    return null;
  }
}
