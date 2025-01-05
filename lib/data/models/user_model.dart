import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  final String id;
  final String email;
  String? displayName;
  String? photoUrl;
  String? bio;
  final DateTime createdAt;
  DateTime lastLoginAt;
  int favoritesCount;
  int readCount;
  int shareCount;

  UserProfile({
    required this.id,
    required this.email,
    this.displayName,
    this.photoUrl,
    this.bio,
    required this.createdAt,
    required this.lastLoginAt,
    this.favoritesCount = 0,
    this.readCount = 0,
    this.shareCount = 0,
  });

  factory UserProfile.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserProfile(
      id: doc.id,
      email: data['email'] ?? '',
      displayName: data['displayName'],
      photoUrl: data['photoUrl'],
      bio: data['bio'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      lastLoginAt: (data['lastLoginAt'] as Timestamp).toDate(),
      favoritesCount: data['favoritesCount'] ?? 0,
      readCount: data['readCount'] ?? 0,
      shareCount: data['shareCount'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'bio': bio,
      'createdAt': Timestamp.fromDate(createdAt),
      'lastLoginAt': Timestamp.fromDate(lastLoginAt),
      'favoritesCount': favoritesCount,
      'readCount': readCount,
      'shareCount': shareCount,
    };
  }

  UserProfile copyWith({
    String? displayName,
    String? photoUrl,
    String? bio,
    DateTime? lastLoginAt,
    int? favoritesCount,
    int? readCount,
    int? shareCount,
  }) {
    return UserProfile(
      id: id,
      email: email,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      bio: bio ?? this.bio,
      createdAt: createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      favoritesCount: favoritesCount ?? this.favoritesCount,
      readCount: readCount ?? this.readCount,
      shareCount: shareCount ?? this.shareCount,
    );
  }
}