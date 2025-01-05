
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/progress_service.dart';
import '../data/models/progress_model.dart';
import 'auth_provider.dart';

final progressServiceProvider = Provider<ProgressService>((ref) {
  return ProgressService();
});

final progressStreamProvider = StreamProvider<List<ReadingProgress>>((ref) {
  final user = ref.watch(authStateProvider).value;
  if (user == null) return Stream.value([]);

  final service = ref.watch(progressServiceProvider);
  return service.streamProgress(user.uid);
});

final heroProgressProvider = FutureProvider.family<ReadingProgress?, String>((ref, heroId) async {
  final user = ref.watch(authStateProvider).value;
  if (user == null) return null;

  final service = ref.watch(progressServiceProvider);
  return service.getProgress(user.uid, heroId);
});