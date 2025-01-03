
import 'package:shared_preferences/shared_preferences.dart';

class SearchHistoryService {
  static const String _key = 'search_history';
  final SharedPreferences _prefs;
  static const int _maxHistoryItems = 10;

  SearchHistoryService(this._prefs);

  List<String> getSearchHistory() {
    return _prefs.getStringList(_key) ?? [];
  }

  Future<void> addSearch(String query) async {
    if (query.trim().isEmpty) return;

    final history = getSearchHistory();

    // Remove if exists and add to front
    history.remove(query);
    history.insert(0, query);

    // Keep only last N items
    if (history.length > _maxHistoryItems) {
      history.removeLast();
    }

    await _prefs.setStringList(_key, history);
  }

  Future<void> removeSearch(String query) async {
    final history = getSearchHistory();
    history.remove(query);
    await _prefs.setStringList(_key, history);
  }

  Future<void> clearHistory() async {
    await _prefs.remove(_key);
  }
}