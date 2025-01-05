import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/user_model.dart';
import '../services/auth_service.dart';

// Auth service provider
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

// Auth state provider
final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(authServiceProvider).authStateChanges;
});

// User provider
final userProvider = StreamProvider<User?>((ref) {
  final authService = ref.watch(authServiceProvider);

  return authService.authStateChanges.map((user) {
    if (user != null && !user.emailVerified) {
      // Reload user to get latest verification status
      user.reload();
    }
    return user;
  });
});

// Auth loading state
final authLoadingProvider = StateProvider<bool>((ref) => false);

// Auth error provider
final authErrorProvider = StateProvider<String?>((ref) => null);

// Is email verified provider
final isEmailVerifiedProvider = Provider<bool>((ref) {
  return ref.watch(userProvider).when(
    data: (user) => user?.emailVerified ?? false,
    loading: () => false,
    error: (_, __) => false,
  );
});

final userProfileProvider = StateNotifierProvider<UserProfileNotifier, AsyncValue<UserProfile?>>((ref) {
  final auth = ref.watch(authStateProvider);
  return UserProfileNotifier(ref);
});

class UserProfileNotifier extends StateNotifier<AsyncValue<UserProfile?>> {
  final Ref _ref;
  final _firestore = FirebaseFirestore.instance;

  UserProfileNotifier(this._ref) : super(const AsyncValue.loading()) {
    _init();
  }

  Future<void> _init() async {
    final user = _ref.read(authStateProvider).value;
    if (user != null) {
      await loadProfile(user.uid);
    } else {
      state = const AsyncValue.data(null);
    }
  }

  Future<void> loadProfile(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        state = AsyncValue.data(UserProfile.fromFirestore(doc));
      } else {
        state = const AsyncValue.data(null);
      }
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> updateProfile(UserProfile profile) async {
    try {
      await _firestore.collection('users').doc(profile.id).update(profile.toMap());
      state = AsyncValue.data(profile);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}