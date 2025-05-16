import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  final String id;
  final String title;
  final String organizer; // This could be a club name or a user name
  final String description;
  final DateTime date;
  final String location;
  final bool isClubEvent;
  final int likeCount;
  final String createdBy;
  final DateTime? createdAt;
  final bool isLiked; // Track if current user liked this event
  final bool isFavorited; // Track if current user favorited this event
  
  Event({
    required this.id,
    required this.title, 
    required this.organizer,
    required this.description,
    required this.date,
    required this.location,
    required this.isClubEvent,
    this.likeCount = 0,
    this.createdBy = '',
    this.createdAt,
    this.isLiked = false,
    this.isFavorited = false,
  });
  
  // Factory constructor to create an Event from a Firestore document
  factory Event.fromFirestore(DocumentSnapshot doc, {bool isLiked = false, bool isFavorited = false}) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    
    return Event(
      id: doc.id,
      title: data['title'] ?? '',
      organizer: data['organizer'] ?? '',
      description: data['description'] ?? '',
      date: data['date'] != null ? (data['date'] as Timestamp).toDate() : DateTime.now(),
      location: data['location'] ?? '',
      isClubEvent: data['isClubEvent'] ?? false,
      likeCount: data['likeCount'] ?? 0,
      createdBy: data['createdBy'] ?? '',
      createdAt: data['createdAt'] != null ? (data['createdAt'] as Timestamp).toDate() : null,
      isLiked: isLiked,
      isFavorited: isFavorited,
    );
  }
  
  // Convert Event to a map for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'organizer': organizer,
      'description': description,
      'date': Timestamp.fromDate(date),
      'location': location,
      'isClubEvent': isClubEvent,
      'likeCount': likeCount,
      'createdBy': createdBy,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : FieldValue.serverTimestamp(),
    };
  }
  
  // Create a copy of this Event with modified fields
  Event copyWith({
    String? id,
    String? title,
    String? organizer,
    String? description,
    DateTime? date,
    String? location,
    bool? isClubEvent,
    int? likeCount,
    String? createdBy,
    DateTime? createdAt,
    bool? isLiked,
    bool? isFavorited,
  }) {
    return Event(
      id: id ?? this.id,
      title: title ?? this.title,
      organizer: organizer ?? this.organizer,
      description: description ?? this.description,
      date: date ?? this.date,
      location: location ?? this.location,
      isClubEvent: isClubEvent ?? this.isClubEvent,
      likeCount: likeCount ?? this.likeCount,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      isLiked: isLiked ?? this.isLiked,
      isFavorited: isFavorited ?? this.isFavorited,
    );
  }
} 