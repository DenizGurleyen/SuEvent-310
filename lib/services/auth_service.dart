import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  // Get current user
  User? get currentUser => _auth.currentUser;
  
  // Stream to listen to auth state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();
  
  // Sign up with email and password
  Future<UserCredential> signUpWithEmailAndPassword(String email, String password, {String? displayName}) async {
    print('AuthService: Starting signUpWithEmailAndPassword for email: $email');
    try {
      print('AuthService: Calling Firebase createUserWithEmailAndPassword');
      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      print('AuthService: Firebase createUserWithEmailAndPassword successful, uid: ${userCredential.user?.uid ?? 'null'}');
      
      // Set display name if provided
      if (displayName != null && displayName.isNotEmpty && userCredential.user != null) {
        print('AuthService: Setting display name to: $displayName');
        await userCredential.user!.updateDisplayName(displayName);
        
        // Reload the user to ensure the display name is updated
        print('AuthService: Reloading user to refresh profile');
        await userCredential.user!.reload();
        // Get the updated user
        final updatedUser = _auth.currentUser;
        print('AuthService: After reload, displayName=${updatedUser?.displayName}');
      }
      
      // Log additional info about the user credential
      print('AuthService: User created successfully');
      print('AuthService: UserCredential type: ${userCredential.runtimeType}');
      print('AuthService: User info - email: ${userCredential.user?.email}, isEmailVerified: ${userCredential.user?.emailVerified}');
      
      return userCredential;
    } on FirebaseAuthException catch (e) {
      print('AuthService: FirebaseAuthException during signup: ${e.code}, ${e.message}');
      throw _handleAuthException(e);
    } catch (e) {
      print('AuthService: Unexpected error during signup: $e');
      rethrow;
    }
  }
  
  // Sign in with email and password
  Future<UserCredential> signInWithEmailAndPassword(String email, String password) async {
    print('AuthService: Starting signInWithEmailAndPassword for email: $email');
    try {
      print('AuthService: Calling Firebase signInWithEmailAndPassword');
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      print('AuthService: Login successful, uid: ${userCredential.user?.uid ?? 'null'}');
      
      // Log additional info about the user credential
      print('AuthService: User logged in successfully');
      print('AuthService: UserCredential type: ${userCredential.runtimeType}');
      print('AuthService: User info - email: ${userCredential.user?.email}, isEmailVerified: ${userCredential.user?.emailVerified}');
      
      return userCredential;
    } on FirebaseAuthException catch (e) {
      print('AuthService: FirebaseAuthException during login: ${e.code}, ${e.message}');
      throw _handleAuthException(e);
    } catch (e) {
      print('AuthService: Unexpected error during login: $e');
      rethrow;
    }
  }
  
  // Sign out
  Future<void> signOut() async {
    print('AuthService: Starting signOut');
    try {
      await _auth.signOut();
      print('AuthService: signOut successful');
    } catch (e) {
      print('AuthService: Error during signOut: $e');
      rethrow;
    }
  }
  
  // Password reset
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }
  
  // Helper method to handle authentication exceptions
  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'This email is already in use by another account.';
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'operation-not-allowed':
        return 'Email/password accounts are not enabled.';
      case 'weak-password':
        return 'The password is too weak.';
      case 'user-disabled':
        return 'This user has been disabled.';
      case 'user-not-found':
        return 'No user found with this email.';
      case 'wrong-password':
        return 'Incorrect password.';
      case 'invalid-credential':
        return 'The credentials are invalid.';
      case 'account-exists-with-different-credential':
        return 'An account already exists with the same email but different sign-in credentials.';
      case 'network-request-failed':
        return 'Network error. Check your connection and try again.';
      default:
        return e.message ?? 'An unknown error occurred.';
    }
  }
} 