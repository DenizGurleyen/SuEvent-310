import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import '../models/event_model.dart';
import '../services/event_service.dart';

class EventProvider extends ChangeNotifier {
  final EventService _eventService = EventService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  List<Event> _events = [];
  List<Event> _clubEvents = [];
  List<Event> _nonClubEvents = [];
  List<Event> _favoritedEvents = [];
  bool _isLoading = true;
  String? _error;
  
  // Subscriptions
  StreamSubscription<List<Event>>? _eventsSubscription;
  StreamSubscription<List<Event>>? _clubEventsSubscription;
  StreamSubscription<List<Event>>? _nonClubEventsSubscription;
  StreamSubscription<List<Event>>? _favoritedEventsSubscription;
  
  // Getters
  List<Event> get events => _events;
  List<Event> get clubEvents => _clubEvents;
  List<Event> get nonClubEvents => _nonClubEvents;
  List<Event> get favoritedEvents => _favoritedEvents;
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  // Constructor - initialize listeners
  EventProvider() {
    _initListeners();
    
    // Listen for auth state changes to update subscriptions
    _auth.authStateChanges().listen((User? user) {
      _clearSubscriptions();
      _initListeners();
    });
  }
  
  // Initialize listeners for events
  void _initListeners() {
    _isLoading = true;
    notifyListeners();
    
    // Initialize database with sample data if needed
    _eventService.initializeDatabaseIfEmpty().then((_) {
      // Listen for all events
      _eventsSubscription = _eventService.getEvents().listen(
        (events) {
          _events = events;
          _isLoading = false;
          notifyListeners();
        },
        onError: (e) {
          _error = 'Error loading events: ${e.toString()}';
          _isLoading = false;
          notifyListeners();
        }
      );
      
      // Listen for club events
      _clubEventsSubscription = _eventService.getClubEvents().listen(
        (events) {
          _clubEvents = events;
          notifyListeners();
        },
        onError: (e) {
          _error = 'Error loading club events: ${e.toString()}';
          notifyListeners();
        }
      );
      
      // Listen for non-club events
      _nonClubEventsSubscription = _eventService.getNonClubEvents().listen(
        (events) {
          _nonClubEvents = events;
          notifyListeners();
        },
        onError: (e) {
          _error = 'Error loading non-club events: ${e.toString()}';
          notifyListeners();
        }
      );
      
      // Listen for favorited events
      _favoritedEventsSubscription = _eventService.getFavoritedEvents().listen(
        (events) {
          _favoritedEvents = events;
          notifyListeners();
        },
        onError: (e) {
          _error = 'Error loading favorited events: ${e.toString()}';
          notifyListeners();
        }
      );
    }).catchError((e) {
      _error = 'Error initializing database: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
    });
  }
  
  // Clear all subscriptions
  void _clearSubscriptions() {
    _eventsSubscription?.cancel();
    _clubEventsSubscription?.cancel();
    _nonClubEventsSubscription?.cancel();
    _favoritedEventsSubscription?.cancel();
    _eventsSubscription = null;
    _clubEventsSubscription = null;
    _nonClubEventsSubscription = null;
    _favoritedEventsSubscription = null;
  }
  
  // Like/unlike an event
  Future<void> toggleEventLike(String eventId) async {
    try {
      await _eventService.toggleEventLike(eventId);
    } catch (e) {
      _error = 'Error toggling like status: ${e.toString()}';
      notifyListeners();
    }
  }
  
  // Favorite/unfavorite an event
  Future<void> toggleEventFavorite(String eventId) async {
    try {
      await _eventService.toggleEventFavorite(eventId);
    } catch (e) {
      _error = 'Error toggling favorite status: ${e.toString()}';
      notifyListeners();
    }
  }
  
  // Add a new event
  Future<String?> addEvent(Event event) async {
    try {
      return await _eventService.addEvent(event);
    } catch (e) {
      _error = 'Error adding event: ${e.toString()}';
      notifyListeners();
      return null;
    }
  }
  
  // Update an event
  Future<void> updateEvent(Event event) async {
    try {
      await _eventService.updateEvent(event);
    } catch (e) {
      _error = 'Error updating event: ${e.toString()}';
      notifyListeners();
    }
  }
  
  // Delete an event
  Future<void> deleteEvent(String eventId) async {
    try {
      await _eventService.deleteEvent(eventId);
    } catch (e) {
      _error = 'Error deleting event: ${e.toString()}';
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