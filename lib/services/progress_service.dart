
import 'package:cloud_firestore/cloud_firestore.dart';
import '../data/models/progress_model.dart';

class ProgressService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String _getProgressCollection(String userId) => 'users/$userId/progress';

  Stream<List<ReadingProgress>> streamProgress(String userId) {
    return _firestore
        .collection(_getProgressCollection(userId))
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => ReadingProgress.fromJson(doc.data()))
        .toList());
  }

  Future<void> updateProgress(ReadingProgress progress) async {
    await _firestore
        .collection(_getProgressCollection(progress.userId))
        .doc(progress.heroId)
        .set(progress.toJson());
  }

  Future<ReadingProgress?> getProgress(String userId, String heroId) async {
    final doc = await _firestore
        .collection(_getProgressCollection(userId))
        .doc(heroId)
        .get();

    if (!doc.exists) return null;
    return ReadingProgress.fromJson(doc.data()!);
  }
}