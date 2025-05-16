import 'package:cloud_firestore/cloud_firestore.dart';

class Club {
  final String id;
  final String name;
  final String description;
  final List<String> events;
  final String type;
  final String image;
  final bool saved;
  final int popularity;
  final String? createdBy;
  final DateTime? createdAt;

  Club({
    required this.id,
    required this.name,
    required this.description,
    required this.events,
    required this.type,
    required this.image,
    this.saved = false,
    required this.popularity,
    this.createdBy,
    this.createdAt,
  });

  // Factory constructor to create a Club from a Firestore document
  factory Club.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    
    return Club(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      events: List<String>.from(data['events'] ?? []),
      type: data['type'] ?? '',
      image: data['image'] ?? '',
      saved: data['saved'] ?? false,
      popularity: data['popularity'] ?? 0,
      createdBy: data['createdBy'],
      createdAt: data['createdAt'] != null 
          ? (data['createdAt'] as Timestamp).toDate() 
          : null,
    );
  }

  // Convert Club to a map for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'description': description,
      'events': events,
      'type': type,
      'image': image,
      'saved': saved,
      'popularity': popularity,
      'createdBy': createdBy,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
    };
  }

  // Create a copy of this Club with modified fields
  Club copyWith({
    String? id,
    String? name,
    String? description,
    List<String>? events,
    String? type,
    String? image,
    bool? saved,
    int? popularity,
    String? createdBy,
    DateTime? createdAt,
  }) {
    return Club(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      events: events ?? this.events,
      type: type ?? this.type,
      image: image ?? this.image,
      saved: saved ?? this.saved,
      popularity: popularity ?? this.popularity,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
    );
  }
} 