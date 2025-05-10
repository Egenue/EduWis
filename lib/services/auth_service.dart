import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email, 
        password: password
      );
      return result.user;
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  Future<String> getUserRole(String uid) async {
    if (uid.isEmpty) {
      throw Exception('User ID cannot be empty');
    }

    try {
      DocumentSnapshot userDoc = await _db.collection('users').doc(uid).get();
      
      if (!userDoc.exists) {
        throw Exception('User not found');
      }

      final data = userDoc.data() as Map<String, dynamic>?;
      if (data == null) {
        return 'student';
      }

      return data['role'] as String? ?? 'student';
    } catch (e) {
      throw Exception('Failed to get user role: $e');
    }
  }
}
