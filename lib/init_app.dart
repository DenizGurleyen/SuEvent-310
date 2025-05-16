import 'package:firebase_core/firebase_core.dart';
import 'services/firestore_service.dart';

/// Initialize the app by setting up Firebase and initializing the database if needed
Future<void> initializeApp() async {
  // Initialize Firebase
  await Firebase.initializeApp();
  
  // Initialize the database with dummy data if empty
  final firestoreService = FirestoreService();
  await firestoreService.initializeDatabaseIfEmpty();
  
  print('App initialized successfully');
} 