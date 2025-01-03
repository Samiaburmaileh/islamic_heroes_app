import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/models/hero_model.dart';
import '../presentation/providers/hero_provider.dart';

// Search query
final searchQueryProvider = StateProvider<String>((ref) => '');

// Era filter
final selectedEraProvider = StateProvider<String?>((ref) => null);

// Search results
final searchResultsProvider = Provider<List<IslamicHero>>((ref) {
  final heroes = ref.watch(heroesStreamProvider).value ?? [];
  final query = ref.watch(searchQueryProvider).toLowerCase();
  final selectedEra = ref.watch(selectedEraProvider);

  return heroes.where((hero) {
    final matchesQuery = query.isEmpty ||
        hero.name.toLowerCase().contains(query) ||
        hero.biography.toLowerCase().contains(query) ||
        hero.achievements.any((achievement) =>
            achievement.toLowerCase().contains(query));

    final matchesEra = selectedEra == null || hero.era == selectedEra;

    return matchesQuery && matchesEra;
  }).toList();
});

// Search history
class SearchHistory extends StateNotifier<List<String>> {
  static const String _prefsKey = 'search_history';
  final SharedPreferences _prefs;
  static const int _maxHistoryItems = 10;

  SearchHistory(this._prefs) : super([]) {
    _loadHistory();
  }

  void _loadHistory() {
    final history = _prefs.getStringList(_prefsKey) ?? [];
    state = history;
  }

  Future<void> addSearch(String query) async {
    if (query.trim().isEmpty) return;

    final history = List<String>.from(state);
    // Remove if exists and add to front
    history.remove(query);
    history.insert(0, query);

    // Keep only last N items
    if (history.length > _maxHistoryItems) {
      history.removeLast();
    }

    await _prefs.setStringList(_prefsKey, history);
    state = history;
  }

  Future<void> removeSearch(String query) async {
    final history = List<String>.from(state);
    history.remove(query);
    await _prefs.setStringList(_prefsKey, history);
    state = history;
  }

  Future<void> clearHistory() async {
    await _prefs.remove(_prefsKey);
    state = [];
  }
}

final searchHistoryProvider = StateNotifierProvider<SearchHistory, List<String>>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return SearchHistory(prefs);
});

// Available eras
final availableErasProvider = Provider<List<String>>((ref) {
  final heroes = ref.watch(heroesStreamProvider).value ?? [];
  return heroes.map((hero) => hero.era).toSet().toList()..sort();
});

// Suggestions
final searchSuggestionsProvider = Provider<List<String>>((ref) {
  final query = ref.watch(searchQueryProvider).toLowerCase();
  if (query.length < 2) return [];

  final heroes = ref.watch(heroesStreamProvider).value ?? [];
  return heroes
      .where((hero) =>
  hero.name.toLowerCase().contains(query) ||
      hero.era.toLowerCase().contains(query))
      .map((hero) => hero.name)
      .toSet()
      .toList();
});

// Shared Preferences provider - initialize in main.dart
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('Initialize this provider in main.dart');
});