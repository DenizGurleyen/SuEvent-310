import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/event_model.dart';
import '../models/event_interaction_model.dart';

class EventService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  // Collection references
  CollectionReference get _eventsCollection => _firestore.collection('events');
  CollectionReference get _likesCollection => _firestore.collection('eventLikes');
  CollectionReference get _favoritesCollection => _firestore.collection('eventFavorites');
  
  // Helper to get current user ID
  String? get currentUserId => _auth.currentUser?.uid;
  
  // CRUD Operations for Events
  
  // Get all events
  Stream<List<Event>> getEvents() {
    return _eventsCollection
      .orderBy('date', descending: true)
      .snapshots()
      .asyncMap((snapshot) async {
        final events = snapshot.docs.map((doc) => Event.fromFirestore(doc)).toList();
        
        // If user is logged in, check which events they've liked and favorited
        if (currentUserId != null) {
          final likedEvents = await getLikedEventIds();
          final favoritedEvents = await getFavoritedEventIds();
          
          return events.map((event) {
            return event.copyWith(
              isLiked: likedEvents.contains(event.id),
              isFavorited: favoritedEvents.contains(event.id),
            );
          }).toList();
        }
        
        return events;
      });
  }
  
  // Get events by club/organizer
  Stream<List<Event>> getEventsByOrganizer(String organizer) {
    return _eventsCollection
      .where('organizer', isEqualTo: organizer)
      .orderBy('date', descending: true)
      .snapshots()
      .asyncMap((snapshot) async {
        final events = snapshot.docs.map((doc) => Event.fromFirestore(doc)).toList();
        
        // If user is logged in, check which events they've liked and favorited
        if (currentUserId != null) {
          final likedEvents = await getLikedEventIds();
          final favoritedEvents = await getFavoritedEventIds();
          
          return events.map((event) {
            return event.copyWith(
              isLiked: likedEvents.contains(event.id),
              isFavorited: favoritedEvents.contains(event.id),
            );
          }).toList();
        }
        
        return events;
      });
  }
  
  // Get club events
  Stream<List<Event>> getClubEvents() {
    return _eventsCollection
      .where('isClubEvent', isEqualTo: true)
      .orderBy('date', descending: true)
      .snapshots()
      .asyncMap((snapshot) async {
        final events = snapshot.docs.map((doc) => Event.fromFirestore(doc)).toList();
        
        // If user is logged in, check which events they've liked and favorited
        if (currentUserId != null) {
          final likedEvents = await getLikedEventIds();
          final favoritedEvents = await getFavoritedEventIds();
          
          return events.map((event) {
            return event.copyWith(
              isLiked: likedEvents.contains(event.id),
              isFavorited: favoritedEvents.contains(event.id),
            );
          }).toList();
        }
        
        return events;
      });
  }
  
  // Get non-club events
  Stream<List<Event>> getNonClubEvents() {
    return _eventsCollection
      .where('isClubEvent', isEqualTo: false)
      .orderBy('date', descending: true)
      .snapshots()
      .asyncMap((snapshot) async {
        final events = snapshot.docs.map((doc) => Event.fromFirestore(doc)).toList();
        
        // If user is logged in, check which events they've liked and favorited
        if (currentUserId != null) {
          final likedEvents = await getLikedEventIds();
          final favoritedEvents = await getFavoritedEventIds();
          
          return events.map((event) {
            return event.copyWith(
              isLiked: likedEvents.contains(event.id),
              isFavorited: favoritedEvents.contains(event.id),
            );
          }).toList();
        }
        
        return events;
      });
  }
  
  // Get a single event by ID
  Future<Event?> getEvent(String eventId) async {
    final doc = await _eventsCollection.doc(eventId).get();
    if (!doc.exists) return null;
    
    bool isLiked = false;
    bool isFavorited = false;
    
    if (currentUserId != null) {
      isLiked = await isEventLiked(eventId);
      isFavorited = await isEventFavorited(eventId);
    }
    
    return Event.fromFirestore(doc, isLiked: isLiked, isFavorited: isFavorited);
  }
  
  // Add a new event
  Future<String> addEvent(Event event) async {
    if (currentUserId == null) {
      throw Exception('User must be logged in to create an event');
    }
    
    Map<String, dynamic> data = event.toFirestore();
    data['createdBy'] = currentUserId;
    data['createdAt'] = FieldValue.serverTimestamp();
    
    final docRef = await _eventsCollection.add(data);
    return docRef.id;
  }
  
  // Update an event
  Future<void> updateEvent(Event event) async {
    await _eventsCollection.doc(event.id).update(event.toFirestore());
  }
  
  // Delete an event
  Future<void> deleteEvent(String eventId) async {
    // First, get event to check permissions
    final doc = await _eventsCollection.doc(eventId).get();
    if (!doc.exists) return;
    
    final data = doc.data() as Map<String, dynamic>;
    
    // Ensure user can only delete their own events
    if (currentUserId != data['createdBy']) {
      throw Exception('User can only delete their own events');
    }
    
    // Start a batch to delete event and all related likes/favorites
    final batch = _firestore.batch();
    
    // Delete the event
    batch.delete(_eventsCollection.doc(eventId));
    
    // Delete all likes for this event
    final likesQuery = await _likesCollection.where('eventId', isEqualTo: eventId).get();
    for (var doc in likesQuery.docs) {
      batch.delete(doc.reference);
    }
    
    // Delete all favorites for this event
    final favoritesQuery = await _favoritesCollection.where('eventId', isEqualTo: eventId).get();
    for (var doc in favoritesQuery.docs) {
      batch.delete(doc.reference);
    }
    
    // Commit the batch
    return batch.commit();
  }
  
  // Like/Unlike Operations
  
  // Like an event
  Future<void> likeEvent(String eventId) async {
    if (currentUserId == null) {
      throw Exception('User must be logged in to like an event');
    }
    
    // Check if already liked
    final isLiked = await isEventLiked(eventId);
    if (isLiked) return;
    
    // Start a transaction to update both the like count and add like record
    return _firestore.runTransaction((transaction) async {
      // Get the current event
      final eventDoc = await transaction.get(_eventsCollection.doc(eventId));
      if (!eventDoc.exists) {
        throw Exception('Event does not exist');
      }
      
      // Update the like count
      final currentLikeCount = (eventDoc.data() as Map<String, dynamic>)['likeCount'] ?? 0;
      transaction.update(
        _eventsCollection.doc(eventId),
        {'likeCount': currentLikeCount + 1}
      );
      
      // Add a like record
      final likeRef = _likesCollection.doc();
      transaction.set(likeRef, {
        'userId': currentUserId,
        'eventId': eventId,
        'likedAt': FieldValue.serverTimestamp(),
      });
    });
  }
  
  // Unlike an event
  Future<void> unlikeEvent(String eventId) async {
    if (currentUserId == null) {
      throw Exception('User must be logged in to unlike an event');
    }
    
    // Find the like document
    final querySnapshot = await _likesCollection
      .where('userId', isEqualTo: currentUserId)
      .where('eventId', isEqualTo: eventId)
      .limit(1)
      .get();
    
    if (querySnapshot.docs.isEmpty) return;
    
    // Start a transaction to update both the like count and remove like record
    return _firestore.runTransaction((transaction) async {
      // Get the current event
      final eventDoc = await transaction.get(_eventsCollection.doc(eventId));
      if (!eventDoc.exists) {
        throw Exception('Event does not exist');
      }
      
      // Update the like count, but don't let it go below 0
      final currentLikeCount = (eventDoc.data() as Map<String, dynamic>)['likeCount'] ?? 0;
      transaction.update(
        _eventsCollection.doc(eventId),
        {'likeCount': currentLikeCount > 0 ? currentLikeCount - 1 : 0}
      );
      
      // Delete the like record
      transaction.delete(querySnapshot.docs.first.reference);
    });
  }
  
  // Toggle like status
  Future<void> toggleEventLike(String eventId) async {
    final isLiked = await isEventLiked(eventId);
    if (isLiked) {
      return unlikeEvent(eventId);
    } else {
      return likeEvent(eventId);
    }
  }
  
  // Check if an event is liked by the current user
  Future<bool> isEventLiked(String eventId) async {
    if (currentUserId == null) return false;
    
    final querySnapshot = await _likesCollection
      .where('userId', isEqualTo: currentUserId)
      .where('eventId', isEqualTo: eventId)
      .limit(1)
      .get();
    
    return querySnapshot.docs.isNotEmpty;
  }
  
  // Get all event IDs liked by current user
  Future<List<String>> getLikedEventIds() async {
    if (currentUserId == null) return [];
    
    final querySnapshot = await _likesCollection
      .where('userId', isEqualTo: currentUserId)
      .get();
    
    return querySnapshot.docs
      .map((doc) => (doc.data() as Map<String, dynamic>)['eventId'] as String)
      .toList();
  }
  
  // Favorite/Unfavorite Operations
  
  // Favorite an event
  Future<void> favoriteEvent(String eventId) async {
    if (currentUserId == null) {
      throw Exception('User must be logged in to favorite an event');
    }
    
    // Check if already favorited
    final isFavorited = await isEventFavorited(eventId);
    if (isFavorited) return;
    
    // Add a favorite record
    await _favoritesCollection.add({
      'userId': currentUserId,
      'eventId': eventId,
      'favoritedAt': FieldValue.serverTimestamp(),
    });
  }
  
  // Unfavorite an event
  Future<void> unfavoriteEvent(String eventId) async {
    if (currentUserId == null) {
      throw Exception('User must be logged in to unfavorite an event');
    }
    
    // Find the favorite document
    final querySnapshot = await _favoritesCollection
      .where('userId', isEqualTo: currentUserId)
      .where('eventId', isEqualTo: eventId)
      .limit(1)
      .get();
    
    if (querySnapshot.docs.isEmpty) return;
    
    // Delete the favorite record
    await querySnapshot.docs.first.reference.delete();
  }
  
  // Toggle favorite status
  Future<void> toggleEventFavorite(String eventId) async {
    final isFavorited = await isEventFavorited(eventId);
    if (isFavorited) {
      return unfavoriteEvent(eventId);
    } else {
      return favoriteEvent(eventId);
    }
  }
  
  // Check if an event is favorited by the current user
  Future<bool> isEventFavorited(String eventId) async {
    if (currentUserId == null) return false;
    
    final querySnapshot = await _favoritesCollection
      .where('userId', isEqualTo: currentUserId)
      .where('eventId', isEqualTo: eventId)
      .limit(1)
      .get();
    
    return querySnapshot.docs.isNotEmpty;
  }
  
  // Get all event IDs favorited by current user
  Future<List<String>> getFavoritedEventIds() async {
    if (currentUserId == null) return [];
    
    final querySnapshot = await _favoritesCollection
      .where('userId', isEqualTo: currentUserId)
      .get();
    
    return querySnapshot.docs
      .map((doc) => (doc.data() as Map<String, dynamic>)['eventId'] as String)
      .toList();
  }
  
  // Get all events favorited by current user
  Stream<List<Event>> getFavoritedEvents() {
    if (currentUserId == null) {
      return Stream.value([]);
    }
    
    return _favoritesCollection
      .where('userId', isEqualTo: currentUserId)
      .snapshots()
      .asyncMap((snapshot) async {
        final eventIds = snapshot.docs
          .map((doc) => (doc.data() as Map<String, dynamic>)['eventId'] as String)
          .toList();
        
        if (eventIds.isEmpty) return [];
        
        final eventsSnapshot = await _eventsCollection
          .where(FieldPath.documentId, whereIn: eventIds)
          .get();
        
        return eventsSnapshot.docs
          .map((doc) => Event.fromFirestore(doc, isFavorited: true))
          .toList();
      });
  }
  
  // Get top events by like count
  Stream<List<Event>> getTopEventsByLikes(int limit) {
    return _eventsCollection
      .orderBy('likeCount', descending: true)
      .limit(limit)
      .snapshots()
      .asyncMap((snapshot) async {
        final events = snapshot.docs.map((doc) => Event.fromFirestore(doc)).toList();
        
        // If user is logged in, check which events they've liked and favorited
        if (currentUserId != null) {
          final likedEvents = await getLikedEventIds();
          final favoritedEvents = await getFavoritedEventIds();
          
          return events.map((event) {
            return event.copyWith(
              isLiked: likedEvents.contains(event.id),
              isFavorited: favoritedEvents.contains(event.id),
            );
          }).toList();
        }
        
        return events;
      });
  }
  
  // Initialize the database with dummy event data if it's empty
  Future<void> initializeDatabaseIfEmpty() async {
    final snapshot = await _eventsCollection.limit(1).get();
    
    if (snapshot.docs.isEmpty) {
      final batch = _firestore.batch();
      
      // Add sample events
      for (final event in _dummyEvents) {
        final docRef = _eventsCollection.doc();
        batch.set(docRef, {
          'title': event['title'],
          'organizer': event['organizer'],
          'description': event['description'],
          'date': event['date'],
          'location': event['location'],
          'isClubEvent': event['isClubEvent'],
          'likeCount': event['likeCount'],
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
      
      await batch.commit();
    }
  }
  
  // Dummy data for initial database
  final List<Map<String, dynamic>> _dummyEvents = [
    {
      'title': 'CompTalks',
      'organizer': 'IEEE',
      'description': 'Join us for a series of talks about the latest trends in computing and technology.',
      'date': Timestamp.fromDate(DateTime.now().add(const Duration(days: 7))),
      'location': 'Engineering Building, Room 101',
      'isClubEvent': true,
      'likeCount': 250,
    },
    {
      'title': 'IMIS\'25',
      'organizer': 'IES',
      'description': 'International Management Information Systems Conference 2025.',
      'date': Timestamp.fromDate(DateTime.now().add(const Duration(days: 14))),
      'location': 'Management Building, Auditorium',
      'isClubEvent': true,
      'likeCount': 115,
    },
    {
      'title': 'Last Dance',
      'organizer': 'SUDance',
      'description': 'End of semester dance performance showcasing student choreographies.',
      'date': Timestamp.fromDate(DateTime.now().add(const Duration(days: 21))),
      'location': 'Student Center, Main Hall',
      'isClubEvent': true,
      'likeCount': 60,
    },
    {
      'title': 'Chess Tournament',
      'organizer': 'Ahmet Mehmet',
      'description': 'Open chess tournament for all skill levels. Prizes for winners!',
      'date': Timestamp.fromDate(DateTime.now().add(const Duration(days: 5))),
      'location': 'Student Center, Room 203',
      'isClubEvent': false,
      'likeCount': 24,
    },
    {
      'title': 'Lake Party',
      'organizer': 'Ali Veli',
      'description': 'End of semester celebration by the lake. Food and drinks provided.',
      'date': Timestamp.fromDate(DateTime.now().add(const Duration(days: 30))),
      'location': 'Sapanca Lake, East Shore',
      'isClubEvent': false,
      'likeCount': 5,
    },
  ];
} 