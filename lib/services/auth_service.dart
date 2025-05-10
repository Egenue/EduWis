
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return result.user;
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  Future<String> getUserRole(String uid) async {
    DocumentSnapshot userDoc = await _db.collection('users').doc(uid).get();
    return userDoc['role'] ?? 'student';
  }
}
