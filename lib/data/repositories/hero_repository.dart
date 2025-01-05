// lib/data/repositories/hero_repository.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/hero_model.dart';
import '../../services/storage_service.dart';

class HeroRepository {
  final FirebaseFirestore _firestore;
  final StorageService _storage;

  HeroRepository({
    FirebaseFirestore? firestore,
    required StorageService storage,
  }) : _firestore = firestore ?? FirebaseFirestore.instance,
        _storage = storage;

  Stream<List<IslamicHero>> streamHeroes(String language) async* {
    final collection = language == 'ar' ? 'heros_ar' : 'heroes';

    // First yield cached data if available
    if (_storage.hasData()) {
      yield await _storage.getHeroes();
    }

    try {
      await for (final snapshot in _firestore.collection(collection).snapshots()) {
        final heroes = snapshot.docs.map((doc) => IslamicHero.fromJson({
          'id': doc.id,
          ...doc.data(),
        })).toList();

        // Save to local storage
        await _storage.saveHeroes(heroes);
        yield heroes;
      }
    } catch (e) {
      // On error, yield cached data if available
      if (_storage.hasData()) {
        yield await _storage.getHeroes();
      } else {
        throw Exception('Failed to load heroes and no cached data available');
      }
    }
  }

  Future<IslamicHero?> getHeroById(String id, String language) async {
    final collection = language == 'ar' ? 'heros_ar' : 'heroes';

    try {
      // First check cache
      final cachedHero = await _storage.getHeroById(id);
      if (cachedHero != null) {
        return cachedHero;
      }

      final doc = await _firestore.collection(collection).doc(id).get();
      if (!doc.exists) return null;

      return IslamicHero.fromJson({
        'id': doc.id,
        ...doc.data()!,
      });
    } catch (e) {
      throw Exception('Failed to fetch hero: $e');
    }
  }

  Future<void> addHero(IslamicHero hero, String language) async {
    final collection = language == 'ar' ? 'heros_ar' : 'heroes';

    try {
      await _firestore.collection(collection).doc(hero.id).set(hero.toJson());
      // Update local storage
      final heroes = await _storage.getHeroes();
      heroes.add(hero);
      await _storage.saveHeroes(heroes);
    } catch (e) {
      throw Exception('Failed to add hero: $e');
    }
  }

  Future<void> updateHero(IslamicHero hero, String language) async {
    final collection = language == 'ar' ? 'heros_ar' : 'heroes';

    try {
      await _firestore.collection(collection).doc(hero.id).update(hero.toJson());
      // Update local storage
      final heroes = await _storage.getHeroes();
      final index = heroes.indexWhere((h) => h.id == hero.id);
      if (index != -1) {
        heroes[index] = hero;
        await _storage.saveHeroes(heroes);
      }
    } catch (e) {
      throw Exception('Failed to update hero: $e');
    }
  }

  Future<void> deleteHero(String id, String language) async {
    final collection = language == 'ar' ? 'heros_ar' : 'heroes';

    try {
      await _firestore.collection(collection).doc(id).delete();
      // Update local storage
      final heroes = await _storage.getHeroes();
      heroes.removeWhere((hero) => hero.id == id);
      await _storage.saveHeroes(heroes);
    } catch (e) {
      throw Exception('Failed to delete hero: $e');
    }
  }

  Future<List<IslamicHero>> searchHeroes(String query, String language) async {
    final collection = language == 'ar' ? 'heros_ar' : 'heroes';

    try {
      final snapshot = await _firestore
          .collection(collection)
          .where('name', isGreaterThanOrEqualTo: query)
          .where('name', isLessThan: query + 'z')
          .get();

      return snapshot.docs.map((doc) => IslamicHero.fromJson({
        'id': doc.id,
        ...doc.data(),
      })).toList();
    } catch (e) {
      throw Exception('Failed to search heroes: $e');
    }
  }

  Future<List<String>> getAllEras(String language) async {
    final collection = language == 'ar' ? 'heros_ar' : 'heroes';

    try {
      final snapshot = await _firestore.collection(collection).get();
      final eras = snapshot.docs.map((doc) => doc.data()['era'] as String).toSet();
      return eras.toList();
    } catch (e) {
      throw Exception('Failed to get eras: $e');
    }
  }

  Future<List<IslamicHero>> getHeroesByEra(String era, String language) async {
    final collection = language == 'ar' ? 'heros_ar' : 'heroes';

    try {
      final snapshot = await _firestore
          .collection(collection)
          .where('era', isEqualTo: era)
          .get();

      return snapshot.docs.map((doc) => IslamicHero.fromJson({
        'id': doc.id,
        ...doc.data(),
      })).toList();
    } catch (e) {
      throw Exception('Failed to get heroes by era: $e');
    }
  }
}