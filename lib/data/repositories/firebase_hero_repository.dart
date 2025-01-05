import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/hero_model.dart';

class FirebaseHeroRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String _getCollection(String language) {
    print('Language received: $language'); // Debug print
    String collection = language == 'ar' ? 'heroes_ar' : 'heroes';
    print('Using collection: $collection'); // Debug print
    return collection;
  }

  Future<List<IslamicHero>> getAllHeroes(String language) async {
    try {
      final collection = _getCollection(language);
      final snapshot = await _firestore.collection(collection).get();
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

  Future<IslamicHero?> getHeroById(String id, String language) async {
    try {
      final collection = _getCollection(language);
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
    try {
      final collection = _getCollection(language);
      await _firestore.collection(collection).doc(hero.id).set(hero.toJson());
    } catch (e) {
      throw Exception('Failed to add hero: $e');
    }
  }

  Future<void> updateHero(IslamicHero hero, String language) async {
    try {
      final collection = _getCollection(language);
      await _firestore.collection(collection).doc(hero.id).update(hero.toJson());
    } catch (e) {
      throw Exception('Failed to update hero: $e');
    }
  }

  Future<void> deleteHero(String id, String language) async {
    try {
      final collection = _getCollection(language);
      await _firestore.collection(collection).doc(id).delete();
    } catch (e) {
      throw Exception('Failed to delete hero: $e');
    }
  }

  Stream<List<IslamicHero>> streamHeroes(String language) {
    final collection = _getCollection(language);
    print('Using collection: $collection'); // Debug log

    return _firestore
        .collection(collection)
        .snapshots()
        .map((snapshot) {
      print('Got ${snapshot.docs.length} documents'); // Debug log
      return snapshot.docs.map((doc) {
        print('Document data: ${doc.data()}'); // Debug log
        return IslamicHero.fromJson({
          'id': doc.id,
          ...doc.data(),
        });
      }).toList();
    });
  }

  Future<List<IslamicHero>> searchHeroes(String query, String language) async {
    try {
      final collection = _getCollection(language);
      final snapshot = await _firestore
          .collection(collection)
          .where('name', isGreaterThanOrEqualTo: query)
          .where('name', isLessThan: query + 'z')
          .get();

      return snapshot.docs
          .map((doc) => IslamicHero.fromJson({
        'id': doc.id,
        ...doc.data(),
      }))
          .toList();
    } catch (e) {
      throw Exception('Failed to search heroes: $e');
    }
  }

  Future<List<String>> getAllEras(String language) async {
    try {
      final collection = _getCollection(language);
      final snapshot = await _firestore.collection(collection).get();
      final eras = snapshot.docs.map((doc) => doc.data()['era'] as String).toSet();
      return eras.toList();
    } catch (e) {
      throw Exception('Failed to get eras: $e');
    }
  }

  Future<List<IslamicHero>> getHeroesByEra(String era, String language) async {
    try {
      final collection = _getCollection(language);
      final snapshot = await _firestore
          .collection(collection)
          .where('era', isEqualTo: era)
          .get();

      return snapshot.docs
          .map((doc) => IslamicHero.fromJson({
        'id': doc.id,
        ...doc.data(),
      }))
          .toList();
    } catch (e) {
      throw Exception('Failed to get heroes by era: $e');
    }
  }
}