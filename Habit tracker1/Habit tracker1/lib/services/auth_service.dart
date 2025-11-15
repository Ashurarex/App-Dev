// lib/services/auth_service.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

// Conditional import: use real google_sign_in on mobile, stub on web
import 'google_sign_in_stub.dart'
    if (dart.library.io) 'package:google_sign_in/google_sign_in.dart';

/// AuthService: Email/Password, Phone scaffold, Google Sign-In (Web + Mobile).
/// - Web uses FirebaseAuth.signInWithPopup(GoogleAuthProvider())
/// - Mobile (Android/iOS) uses google_sign_in package
class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;
  Stream<User?> authStateChanges() => _auth.authStateChanges();

  // -----------------------------
  // EMAIL SIGN UP
  // -----------------------------
  Future<UserCredential> signUpWithEmail(String email, String password) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    notifyListeners();
    return cred;
  }

  // -----------------------------
  // EMAIL SIGN IN
  // -----------------------------
  Future<UserCredential> signInWithEmail(String email, String password) async {
    final cred = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    notifyListeners();
    return cred;
  }

  Future<void> setWebPersistence(bool remember) async {
    if (kIsWeb) {
      try {
        await _auth.setPersistence(remember ? Persistence.LOCAL : Persistence.SESSION);
      } catch (_) {
        // ignore
      }
    }
  }

  // -----------------------------
  // GOOGLE SIGN-IN (Web + Mobile)
  // -----------------------------
  // -----------------------------
  // GOOGLE SIGN-IN (Web + Mobile)
  // -----------------------------
  // -----------------------------
  // GOOGLE SIGN-IN (Web + Mobile)
  // -----------------------------
  Future<UserCredential> signInWithGoogle() async {
    // 1) Web flow: try signInWithPopup first (recommended)
    if (kIsWeb) {
      try {
        final provider = GoogleAuthProvider();
        final userCredential = await _auth.signInWithPopup(provider);
        notifyListeners();
        return userCredential;
      } catch (e) {
        // ...
      }
    }

    // 2) Mobile / fallback flow
    final googleSignIn = GoogleSignIn(
      scopes: ['email'],
    );

    final googleUser = await googleSignIn.signIn();

    if (googleUser == null) {
      // user cancelled
      throw FirebaseAuthException(
        code: 'ERROR_ABORTED_BY_USER',
        message: 'Sign in aborted by user',
      );
    }

    final googleAuth = await googleUser.authentication;
    final idToken = googleAuth.idToken;
    final accessToken = googleAuth.accessToken;

    if (idToken == null) {
      throw FirebaseAuthException(
        code: 'ERROR_MISSING_GOOGLE_ID_TOKEN',
        message: 'Missing Google ID Token.',
      );
    }

    final credential = GoogleAuthProvider.credential(
      idToken: idToken,
      accessToken: accessToken, // Pass null
    );

    final userCredential = await _auth.signInWithCredential(credential);
    notifyListeners();
    return userCredential;
  }

  // -----------------------------
  // PHONE AUTH (scaffold)
  // -----------------------------
  Future<void> sendPhoneVerification({
    required String phoneNumber,
    required PhoneVerificationCompleted verificationCompleted,
    required PhoneVerificationFailed verificationFailed,
    required PhoneCodeSent codeSent,
    required PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout,
  }) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    );
  }

  // -----------------------------
  // SIGN OUT
  // -----------------------------
  // -----------------------------
  // SIGN OUT
  // -----------------------------
  Future<void> signOut() async {
    if (!kIsWeb) {
      try {
        final googleSignIn = GoogleSignIn();
        await googleSignIn.signOut();
      } catch (_) {
        // ignore
      }
    }

    await _auth.signOut();
    notifyListeners();
  }
}
