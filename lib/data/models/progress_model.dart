// lib/data/models/progress_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class ReadingProgress {
  final String heroId;
  final String userId;
  final double progress; // 0 to 100
  final DateTime lastRead;
  final bool isCompleted;

  ReadingProgress({
    required this.heroId,
    required this.userId,
    this.progress = 0,
    required this.lastRead,
    this.isCompleted = false,
  });

  factory ReadingProgress.fromJson(Map<String, dynamic> json) {
    return ReadingProgress(
      heroId: json['heroId'],
      userId: json['userId'],
      progress: json['progress'] ?? 0,
      lastRead: (json['lastRead'] as Timestamp).toDate(),
      isCompleted: json['isCompleted'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'heroId': heroId,
      'userId': userId,
      'progress': progress,
      'lastRead': Timestamp.fromDate(lastRead),
      'isCompleted': isCompleted,
    };
  }
}