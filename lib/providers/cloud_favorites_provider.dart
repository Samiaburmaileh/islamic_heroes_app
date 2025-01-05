
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auth_provider.dart';

final cloudFavoritesProvider = StreamProvider<List<String>>((ref) {
  final user = ref.watch(authStateProvider).value;
  if (user == null) return Stream.value([]);

  return FirebaseFirestore.instance
      .collection('user_favorites/${user.uid}/favorites')
      .snapshots()
      .map((snapshot) => snapshot.docs.map((doc) => doc.id).toList());
});