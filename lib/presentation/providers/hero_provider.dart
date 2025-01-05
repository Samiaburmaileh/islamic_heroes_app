import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../data/models/hero_model.dart';
import '../../data/repositories/hero_repository.dart';
import '../../providers/settings_provider.dart';
import '../../providers/storage_provider.dart';
// lib/providers/hero_provider.dart

final heroRepositoryProvider = Provider<HeroRepository>((ref) {
  final storage = ref.watch(storageServiceProvider);
  return HeroRepository(storage: storage);
});

final heroesStreamProvider = StreamProvider<List<IslamicHero>>((ref) {
  final repository = ref.watch(heroRepositoryProvider);
  final language = ref.watch(languageProvider);
  print('Provider language: $language'); // Debug print
  return repository.streamHeroes(language);
});

final selectedHeroProvider = FutureProvider.family<IslamicHero?, String>((ref, id) async {
  final repository = ref.watch(heroRepositoryProvider);
  final language = ref.watch(languageProvider);
  return repository.getHeroById(id, language);
});
