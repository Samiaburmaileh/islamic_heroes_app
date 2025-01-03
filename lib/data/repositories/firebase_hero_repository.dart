import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/hero_model.dart';

class FirebaseHeroRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'heroes';

  Future<List<IslamicHero>> getAllHeroes() async {
    try {
      final snapshot = await _firestore.collection(_collection).get();
      return snapshot.docs
          .map((doc) => IslamicHero.fromJson({
        'id': doc.id,
        ...doc.data(),
      }))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch heroes: $e');
    }
  }

  Future<IslamicHero?> getHeroById(String id) async {
    try {
      final doc = await _firestore.collection(_collection).doc(id).get();
      if (!doc.exists) return null;

      return IslamicHero.fromJson({
        'id': doc.id,
        ...doc.data()!,
      });
    } catch (e) {
      throw Exception('Failed to fetch hero: $e');
    }
  }

  Future<void> addHero(IslamicHero hero) async {
    try {
      await _firestore.collection(_collection).doc(hero.id).set(hero.toJson());
    } catch (e) {
      throw Exception('Failed to add hero: $e');
    }
  }

  Future<void> updateHero(IslamicHero hero) async {
    try {
      await _firestore.collection(_collection).doc(hero.id).update(hero.toJson());
    } catch (e) {
      throw Exception('Failed to update hero: $e');
    }
  }

  Future<void> deleteHero(String id) async {
    try {
      await _firestore.collection(_collection).doc(id).delete();
    } catch (e) {
      throw Exception('Failed to delete hero: $e');
    }
  }

  Stream<List<IslamicHero>> streamHeroes() {
    return _firestore.collection(_collection).snapshots().map(
          (snapshot) => snapshot.docs
          .map((doc) => IslamicHero.fromJson({
        'id': doc.id,
        ...doc.data(),
      }))
          .toList(),
    );
  }
}