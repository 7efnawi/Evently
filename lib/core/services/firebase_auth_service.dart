import 'package:firebase_auth/firebase_auth.dart';
import '../../models/user_model.dart';

class FirebaseAuthService {
  FirebaseAuth? _auth;

  FirebaseAuthService({FirebaseAuth? firebaseAuth}) : _auth = firebaseAuth;

  FirebaseAuth get _firebaseAuth {
    _auth ??= FirebaseAuth.instance;
    return _auth!;
  }

  /// Returns the currently signed-in [UserModel], or null if not signed in.
  UserModel? get currentUser {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) return null;
      return UserModel(
        id: user.uid,
        name: user.displayName ?? user.email?.split('@').first ?? '',
        email: user.email ?? '',
        avatarUrl: user.photoURL,
      );
    } catch (_) {
      return null;
    }
  }

  /// Stream of auth state changes — emits [UserModel] or null.
  Stream<UserModel?> get authStateChanges {
    try {
      return _firebaseAuth.authStateChanges().map((user) {
        if (user == null) return null;
        return UserModel(
          id: user.uid,
          name: user.displayName ?? user.email?.split('@').first ?? '',
          email: user.email ?? '',
          avatarUrl: user.photoURL,
        );
      });
    } catch (_) {
      return Stream.value(null);
    }
  }

  /// Creates a new account with email/password. Returns [UserModel] or null on failure.
  Future<UserModel?> signUpWithEmail({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await credential.user?.updateDisplayName(name);
      await credential.user?.reload();
      final user = _firebaseAuth.currentUser;
      if (user == null) return null;
      return UserModel(
        id: user.uid,
        name: name,
        email: user.email ?? email,
        avatarUrl: user.photoURL,
      );
    } on FirebaseAuthException {
      return null;
    } catch (_) {
      return null;
    }
  }

  /// Signs in with email/password. Returns [UserModel] or null on failure.
  Future<UserModel?> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = credential.user;
      if (user == null) return null;
      return UserModel(
        id: user.uid,
        name: user.displayName ?? user.email?.split('@').first ?? '',
        email: user.email ?? email,
        avatarUrl: user.photoURL,
      );
    } on FirebaseAuthException {
      return null;
    } catch (_) {
      return null;
    }
  }

  /// Signs in with a Google [idToken] + [accessToken]. Returns [UserModel] or null.
  Future<UserModel?> signInWithGoogle({
    required String idToken,
    required String accessToken,
  }) async {
    try {
      final credential = GoogleAuthProvider.credential(
        idToken: idToken,
        accessToken: accessToken,
      );
      final userCredential = await _firebaseAuth.signInWithCredential(credential);
      final user = userCredential.user;
      if (user == null) return null;
      return UserModel(
        id: user.uid,
        name: user.displayName ?? '',
        email: user.email ?? '',
        avatarUrl: user.photoURL,
      );
    } on FirebaseAuthException {
      return null;
    } catch (_) {
      return null;
    }
  }

  /// Sends a password-reset email. Returns the Firebase error code, or null on success.
  Future<String?> sendPasswordResetEmail({required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.code;
    } catch (e) {
      return e.toString();
    }
  }

  /// Signs out the current user.
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (_) {}
  }
}
