import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import '../models/habit.dart';
import '../config/api_config.dart';

class ApiService {
  // Get base URL from config
  String get baseUrl => ApiConfig.firebaseFunctionsUrl;
  
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Singleton pattern
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  // Get Firebase ID token for authenticated requests
  Future<String?> _getIdToken() async {
    final user = _auth.currentUser;
    if (user == null) return null;
    return await user.getIdToken();
  }

  Future<Map<String, String>> _getHeaders() async {
    final token = await _getIdToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // Habit endpoints
  Future<List<Habit>> getHabits() async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/habits'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Habit.fromMap(json)).toList();
    } else {
      throw Exception('Failed to load habits');
    }
  }

  Future<Habit> getHabit(String id) async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/habits/$id'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return Habit.fromMap(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load habit');
    }
  }

  Future<Habit> createHabit(Habit habit) async {
    final headers = await _getHeaders();
    final response = await http.post(
      Uri.parse('$baseUrl/habits'),
      headers: headers,
      body: jsonEncode(habit.toMap()),
    );

    if (response.statusCode == 201) {
      return Habit.fromMap(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create habit');
    }
  }

  Future<Habit> updateHabit(Habit habit) async {
    final headers = await _getHeaders();
    final response = await http.put(
      Uri.parse('$baseUrl/habits/${habit.id}'),
      headers: headers,
      body: jsonEncode(habit.toMap()),
    );

    if (response.statusCode == 200) {
      return Habit.fromMap(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update habit');
    }
  }

  Future<Habit> toggleHabitCompletion(String habitId, {String? date}) async {
    final headers = await _getHeaders();
    final response = await http.post(
      Uri.parse('$baseUrl/habits/$habitId/toggle'),
      headers: headers,
      body: jsonEncode({'date': date}),
    );

    if (response.statusCode == 200) {
      return Habit.fromMap(jsonDecode(response.body));
    } else {
      throw Exception('Failed to toggle habit');
    }
  }

  Future<void> deleteHabit(String id) async {
    final headers = await _getHeaders();
    final response = await http.delete(
      Uri.parse('$baseUrl/habits/$id'),
      headers: headers,
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete habit');
    }
  }

  // User settings endpoints
  Future<Map<String, dynamic>> getUserSettings() async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/users/settings'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load user settings');
    }
  }

  Future<Map<String, dynamic>> updateUserSettings({
    String? displayName,
    int? accentColorValue,
    int? avatarIconCodePoint,
    int? avatarColorValue,
  }) async {
    final body = <String, dynamic>{};
    if (displayName != null) body['displayName'] = displayName;
    if (accentColorValue != null) body['accentColorValue'] = accentColorValue;
    if (avatarIconCodePoint != null) {
      body['avatarIconCodePoint'] = avatarIconCodePoint;
    }
    if (avatarColorValue != null) body['avatarColorValue'] = avatarColorValue;

    final headers = await _getHeaders();
    final response = await http.put(
      Uri.parse('$baseUrl/users/settings'),
      headers: headers,
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to update user settings');
    }
  }

  // Premium status endpoints
  Future<Map<String, dynamic>> getPremiumStatus() async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/users/premium'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load premium status');
    }
  }

  Future<Map<String, dynamic>> updatePremiumStatus({
    bool? isPremium,
    String? premiumPlan,
    DateTime? premiumExpiry,
  }) async {
    final body = <String, dynamic>{};
    if (isPremium != null) body['isPremium'] = isPremium;
    if (premiumPlan != null) body['premiumPlan'] = premiumPlan;
    if (premiumExpiry != null) {
      body['premiumExpiry'] = premiumExpiry.toIso8601String();
    }

    final headers = await _getHeaders();
    final response = await http.put(
      Uri.parse('$baseUrl/users/premium'),
      headers: headers,
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to update premium status');
    }
  }
}
