// lib/services/cache_service.dart

import 'package:hive_flutter/hive_flutter.dart';
import '../data/models/hero_model.dart';

class CacheService {
  static final CacheService _instance = CacheService._internal();

  factory CacheService() => _instance;

  CacheService._internal();

  late Box<IslamicHero> _heroesBox;
  bool _isInitialized = false;

  Future<void> init() async {
    if (!_isInitialized) {
      await Hive.initFlutter();

      if (!Hive.isAdapterRegistered(0)) {
        Hive.registerAdapter(IslamicHeroAdapter());
      }

      _heroesBox = await Hive.openBox<IslamicHero>('heroes');
      _isInitialized = true;
    }
  }

  Future<void> ensureInitialized() async {
    if (!_isInitialized) {
      await init();
    }
  }

  bool get hasData {
    if (!_isInitialized) return false;
    return _heroesBox.isNotEmpty;
  }

  Future<List<IslamicHero>> getHeroes() async {
    await ensureInitialized();
    return _heroesBox.values.toList();
  }

  Future<IslamicHero?> getHeroById(String id) async {
    await ensureInitialized();
    return _heroesBox.get(id);
  }

  Future<void> saveHero(IslamicHero hero) async {
    await ensureInitialized();
    await _heroesBox.put(hero.id, hero);
  }

  Future<void> saveHeroes(List<IslamicHero> heroes) async {
    await ensureInitialized();
    final Map<String, IslamicHero> heroMap = {
      for (var hero in heroes) hero.id: hero
    };
    await _heroesBox.putAll(heroMap);
  }

  Future<void> deleteHero(String id) async {
    await ensureInitialized();
    await _heroesBox.delete(id);
  }

  Future<void> clearCache() async {
    await ensureInitialized();
    await _heroesBox.clear();
  }

  Future<void> dispose() async {
    if (_isInitialized) {
      await _heroesBox.close();
      _isInitialized = false;
    }
  }

  // Search functionality
  Future<List<IslamicHero>> searchHeroes(String query) async {
    await ensureInitialized();
    if (query.isEmpty) return getHeroes();

    final heroes = await getHeroes();
    query = query.toLowerCase();

    return heroes.where((hero) {
      return hero.name.toLowerCase().contains(query) ||
          hero.era.toLowerCase().contains(query) ||
          hero.biography.toLowerCase().contains(query) ||
          hero.achievements.any((achievement) =>
              achievement.toLowerCase().contains(query));
    }).toList();
  }

  // Get heroes by era
  Future<List<IslamicHero>> getHeroesByEra(String era) async {
    await ensureInitialized();
    final heroes = await getHeroes();
    return heroes.where((hero) => hero.era == era).toList();
  }

  // Get all unique eras
  Future<List<String>> getAllEras() async {
    await ensureInitialized();
    final heroes = await getHeroes();
    return heroes.map((hero) => hero.era).toSet().toList();
  }
}