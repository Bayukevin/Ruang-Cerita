import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  FirebaseAuth? _mockAuth;
  FirebaseAuth get _auth => _mockAuth ?? FirebaseAuth.instance;

  @visibleForTesting
  void setMockAuth(FirebaseAuth mock) {
    _mockAuth = mock;
  }

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    serverClientId:
        '993808199190-ilv78glbqia1ja4tmhf6ij00rr3f441g.apps.googleusercontent.com',
  );

  User? get currentUser {
    try {
      return _auth.currentUser;
    } catch (_) {
      return null;
    }
  }

  Stream<User?> get authStateChanges {
    try {
      return _auth.authStateChanges();
    } catch (_) {
      return const Stream.empty();
    }
  }

  Future<String?> getIdToken({bool forceRefresh = false}) async {
    try {
      final user = currentUser;
      if (user == null) return null;
      return await user.getIdToken(forceRefresh);
    } catch (_) {
      return null;
    }
  }

  Future<UserCredential> signInWithEmail({
    required String email,
    required String password,
  }) async {
    return await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  Future<UserCredential> registerWithEmail({
    required String email,
    required String password,
    String? name,
  }) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    if (name != null && name.trim().isNotEmpty) {
      await cred.user?.updateDisplayName(name.trim());
    }
    return cred;
  }

  Future<UserCredential?> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser == null) {
      return null;
    }

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    return await _auth.signInWithCredential(credential);
  }

  Future<void> signOut() async {
    await Future.wait([
      _auth.signOut(),
      _googleSignIn.signOut(),
    ]);
  }

  static String getErrorMessage(dynamic error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'user-not-found':
          return 'Akun dengan email ini tidak ditemukan.';
        case 'wrong-password':
          return 'Kata sandi salah. Silakan coba lagi.';
        case 'invalid-credential':
          return 'Email atau kata sandi tidak cocok.';
        case 'email-already-in-use':
          return 'Email sudah terdaftar. Silakan langsung masuk.';
        case 'invalid-email':
          return 'Format alamat email tidak valid.';
        case 'weak-password':
          return 'Kata sandi terlalu singkat (minimal 6 karakter).';
        case 'user-disabled':
          return 'Akun ini telah dinonaktifkan.';
        case 'network-request-failed':
          return 'Gagal terhubung ke jaringan. Periksa koneksi internet Anda.';
        case 'too-many-requests':
          return 'Terlalu banyak percobaan gagal. Coba lagi nanti.';
        default:
          return error.message ?? 'Terjadi kesalahan saat otentikasi.';
      }
    }
    return error.toString();
  }
}
