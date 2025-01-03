import 'package:cloud_firestore/cloud_firestore.dart';

import '../../data/seed/initial_heroes.dart';

class FirestoreSeeder {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> seedHeroes() async {
    try {
      // Check if collection is empty
      final snapshot = await _firestore.collection('heroes').limit(1).get();
      if (snapshot.docs.isNotEmpty) {
        print('Data already exists, skipping seed');
        return;
      }

      // Seed data
      final batch = _firestore.batch();

      for (final heroData in initialHeroes) {
        final docRef = _firestore.collection('heroes').doc();
        batch.set(docRef, heroData);
      }

      await batch.commit();
      print('Seeding completed successfully');
    } catch (e) {
      print('Error seeding data: $e');
      rethrow;
    }
  }
}