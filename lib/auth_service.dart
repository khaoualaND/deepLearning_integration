import 'dart:developer'; // Import the log function
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> createUserWithEmailAndPassword(String email, String password) async {
    try {
      final UserCredential cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return cred.user; // Return the user object if successful
    } catch (e) {
      log("Something went wrong: ${e.toString()}");
    }
    return null; // Return null if something went wrong
  }

  Future<User?> loginUserWithEmailAndPassword(String email, String password) async {
    try {
      final UserCredential cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return cred.user; // Return the user object if successful
    } catch (e) {
      log("Something went wrong: ${e.toString()}");
    }
    return null; // Return null if something went wrong
  }

  Future<void> signout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      log("Something went wrong: ${e.toString()}");
    }
  }
}
