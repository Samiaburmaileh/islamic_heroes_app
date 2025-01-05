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
  final List<String>? famousQuotes;

  @HiveField(10)
  final List<String>? books;  // Added this field

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
    this.famousQuotes,
    this.books,  // Added to constructor
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
      famousQuotes: json['famousQuotes'] != null
          ? List<String>.from(json['famousQuotes'] as List)
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
      'famousQuotes': famousQuotes,
      'books': books,
    };
  }
}