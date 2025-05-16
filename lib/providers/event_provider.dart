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
  List<Event> _topEvents = [];
  bool _isLoading = true;
  String? _error;
  
  // Subscriptions
  StreamSubscription<List<Event>>? _eventsSubscription;
  StreamSubscription<List<Event>>? _clubEventsSubscription;
  StreamSubscription<List<Event>>? _nonClubEventsSubscription;
  StreamSubscription<List<Event>>? _favoritedEventsSubscription;
  StreamSubscription<List<Event>>? _topEventsSubscription;
  
  // Getters
  List<Event> get events => _events;
  List<Event> get clubEvents => _clubEvents;
  List<Event> get nonClubEvents => _nonClubEvents;
  List<Event> get favoritedEvents => _favoritedEvents;
  List<Event> get topEvents => _topEvents;
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
      
      // Listen for top events by likes
      _topEventsSubscription = _eventService.getTopEventsByLikes(5).listen(
        (events) {
          _topEvents = events;
          notifyListeners();
        },
        onError: (e) {
          _error = 'Error loading top events: ${e.toString()}';
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
    _topEventsSubscription?.cancel();
    _eventsSubscription = null;
    _clubEventsSubscription = null;
    _nonClubEventsSubscription = null;
    _favoritedEventsSubscription = null;
    _topEventsSubscription = null;
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
      // Find the event in our lists and toggle its favorited state immediately in the UI
      bool currentIsFavorited = false;
      
      // Update _events list
      final eventIndex = _events.indexWhere((e) => e.id == eventId);
      if (eventIndex != -1) {
        currentIsFavorited = _events[eventIndex].isFavorited;
        _events[eventIndex] = _events[eventIndex].copyWith(
          isFavorited: !currentIsFavorited
        );
      }
      
      // Update _clubEvents list
      final clubEventIndex = _clubEvents.indexWhere((e) => e.id == eventId);
      if (clubEventIndex != -1) {
        _clubEvents[clubEventIndex] = _clubEvents[clubEventIndex].copyWith(
          isFavorited: !currentIsFavorited
        );
      }
      
      // Update _nonClubEvents list
      final nonClubEventIndex = _nonClubEvents.indexWhere((e) => e.id == eventId);
      if (nonClubEventIndex != -1) {
        _nonClubEvents[nonClubEventIndex] = _nonClubEvents[nonClubEventIndex].copyWith(
          isFavorited: !currentIsFavorited
        );
      }
      
      // Update _topEvents list
      final topEventIndex = _topEvents.indexWhere((e) => e.id == eventId);
      if (topEventIndex != -1) {
        _topEvents[topEventIndex] = _topEvents[topEventIndex].copyWith(
          isFavorited: !currentIsFavorited
        );
      }
      
      // Update _favoritedEvents list
      if (!currentIsFavorited) {
        // If it wasn't favorited before, find the event and add it to favorites
        final eventToAdd = _events.firstWhere((e) => e.id == eventId, 
            orElse: () => _clubEvents.firstWhere((e) => e.id == eventId, 
              orElse: () => _nonClubEvents.firstWhere((e) => e.id == eventId,
                orElse: () => _topEvents.firstWhere((e) => e.id == eventId,
                  orElse: () => Event(
                    id: 'not-found', 
                    title: '',
                    organizer: '',
                    description: '',
                    date: DateTime.now(),
                    location: '',
                    isClubEvent: false,
                  )
                )
              )
            )
        );
        
        if (eventToAdd.id != 'not-found') {
          _favoritedEvents.add(eventToAdd.copyWith(isFavorited: true));
        }
      } else {
        // If it was favorited before, remove it from favorites
        _favoritedEvents.removeWhere((e) => e.id == eventId);
      }
      
      // Notify UI of changes
      notifyListeners();
      
      // Update the server state
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