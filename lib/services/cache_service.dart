import 'package:hive_flutter/hive_flutter.dart';
import '../data/models/hero_model.dart';

class CacheService {
  static const String heroesBoxName = 'heroes';
  static const String lastUpdateKey = 'last_update';
  late Box<IslamicHero> _heroesBox;
  late Box<dynamic> _metaBox;

  Future<void> init() async {
    await Hive.initFlutter();

    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(IslamicHeroAdapter());
    }

    _heroesBox = await Hive.openBox<IslamicHero>(heroesBoxName);
    _metaBox = await Hive.openBox('meta');
  }

  Future<void> cacheHeroes(List<IslamicHero> heroes) async {
    await _heroesBox.clear();
    final heroesMap = {for (var hero in heroes) hero.id: hero};
    await _heroesBox.putAll(heroesMap);
    await _metaBox.put(lastUpdateKey, DateTime.now().toIso8601String());
  }

  List<IslamicHero> getCachedHeroes() {
    return _heroesBox.values.toList();
  }

  IslamicHero? getCachedHeroById(String id) {
    return _heroesBox.get(id);
  }

  DateTime? getLastUpdate() {
    final lastUpdate = _metaBox.get(lastUpdateKey);
    return lastUpdate != null ? DateTime.parse(lastUpdate) : null;
  }

  Future<void> clearCache() async {
    await _heroesBox.clear();
    await _metaBox.delete(lastUpdateKey);
  }

  bool get hasCachedData => _heroesBox.isNotEmpty;
}