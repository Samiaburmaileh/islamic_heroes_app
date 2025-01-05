
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'favorites_provider.dart';

final statsProvider = StateNotifierProvider<StatsNotifier, Map<String, int>>((ref) {
  return StatsNotifier(ref);
});

class StatsNotifier extends StateNotifier<Map<String, int>> {
  final Ref ref;

  StatsNotifier(this.ref) : super({
    'favorites': 0,
    'read': 0,
    'share': 0,
  }) {
    _initStats();
  }

  void _initStats() {
    // Listen to favorites changes
    ref.listen(favoritesProvider, (previous, next) {
      updateStats('favorites', next.length);
    });
  }

  void updateStats(String key, int value) {
    state = {...state, key: value};
  }
}