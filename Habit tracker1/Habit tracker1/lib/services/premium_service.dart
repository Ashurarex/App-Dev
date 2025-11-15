import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firestore_service.dart';

class PremiumService extends ChangeNotifier {
  static const String _premiumKey = 'is_premium';
  static const String _premiumExpiryKey = 'premium_expiry';
  static const String _premiumPlanKey = 'premium_plan';

  bool _isPremium = false;
  DateTime? _expiryDate;
  String? _planType; // 'monthly' or 'yearly'

  PremiumService() {
    _loadPremiumStatus();
  }

  bool get isPremium => _isPremium;
  DateTime? get expiryDate => _expiryDate;
  String? get planType => _planType;

  Future<void> _loadPremiumStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _isPremium = prefs.getBool(_premiumKey) ?? false;
      final expiryString = prefs.getString(_premiumExpiryKey);
      if (expiryString != null) {
        _expiryDate = DateTime.parse(expiryString);
        // Check if premium has expired
        if (_expiryDate!.isBefore(DateTime.now())) {
          _isPremium = false;
          await _savePremiumStatus();
        }
      }
      _planType = prefs.getString(_premiumPlanKey);

      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final fs = FirestoreService();
        final remote = await fs.getPremiumStatus(user.uid);
        if (remote != null) {
          final remotePremium = remote['isPremium'] as bool?;
          final remotePlan = remote['premiumPlan'] as String?;
          final expiry = remote['premiumExpiry'] as DateTime?;

          if (remotePremium != null) _isPremium = remotePremium;
          if (remotePlan != null) _planType = remotePlan;
          if (expiry != null) _expiryDate = expiry;
          await _savePremiumStatus();
          notifyListeners();
        }
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading premium status: $e');
    }
  }

  Future<void> _savePremiumStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_premiumKey, _isPremium);
      if (_expiryDate != null) {
        await prefs.setString(_premiumExpiryKey, _expiryDate!.toIso8601String());
      }
      if (_planType != null) {
        await prefs.setString(_premiumPlanKey, _planType!);
      }
    } catch (e) {
      debugPrint('Error saving premium status: $e');
    }
  }

  Future<bool> activatePremium(String planType) async {
    try {
      _isPremium = true;
      _planType = planType;
      
      // Set expiry date based on plan
      if (planType == 'monthly') {
        _expiryDate = DateTime.now().add(const Duration(days: 30));
      } else if (planType == 'yearly') {
        _expiryDate = DateTime.now().add(const Duration(days: 365));
      }

      await _savePremiumStatus();
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final fs = FirestoreService();
        await fs.setPremiumStatus(user.uid,
            isPremium: true, plan: _planType, expiry: _expiryDate);
      }
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Error activating premium: $e');
      return false;
    }
  }

  Future<void> cancelPremium() async {
    _isPremium = false;
    _expiryDate = null;
    _planType = null;
    await _savePremiumStatus();
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final fs = FirestoreService();
      await fs.setPremiumStatus(user.uid, isPremium: false);
    }
    notifyListeners();
  }

  Future<bool> restorePurchases() async {
    // In a real app, this would check with the app store/play store
    // For now, we'll just reload the saved status
    await _loadPremiumStatus();
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final fs = FirestoreService();
      await fs.setPremiumStatus(user.uid,
          isPremium: _isPremium, plan: _planType, expiry: _expiryDate);
    }
    return _isPremium;
  }

  String getDaysRemaining() {
    if (!_isPremium || _expiryDate == null) return '';
    final remaining = _expiryDate!.difference(DateTime.now());
    if (remaining.isNegative) return '';
    return '${remaining.inDays} days remaining';
  }
}

