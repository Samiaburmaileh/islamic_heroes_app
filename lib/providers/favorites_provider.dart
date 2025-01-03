import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_heroes_app/providers/settings_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/models/hero_model.dart';

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
    final favorites = List<String>.from(state);
    if (favorites.contains(heroId)) {
      favorites.remove(heroId);
    } else {
      favorites.add(heroId);
    }
    await _prefs.setStringList(_key, favorites);
    state = favorites;
  }

  bool isFavorite(String heroId) {
    return state.contains(heroId);
  }
}

final favoritesProvider = StateNotifierProvider<FavoritesNotifier, List<String>>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return FavoritesNotifier(prefs);
});