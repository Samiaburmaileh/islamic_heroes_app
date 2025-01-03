import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/hero_model.dart';
import '../../services/cache_service.dart';
import '../../services/connectivity_service.dart';

class HeroRepository {
  final FirebaseFirestore _firestore;
  final CacheService _cache;
  final ConnectivityService _connectivity;
  static const String _collection = 'heroes';

  HeroRepository({
    FirebaseFirestore? firestore,
    required CacheService cache,
    required ConnectivityService connectivity,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _cache = cache,
        _connectivity = connectivity;

  Stream<List<IslamicHero>> streamHeroes() async* {
    // First, yield cached data if available
    if (_cache.hasCachedData) {
      yield _cache.getCachedHeroes();
    }

    if (await _connectivity.isConnected()) {
      try {
        await for (final snapshot in _firestore.collection(_collection).snapshots()) {
          final heroes = snapshot.docs.map((doc) => IslamicHero.fromJson({
            'id': doc.id,
            ...doc.data(),
          })).toList();

          // Update cache
          await _cache.cacheHeroes(heroes);
          yield heroes;
        }
      } catch (e) {
        if (_cache.hasCachedData) {
          yield _cache.getCachedHeroes();
        } else {
          throw Exception('Failed to fetch heroes and no cached data available');
        }
      }
    } else {
      if (_cache.hasCachedData) {
        yield _cache.getCachedHeroes();
      } else {
        throw Exception('No internet connection and no cached data available');
      }
    }
  }

  Future<IslamicHero?> getHeroById(String id) async {
    // First check cache
    final cachedHero = _cache.getCachedHeroById(id);
    if (cachedHero != null) {
      return cachedHero;
    }

    if (await _connectivity.isConnected()) {
      try {
        final doc = await _firestore.collection(_collection).doc(id).get();
        if (!doc.exists) return null;

        final hero = IslamicHero.fromJson({
          'id': doc.id,
          ...doc.data()!,
        });
        return hero;
      } catch (e) {
        throw Exception('Failed to fetch hero: $e');
      }
    } else {
      throw Exception('No internet connection and hero not found in cache');
    }
  }
}