import 'package:cloud_firestore/cloud_firestore.dart';

class SavedClub {
  final String id;
  final String userId;
  final String clubId;
  final DateTime savedAt;

  SavedClub({
    required this.id,
    required this.userId,
    required this.clubId,
    required this.savedAt,
  });

  // Factory constructor to create a SavedClub from a Firestore document
  factory SavedClub.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    
    return SavedClub(
      id: doc.id,
      userId: data['userId'] ?? '',
      clubId: data['clubId'] ?? '',
      savedAt: data['savedAt'] != null 
          ? (data['savedAt'] as Timestamp).toDate() 
          : DateTime.now(),
    );
  }

  // Convert SavedClub to a map for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'clubId': clubId,
      'savedAt': Timestamp.fromDate(savedAt),
    };
  }
} 