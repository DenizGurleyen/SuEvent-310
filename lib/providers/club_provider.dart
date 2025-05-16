import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import '../models/club_model.dart';
import '../services/firestore_service.dart';

class ClubProvider extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  List<Club> _clubs = [];
  List<Club> _savedClubs = [];
  Set<String> _savedClubIds = {};
  bool _isLoading = true;
  String? _error;
  
  // Subscriptions
  StreamSubscription<List<Club>>? _clubsSubscription;
  StreamSubscription<List<String>>? _savedClubIdsSubscription;
  StreamSubscription<List<Club>>? _savedClubsSubscription;
  
  // Getters
  List<Club> get clubs => _clubs;
  List<Club> get savedClubs => _savedClubs;
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  // Constructor - initialize listeners
  ClubProvider() {
    _initListeners();
    
    // Listen for auth state changes to update subscriptions
    _auth.authStateChanges().listen((User? user) {
      _clearSubscriptions();
      _initListeners();
    });
  }
  
  // Initialize listeners for clubs and saved clubs
  void _initListeners() {
    _isLoading = true;
    notifyListeners();
    
    // Initialize database with dummy data if needed
    _firestoreService.initializeDatabaseIfEmpty().then((_) {
      // Listen for all clubs
      _clubsSubscription = _firestoreService.getClubs().listen(
        (clubs) {
          _clubs = clubs;
          _updateSavedStatusOnClubs();
          _isLoading = false;
          notifyListeners();
        },
        onError: (e) {
          _error = 'Error loading clubs: ${e.toString()}';
          _isLoading = false;
          notifyListeners();
        }
      );
      
      // Listen for saved club IDs
      _savedClubIdsSubscription = _firestoreService.getSavedClubIds().listen(
        (ids) {
          _savedClubIds = Set<String>.from(ids);
          _updateSavedStatusOnClubs();
          notifyListeners();
        },
        onError: (e) {
          _error = 'Error loading saved clubs: ${e.toString()}';
          notifyListeners();
        }
      );
      
      // Listen for saved clubs as Club objects
      _savedClubsSubscription = _firestoreService.getSavedClubs().listen(
        (clubs) {
          _savedClubs = clubs;
          notifyListeners();
        },
        onError: (e) {
          _error = 'Error loading saved clubs: ${e.toString()}';
          notifyListeners();
        }
      );
    }).catchError((e) {
      _error = 'Error initializing database: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
    });
  }
  
  // Update the saved status on all clubs based on saved club IDs
  void _updateSavedStatusOnClubs() {
    _clubs = _clubs.map((club) {
      return club.copyWith(
        saved: _savedClubIds.contains(club.id)
      );
    }).toList();
  }
  
  // Clear all subscriptions
  void _clearSubscriptions() {
    _clubsSubscription?.cancel();
    _savedClubIdsSubscription?.cancel();
    _savedClubsSubscription?.cancel();
    _clubsSubscription = null;
    _savedClubIdsSubscription = null;
    _savedClubsSubscription = null;
  }
  
  // Save or unsave a club for the current user
  Future<void> toggleSaveClub(String clubId) async {
    try {
      final isSaved = _savedClubIds.contains(clubId);
      
      if (isSaved) {
        await _firestoreService.unsaveClub(clubId);
      } else {
        await _firestoreService.saveClub(clubId);
      }
    } catch (e) {
      _error = 'Error toggling save status: ${e.toString()}';
      notifyListeners();
    }
  }
  
  // Get filtered clubs based on search text and filter criteria
  List<Club> getFilteredClubs({String searchText = '', String filter = ''}) {
    List<Club> result = [..._clubs];
    
    // Apply search text filter
    if (searchText.isNotEmpty) {
      result = result
          .where((club) => club.name
              .toLowerCase()
              .contains(searchText.toLowerCase()))
          .toList();
    }
    
    // Apply filter
    switch (filter) {
      case 'Popularity':
        result.sort((a, b) => b.popularity.compareTo(a.popularity));
        break;
      case 'Saved Clubs':
        result = result.where((club) => club.saved).toList();
        result.sort((a, b) => a.name.compareTo(b.name));
        break;
      case 'Career':
      case 'Sport':
      case 'Music':
        result = result.where((club) => club.type.toLowerCase() == filter.toLowerCase()).toList();
        result.sort((a, b) => a.name.compareTo(b.name));
        break;
      default: // Alphabetical
        result.sort((a, b) => a.name.compareTo(b.name));
    }
    
    return result;
  }
  
  // Add a new club
  Future<void> addClub(Club club) async {
    try {
      await _firestoreService.addClub(club);
    } catch (e) {
      _error = 'Error adding club: ${e.toString()}';
      notifyListeners();
    }
  }
  
  // Update a club
  Future<void> updateClub(Club club) async {
    try {
      await _firestoreService.updateClub(club);
    } catch (e) {
      _error = 'Error updating club: ${e.toString()}';
      notifyListeners();
    }
  }
  
  // Delete a club
  Future<void> deleteClub(String clubId) async {
    try {
      await _firestoreService.deleteClub(clubId);
    } catch (e) {
      _error = 'Error deleting club: ${e.toString()}';
      notifyListeners();
    }
  }
  
  // Clean up subscriptions when provider is disposed
  @override
  void dispose() {
    _clearSubscriptions();
    super.dispose();
  }
} 