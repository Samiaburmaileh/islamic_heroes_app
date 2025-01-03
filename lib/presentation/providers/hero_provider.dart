import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/hero_model.dart';
import '../../data/repositories/hero_repository.dart';
import '../../services/cache_service.dart';
import '../../services/connectivity_service.dart';

final cacheServiceProvider = Provider<CacheService>((ref) {
  return CacheService();
});

final connectivityServiceProvider = Provider<ConnectivityService>((ref) {
  return ConnectivityService();
});

final heroRepositoryProvider = Provider<HeroRepository>((ref) {
  final cache = ref.watch(cacheServiceProvider);
  final connectivity = ref.watch(connectivityServiceProvider);
  return HeroRepository(
    cache: cache,
    connectivity: connectivity,
  );
});

final heroesStreamProvider = StreamProvider<List<IslamicHero>>((ref) {
  final repository = ref.watch(heroRepositoryProvider);
  return repository.streamHeroes();
});

final selectedHeroProvider = FutureProvider.family<IslamicHero?, String>((ref, id) async {
  final repository = ref.watch(heroRepositoryProvider);
  return repository.getHeroById(id);
});