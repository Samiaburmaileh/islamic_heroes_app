import 'package:cloud_firestore/cloud_firestore.dart';
import '../data/models/hero_model.dart';

class FavoritesService {
  final FirebaseFirestore _firestore;
  final String userId;

  FavoritesService({
    required this.userId,
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  String get _favoritesPath => 'user_favorites/$userId/favorites';

  Stream<List<String>> streamFavoriteIds() {
    return _firestore
        .collection(_favoritesPath)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.id).toList());
  }

  Future<void> toggleFavorite(String heroId) async {
    final docRef = _firestore.collection(_favoritesPath).doc(heroId);
    final doc = await docRef.get();

    if (doc.exists) {
      await docRef.delete();
    } else {
      await docRef.set({
        'timestamp': FieldValue.serverTimestamp(),
      });
    }
  }

  Future<bool> isFavorite(String heroId) async {
    final doc = await _firestore.collection(_favoritesPath).doc(heroId).get();
    return doc.exists;
  }
}