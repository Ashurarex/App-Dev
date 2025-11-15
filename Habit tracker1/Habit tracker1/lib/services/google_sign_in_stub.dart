// Stub file for web platform
// This file is used when compiling for web where google_sign_in is not available

class GoogleSignIn {
  GoogleSignIn({List<String>? scopes});
  Future<GoogleSignInAccount?> signIn() => throw UnimplementedError('GoogleSignIn not available on web');
  Future<void> signOut() => throw UnimplementedError('GoogleSignIn not available on web');
}

class GoogleSignInAccount {
  Future<GoogleSignInAuthentication> get authentication => throw UnimplementedError('GoogleSignIn not available on web');
}

class GoogleSignInAuthentication {
  String? get idToken => throw UnimplementedError('GoogleSignIn not available on web');
  String? get accessToken => throw UnimplementedError('GoogleSignIn not available on web');
}

