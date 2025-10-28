import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? _user;
  bool _loading = true;

  AuthService() {
    // Listen to auth state changes
    _auth.authStateChanges().listen((u) {
      _user = u;
      _loading = false;
      notifyListeners();
    });
  }

  // helper
  bool get isLoading => _loading;
  bool get isLoggedIn => _user != null;
  String? get userId => _user?.uid;
  User? get user => _user;
  Stream<User?> authStateChanges() => _auth.authStateChanges();

  // Register with email & password (also create a user doc)
  Future<UserCredential> register({required String email, required String password}) async {
    final credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    final user = credential.user;
    if (user != null) {
      // create a minimal user doc
      final docRef = _firestore.collection('users').doc(user.uid);
      await docRef.set({
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    }
    return credential;
  }

  // Login with email & password
  Future<UserCredential> login({required String email, required String password}) async {
    final credential = await _auth.signInWithEmailAndPassword(email: email, password: password);
    return credential;
  }

  // Sign out
  Future<void> logout() async {
    await _auth.signOut();
  }
}
