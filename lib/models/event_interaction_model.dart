import 'package:cloud_firestore/cloud_firestore.dart';

class EventLike {
  final String id;
  final String userId;
  final String eventId;
  final DateTime likedAt;

  EventLike({
    required this.id,
    required this.userId,
    required this.eventId,
    required this.likedAt,
  });

  // Factory constructor to create an EventLike from a Firestore document
  factory EventLike.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    
    return EventLike(
      id: doc.id,
      userId: data['userId'] ?? '',
      eventId: data['eventId'] ?? '',
      likedAt: data['likedAt'] != null 
          ? (data['likedAt'] as Timestamp).toDate() 
          : DateTime.now(),
    );
  }

  // Convert EventLike to a map for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'eventId': eventId,
      'likedAt': Timestamp.fromDate(likedAt),
    };
  }
}

class EventFavorite {
  final String id;
  final String userId;
  final String eventId;
  final DateTime favoritedAt;

  EventFavorite({
    required this.id,
    required this.userId,
    required this.eventId,
    required this.favoritedAt,
  });

  // Factory constructor to create an EventFavorite from a Firestore document
  factory EventFavorite.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    
    return EventFavorite(
      id: doc.id,
      userId: data['userId'] ?? '',
      eventId: data['eventId'] ?? '',
      favoritedAt: data['favoritedAt'] != null 
          ? (data['favoritedAt'] as Timestamp).toDate() 
          : DateTime.now(),
    );
  }

  // Convert EventFavorite to a map for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'eventId': eventId,
      'favoritedAt': Timestamp.fromDate(favoritedAt),
    };
  }
} 