import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_heroes_app/providers/search_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/models/hero_model.dart';
import '../presentation/providers/hero_provider.dart';
import '../services/favorites_service.dart';
import 'auth_provider.dart';

class FavoritesNotifier extends StateNotifier<List<String>> {
  final SharedPreferences _prefs;
  static const String _key = 'favorites';

  FavoritesNotifier(this._prefs) : super([]) {
    _loadFavorites();
  }

  void _loadFavorites() {
    final favorites = _prefs.getStringList(_key) ?? [];
    state = favorites;
  }

  Future<void> toggleFavorite(String heroId) async {
    if (state.contains(heroId)) {
      state = state.where((id) => id != heroId).toList();
    } else {
      state = [...state, heroId];
    }
    await _prefs.setStringList(_key, state);
  }
}
// Local storage favorites provider
final favoritesProvider = StateNotifierProvider<FavoritesNotifier, List<String>>((ref) {
  throw UnimplementedError('Initialize this provider in main.dart');
});

// Filtered favorites based on local storage
final filteredFavoritesProvider = Provider<List<IslamicHero>>((ref) {
  final allHeroes = ref.watch(heroesStreamProvider).value ?? [];
  final favoriteIds = ref.watch(favoritesProvider);

  return allHeroes.where((hero) => favoriteIds.contains(hero.id)).toList();
});

// Firebase favorites service provider
final favoritesServiceProvider = Provider<FavoritesService>((ref) {
  final user = ref.watch(authStateProvider).value;
  if (user == null) throw Exception('User must be logged in');

  return FavoritesService(userId: user.uid);
});

// Cloud favorites provider
final userFavoritesProvider = StreamProvider<List<String>>((ref) {
  final favoritesService = ref.watch(favoritesServiceProvider);
  return favoritesService.streamFavoriteIds();
});

// Check if hero is favorite in cloud
final isFavoriteProvider = FutureProvider.family<bool, String>((ref, heroId) async {
  final favoritesService = ref.watch(favoritesServiceProvider);
  return favoritesService.isFavorite(heroId);
});