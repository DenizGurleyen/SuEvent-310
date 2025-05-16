import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/club_model.dart';
import '../models/saved_club_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  // Collection references
  CollectionReference get _clubsCollection => _firestore.collection('clubs');
  CollectionReference get _savedClubsCollection => _firestore.collection('savedClubs');
  
  // Helper to get current user ID
  String? get currentUserId => _auth.currentUser?.uid;
  
  // CRUD Operations for Clubs
  
  // Get all clubs
  Stream<List<Club>> getClubs() {
    return _clubsCollection
      .snapshots()
      .map((snapshot) {
        return snapshot.docs
          .map((doc) => Club.fromFirestore(doc))
          .toList();
      });
  }
  
  // Get a single club by ID
  Future<Club?> getClub(String clubId) async {
    final doc = await _clubsCollection.doc(clubId).get();
    if (!doc.exists) return null;
    return Club.fromFirestore(doc);
  }
  
  // Add a new club
  Future<String> addClub(Club club) async {
    if (currentUserId == null) {
      throw Exception('User must be logged in to create a club');
    }
    
    Map<String, dynamic> data = club.toFirestore();
    data['createdBy'] = currentUserId;
    data['createdAt'] = FieldValue.serverTimestamp();
    
    final docRef = await _clubsCollection.add(data);
    return docRef.id;
  }
  
  // Update a club
  Future<void> updateClub(Club club) async {
    return _clubsCollection.doc(club.id).update(club.toFirestore());
  }
  
  // Delete a club
  Future<void> deleteClub(String clubId) async {
    return _clubsCollection.doc(clubId).delete();
  }
  
  // Operations for SavedClubs
  
  // Save a club for the current user
  Future<void> saveClub(String clubId) async {
    if (currentUserId == null) {
      throw Exception('User must be logged in to save a club');
    }
    
    // Check if already saved
    final querySnapshot = await _savedClubsCollection
      .where('userId', isEqualTo: currentUserId)
      .where('clubId', isEqualTo: clubId)
      .limit(1)
      .get();
    
    if (querySnapshot.docs.isNotEmpty) {
      // Already saved, no need to save again
      return;
    }
    
    // Create new saved club record
    await _savedClubsCollection.add({
      'userId': currentUserId,
      'clubId': clubId,
      'savedAt': FieldValue.serverTimestamp(),
    });
  }
  
  // Unsave a club for the current user
  Future<void> unsaveClub(String clubId) async {
    if (currentUserId == null) {
      throw Exception('User must be logged in to unsave a club');
    }
    
    final querySnapshot = await _savedClubsCollection
      .where('userId', isEqualTo: currentUserId)
      .where('clubId', isEqualTo: clubId)
      .get();
    
    final batch = _firestore.batch();
    for (var doc in querySnapshot.docs) {
      batch.delete(doc.reference);
    }
    
    return batch.commit();
  }
  
  // Check if a club is saved by the current user
  Future<bool> isClubSaved(String clubId) async {
    if (currentUserId == null) return false;
    
    final querySnapshot = await _savedClubsCollection
      .where('userId', isEqualTo: currentUserId)
      .where('clubId', isEqualTo: clubId)
      .limit(1)
      .get();
    
    return querySnapshot.docs.isNotEmpty;
  }
  
  // Get all clubs saved by the current user
  Stream<List<String>> getSavedClubIds() {
    if (currentUserId == null) {
      return Stream.value([]);
    }
    
    return _savedClubsCollection
      .where('userId', isEqualTo: currentUserId)
      .snapshots()
      .map((snapshot) {
        return snapshot.docs
          .map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return data['clubId'] as String;
          })
          .toList();
      });
  }
  
  // Get all clubs saved by the current user as Club objects
  Stream<List<Club>> getSavedClubs() {
    if (currentUserId == null) {
      return Stream.value([]);
    }
    
    return _savedClubsCollection
      .where('userId', isEqualTo: currentUserId)
      .snapshots()
      .asyncMap((snapshot) async {
        final clubIds = snapshot.docs
          .map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return data['clubId'] as String;
          })
          .toList();
        
        if (clubIds.isEmpty) return [];
        
        final clubsSnapshot = await _clubsCollection
          .where(FieldPath.documentId, whereIn: clubIds)
          .get();
        
        return clubsSnapshot.docs
          .map((doc) => Club.fromFirestore(doc))
          .toList();
      });
  }
  
  // Initialize the database with dummy data if it's empty
  Future<void> initializeDatabaseIfEmpty() async {
    final snapshot = await _clubsCollection.limit(1).get();
    
    if (snapshot.docs.isEmpty) {
      final batch = _firestore.batch();
      
      // Add clubs
      for (final club in _dummyClubs) {
        final docRef = _clubsCollection.doc(club['id']);
        batch.set(docRef, {
          'name': club['name'],
          'description': club['description'],
          'events': club['events'],
          'type': club['type'],
          'image': club['image'],
          'popularity': club['popularity'],
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
      
      await batch.commit();
    }
  }
  
  // Dummy data for initial database
  final List<Map<String, dynamic>> _dummyClubs = [
    {
      'id': 'eik',
      'name': 'Ekonomi ve İşletme Kulübü',
      'description': 'Ekonomi öğrencileri başta olmak üzere kariyer planlamasına yardımcı oluyoruz.',
      'events': ['seminerler', 'paneller', 'workshoplar', 'case studyler'],
      'type': 'career',
      'image': 'https://upload.wikimedia.org/wikipedia/commons/thumb/5/5a/University_icon.png/600px-University_icon.png',
      'popularity': 87,
    },
    {
      'id': 'ies',
      'name': 'Industrial Engineering Society',
      'description': 'Endüstri mühendisliği öğrencilerine yönelik kariyer etkinlikleri düzenliyoruz.',
      'events': ['seminerler', 'paneller', 'workshoplar', 'case studyler'],
      'type': 'career',
      'image': 'https://upload.wikimedia.org/wikipedia/commons/thumb/5/5a/University_icon.png/600px-University_icon.png',
      'popularity': 72,
    },
    {
      'id': 'sk',
      'name': 'Spor Kulübü',
      'description': 'Amerikan futbolu, basketbol ve daha fazlası.',
      'events': ['takım antrenmanları', 'yarışmalar', 'partiler'],
      'type': 'sport',
      'image': 'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e6/Fenerbahce_logo.svg/640px-Fenerbahce_logo.svg.png',
      'popularity': 95,
    },
    {
      'id': 'airsoft',
      'name': 'Airsoft Club',
      'description': 'Airsoft etkinlikleri düzenliyoruz.',
      'events': ['airsoft'],
      'type': 'sport',
      'image': 'https://upload.wikimedia.org/wikipedia/commons/thumb/4/41/Airsoft_gun_icon.png/512px-Airsoft_gun_icon.png',
      'popularity': 45,
    },
    {
      'id': 'kai',
      'name': 'Yapay Zeka Kulübü (KAI)',
      'description': 'Yapay zeka üzerine seminerler düzenliyoruz.',
      'events': ['seminerler'],
      'type': 'career',
      'image': 'https://upload.wikimedia.org/wikipedia/commons/thumb/5/5e/Artificial_intelligence_logo.png/480px-Artificial_intelligence_logo.png',
      'popularity': 81,
    },
    {
      'id': 'css',
      'name': 'Bilgisayar Kulübü (CSS)',
      'description': 'Bilgisayar mühendisliği öğrencilerine yönelik etkinlikler.',
      'events': ['seminerler', 'workshoplar'],
      'type': 'career',
      'image': 'https://upload.wikimedia.org/wikipedia/commons/thumb/f/f7/Computer_icon.png/600px-Computer_icon.png',
      'popularity': 76,
    },
  ];
} 