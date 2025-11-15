import 'dart:async';
import '../models/habit.dart';
import 'firestore_service.dart';
import 'api_service.dart';
import '../config/api_config.dart';

/// Unified service that can use either Firebase or REST API
class HabitService {
  final FirestoreService _firestoreService;
  final ApiService _apiService;

  HabitService(this._firestoreService, this._apiService);

  bool get useRestApi => ApiConfig.useRestApi;

  // Create habit
  Future<String> createHabit(Habit habit) async {
    if (useRestApi) {
      final created = await _apiService.createHabit(habit);
      return created.id;
    } else {
      return await _firestoreService.createHabit(habit);
    }
  }

  // Stream habits (for Firebase) or poll habits (for REST API)
  Stream<List<Habit>> streamHabits(String userId) {
    if (useRestApi) {
      // Convert REST API polling to stream
      return Stream.periodic(const Duration(seconds: 2))
          .asyncMap((_) => _apiService.getHabits())
          .handleError((error) {
        print('Error fetching habits: $error');
        return <Habit>[];
      });
    } else {
      return _firestoreService.streamHabits(userId);
    }
  }

  // Get habits once (useful for REST API)
  Future<List<Habit>> getHabits() async {
    if (useRestApi) {
      return await _apiService.getHabits();
    } else {
      // For Firebase, we need to convert stream to future
      return await _firestoreService
          .streamHabits('')
          .first
          .timeout(const Duration(seconds: 10));
    }
  }

  // Update habit
  Future<void> updateHabit(Habit habit) async {
    if (useRestApi) {
      await _apiService.updateHabit(habit);
    } else {
      await _firestoreService.updateHabit(habit);
    }
  }

  // Toggle habit completion
  Future<Habit> toggleHabitCompletion(String habitId, {String? date}) async {
    if (useRestApi) {
      return await _apiService.toggleHabitCompletion(habitId, date: date);
    } else {
      // For Firebase, we need to fetch, modify, and update
      throw UnimplementedError(
          'Toggle via Firebase should be done through updateHabit');
    }
  }

  // Delete habit
  Future<void> deleteHabit(String id) async {
    if (useRestApi) {
      await _apiService.deleteHabit(id);
    } else {
      await _firestoreService.deleteHabit(id);
    }
  }

  // User settings
  Future<String?> getDisplayName(String userId) async {
    if (useRestApi) {
      final settings = await _apiService.getUserSettings();
      return settings['displayName'] as String?;
    } else {
      return await _firestoreService.getDisplayName(userId);
    }
  }

  Future<Map<String, dynamic>?> getUserSettings(String userId) async {
    if (useRestApi) {
      return await _apiService.getUserSettings();
    } else {
      return await _firestoreService.getUserSettings(userId);
    }
  }

  Future<void> setUserSettings(
    String userId, {
    String? displayName,
    int? accentColorValue,
    int? avatarIconCodePoint,
    int? avatarColorValue,
  }) async {
    if (useRestApi) {
      await _apiService.updateUserSettings(
        displayName: displayName,
        accentColorValue: accentColorValue,
        avatarIconCodePoint: avatarIconCodePoint,
        avatarColorValue: avatarColorValue,
      );
    } else {
      await _firestoreService.setUserSettings(
        userId,
        displayName: displayName,
        accentColorValue: accentColorValue,
        avatarIconCodePoint: avatarIconCodePoint,
        avatarColorValue: avatarColorValue,
      );
    }
  }

  // Premium status
  Future<Map<String, dynamic>?> getPremiumStatus(String userId) async {
    if (useRestApi) {
      return await _apiService.getPremiumStatus();
    } else {
      return await _firestoreService.getPremiumStatus(userId);
    }
  }

  Future<void> setPremiumStatus(
    String userId, {
    bool? isPremium,
    DateTime? expiry,
    String? plan,
  }) async {
    if (useRestApi) {
      await _apiService.updatePremiumStatus(
        isPremium: isPremium,
        premiumPlan: plan,
        premiumExpiry: expiry,
      );
    } else {
      await _firestoreService.setPremiumStatus(
        userId,
        isPremium: isPremium,
        expiry: expiry,
        plan: plan,
      );
    }
  }
}
