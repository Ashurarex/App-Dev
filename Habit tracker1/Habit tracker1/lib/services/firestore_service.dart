import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/foundation.dart';
import '../models/habit.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String habitsCollection = 'habits';
  final String usersCollection = 'users';

  Future<String> createHabit(Habit habit) async {
    final id = const Uuid().v4();
    habit.id = id; // Set the ID on the habit object
    await _db.collection(habitsCollection).doc(id).set(habit.toMap());
    return id;
  }

  Stream<List<Habit>> streamHabits(String userId) {
    // Query without orderBy first to avoid index issues, then sort manually
    return _db
        .collection(habitsCollection)
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
          debugPrint('Stream update: ${snapshot.docs.length} documents');
          if (snapshot.docs.isEmpty) {
            return <Habit>[];
          }
          final habits = snapshot.docs.map((d) {
            final data = d.data();
            data['id'] = d.id; // Ensure ID is set from document ID
            debugPrint('Habit data: ${data['title']}, id: ${data['id']}');
            return Habit.fromMap(data);
          }).toList();
          // Sort manually by createdAt (newest first)
          habits.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          debugPrint('Returning ${habits.length} habits');
          return habits;
        });
  }

  Future<void> updateHabit(Habit habit) async {
    await _db.collection(habitsCollection).doc(habit.id).update(habit.toMap());
  }

  Future<void> deleteHabit(String id) async {
    await _db.collection(habitsCollection).doc(id).delete();
  }

  Future<String?> getDisplayName(String userId) async {
    try {
      final doc = await _db.collection(usersCollection).doc(userId).get();
      return doc.data()?['displayName'] as String?;
    } catch (_) {
      return null;
    }
  }

  Future<Map<String, dynamic>?> getUserSettings(String userId) async {
    try {
      final doc = await _db.collection(usersCollection).doc(userId).get();
      return doc.data();
    } catch (_) {
      return null;
    }
  }

  Future<void> setUserSettings(
    String userId, {
    String? displayName,
    int? accentColorValue,
    int? avatarIconCodePoint,
    int? avatarColorValue,
  }) async {
    final data = <String, dynamic>{};
    if (displayName != null) data['displayName'] = displayName;
    if (accentColorValue != null) data['accentColorValue'] = accentColorValue;
    if (avatarIconCodePoint != null) {
      data['avatarIconCodePoint'] = avatarIconCodePoint;
    }
    if (avatarColorValue != null) data['avatarColorValue'] = avatarColorValue;
    if (data.isEmpty) return;
    await _db.collection(usersCollection).doc(userId).set(data, SetOptions(merge: true));
  }

  Future<Map<String, dynamic>?> getPremiumStatus(String userId) async {
    try {
      final doc = await _db.collection(usersCollection).doc(userId).get();
      final data = doc.data();
      if (data == null) return null;
      DateTime? expiry;
      final raw = data['premiumExpiry'];
      if (raw is Timestamp) {
        expiry = raw.toDate();
      } else if (raw is DateTime) {
        expiry = raw;
      } else if (raw is String) {
        try { expiry = DateTime.parse(raw); } catch (_) {}
      }
      return {
        'isPremium': data['isPremium'] as bool?,
        'premiumPlan': data['premiumPlan'] as String?,
        'premiumExpiry': expiry,
      };
    } catch (_) {
      return null;
    }
  }

  Future<void> setPremiumStatus(
    String userId, {
    bool? isPremium,
    DateTime? expiry,
    String? plan,
  }) async {
    final update = <String, dynamic>{};
    if (isPremium != null) update['isPremium'] = isPremium;
    if (plan != null) update['premiumPlan'] = plan;
    if (expiry != null) update['premiumExpiry'] = Timestamp.fromDate(expiry);
    if (update.isEmpty) return;
    await _db.collection(usersCollection).doc(userId).set(update, SetOptions(merge: true));
  }
}
