import 'package:hive/hive.dart';

part 'hero_model.g.dart';

@HiveType(typeId: 0)
class IslamicHero extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String era;

  @HiveField(3)
  final List<String> achievements;

  @HiveField(4)
  final String biography;

  @HiveField(5)
  final String? imageUrl;

  @HiveField(6)
  final String? birthDate;

  @HiveField(7)
  final String? deathDate;

  @HiveField(8)
  final String? birthPlace;

  @HiveField(9)
  final List<String>? contributions;

  @HiveField(10)
  final List<String>? famousQuotes;

  @HiveField(11)
  final List<String>? historicalEvents;

  @HiveField(12)
  final Map<String, String>? familyRelations;

  @HiveField(13)
  final List<String>? books;

  IslamicHero({
    required this.id,
    required this.name,
    required this.era,
    required this.achievements,
    required this.biography,
    this.imageUrl,
    this.birthDate,
    this.deathDate,
    this.birthPlace,
    this.contributions,
    this.famousQuotes,
    this.historicalEvents,
    this.familyRelations,
    this.books,
  });

  factory IslamicHero.fromJson(Map<String, dynamic> json) {
    return IslamicHero(
      id: json['id'] as String,
      name: json['name'] as String,
      era: json['era'] as String,
      achievements: List<String>.from(json['achievements'] as List),
      biography: json['biography'] as String,
      imageUrl: json['imageUrl'] as String?,
      birthDate: json['birthDate'] as String?,
      deathDate: json['deathDate'] as String?,
      birthPlace: json['birthPlace'] as String?,
      contributions: json['contributions'] != null
          ? List<String>.from(json['contributions'] as List)
          : null,
      famousQuotes: json['famousQuotes'] != null
          ? List<String>.from(json['famousQuotes'] as List)
          : null,
      historicalEvents: json['historicalEvents'] != null
          ? List<String>.from(json['historicalEvents'] as List)
          : null,
      familyRelations: json['familyRelations'] != null
          ? Map<String, String>.from(json['familyRelations'] as Map)
          : null,
      books: json['books'] != null
          ? List<String>.from(json['books'] as List)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'era': era,
      'achievements': achievements,
      'biography': biography,
      'imageUrl': imageUrl,
      'birthDate': birthDate,
      'deathDate': deathDate,
      'birthPlace': birthPlace,
      'contributions': contributions,
      'famousQuotes': famousQuotes,
      'historicalEvents': historicalEvents,
      'familyRelations': familyRelations,
      'books': books,
    };
  }

  // Copy with method to create a new instance with some updated fields
  IslamicHero copyWith({
    String? id,
    String? name,
    String? era,
    List<String>? achievements,
    String? biography,
    String? imageUrl,
    String? birthDate,
    String? deathDate,
    String? birthPlace,
    List<String>? contributions,
    List<String>? famousQuotes,
    List<String>? historicalEvents,
    Map<String, String>? familyRelations,
    List<String>? books,
  }) {
    return IslamicHero(
      id: id ?? this.id,
      name: name ?? this.name,
      era: era ?? this.era,
      achievements: achievements ?? this.achievements,
      biography: biography ?? this.biography,
      imageUrl: imageUrl ?? this.imageUrl,
      birthDate: birthDate ?? this.birthDate,
      deathDate: deathDate ?? this.deathDate,
      birthPlace: birthPlace ?? this.birthPlace,
      contributions: contributions ?? this.contributions,
      famousQuotes: famousQuotes ?? this.famousQuotes,
      historicalEvents: historicalEvents ?? this.historicalEvents,
      familyRelations: familyRelations ?? this.familyRelations,
      books: books ?? this.books,
    );
  }

  @override
  String toString() {
    return 'IslamicHero(id: $id, name: $name, era: $era)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is IslamicHero && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

// HiveAdapter will be generated after running build_runner
// Run: flutter pub run build_runner build