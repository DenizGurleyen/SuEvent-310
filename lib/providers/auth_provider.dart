import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  User? _user;
  String? _error;
  bool _isLoading = false;
  
  // Getters
  User? get user => _user;
  String? get error => _error;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _user != null;
  
  // Initialize provider and listen to auth state changes
  AuthProvider() {
    print('Initializing AuthProvider - setting up auth state listener');
    _authService.authStateChanges.listen((User? user) async {
      print('Auth state changed: user=${user?.email ?? 'null'}');
      if (user != null) {
        // Ensure we have the latest user data with the display name
        print('AuthProvider: User is not null, displayName=${user.displayName}');
        
        // Store the refreshed user
        _user = user;
      } else {
        _user = null;
      }
      notifyListeners();
    });
  }
  
  // Sign up with email and password
  Future<bool> signUp(String email, String password, {String? displayName}) async {
    print('AuthProvider: Starting signUp with email: $email');
    _error = null;
    _isLoading = true;
    notifyListeners();
    
    try {
      print('AuthProvider: Calling signUpWithEmailAndPassword');
      final userCredential = await _authService.signUpWithEmailAndPassword(
        email, 
        password,
        displayName: displayName,
      );
      print('AuthProvider: Sign up successful, user: ${userCredential.user?.email ?? 'null'}');
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      print('AuthProvider: Sign up error: $e');
      
      // Special case: if the error is about PigeonUserDetails but the user is actually created
      if (e.toString().contains('PigeonUserDetails') && _user != null) {
        print('AuthProvider: PigeonUserDetails error detected, but user was created successfully');
        _isLoading = false;
        notifyListeners();
        return true; // Treat as success since user was created
      }
      
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
  
  // Sign in with email and password
  Future<bool> signIn(String email, String password) async {
    print('AuthProvider: Starting signIn with email: $email');
    _error = null;
    _isLoading = true;
    notifyListeners();
    
    try {
      print('AuthProvider: Calling signInWithEmailAndPassword');
      final userCredential = await _authService.signInWithEmailAndPassword(email, password);
      print('AuthProvider: Sign in successful, user: ${userCredential.user?.email ?? 'null'}');
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      print('AuthProvider: Sign in error: $e');
      
      // Special case: if the error is about PigeonUserDetails but the user is actually logged in
      if (e.toString().contains('PigeonUserDetails') && _user != null) {
        print('AuthProvider: PigeonUserDetails error detected, but user was authenticated successfully');
        _isLoading = false;
        notifyListeners();
        return true; // Treat as success since user is logged in
      }
      
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
  
  // Sign out
  Future<void> signOut() async {
    print('AuthProvider: Starting signOut');
    _error = null;
    _isLoading = true;
    notifyListeners();
    
    try {
      print('AuthProvider: Calling authService.signOut()');
      await _authService.signOut();
      print('AuthProvider: signOut successful, user should be null');
      
      // Force navigate to login page if needed
      if (_user != null) {
        print('AuthProvider: Warning - user still not null after signOut, forcing manual reset');
        _user = null; // Force reset the user
      }
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print('AuthProvider: Error during signOut: $e');
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }
  
  // Reset password
  Future<bool> resetPassword(String email) async {
    _error = null;
    _isLoading = true;
    notifyListeners();
    
    try {
      await _authService.sendPasswordResetEmail(email);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
  
  // Clear any error messages
  void clearError() {
    _error = null;
    notifyListeners();
  }
} 