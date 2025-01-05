import 'dart:io';
import 'package:path/path.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../data/models/hero_model.dart';

class StorageService {
  static const String HEROES_BOX = 'heroes';
  static const String PROFILES_BUCKET = 'profiles';
  static const String HEROES_BUCKET = 'heroes';

  late Box<IslamicHero> _heroesBox;
  final ImagePicker _picker = ImagePicker();
  final SupabaseClient _supabase = Supabase.instance.client;

  // Initialize local storage with Hive
  Future<void> init() async {
    try {
      _heroesBox = await Hive.openBox<IslamicHero>(HEROES_BOX);
    } catch (e) {
      print('Error initializing storage service: $e');
      await Hive.deleteBoxFromDisk(HEROES_BOX);
      _heroesBox = await Hive.openBox<IslamicHero>(HEROES_BOX);
    }
  }

  // Image picking
  Future<XFile?> pickImage({
    ImageSource source = ImageSource.gallery,
    double? maxWidth,
    double? maxHeight,
  }) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: maxWidth ?? 1920,
        maxHeight: maxHeight ?? 1080,
        imageQuality: 85,
      );
      return image;
    } catch (e) {
      print('Error picking image: $e');
      return null;
    }
  }

  // Profile image operations
  Future<String?> uploadProfileImage(String userId, XFile imageFile) async {
    try {
      final fileExt = extension(imageFile.path);
      final fileName = '$userId$fileExt';
      final file = File(imageFile.path);

      await _supabase
          .storage
          .from(PROFILES_BUCKET)
          .upload(fileName, file);

      return _supabase
          .storage
          .from(PROFILES_BUCKET)
          .getPublicUrl(fileName);
    } catch (e) {
      print('Error uploading profile image: $e');
      return null;
    }
  }

  // Hero image operations
  Future<String?> uploadHeroImage(String heroId, XFile imageFile) async {
    try {
      final fileExt = extension(imageFile.path);
      final fileName = 'hero_$heroId$fileExt';
      final file = File(imageFile.path);

      await _supabase
          .storage
          .from(HEROES_BUCKET)
          .upload(fileName, file);

      return _supabase
          .storage
          .from(HEROES_BUCKET)
          .getPublicUrl(fileName);
    } catch (e) {
      print('Error uploading hero image: $e');
      return null;
    }
  }

  // Delete image from storage
  Future<void> deleteImage(String bucket, String path) async {
    try {
      await _supabase
          .storage
          .from(bucket)
          .remove([path]);
    } catch (e) {
      print('Error deleting image: $e');
    }
  }

  // Local storage operations for heroes
  bool hasData() {
    return _heroesBox.isNotEmpty;
  }

  Future<List<IslamicHero>> getHeroes() async {
    return _heroesBox.values.toList();
  }

  Future<IslamicHero?> getHeroById(String id) async {
    return _heroesBox.get(id);
  }

  Future<void> saveHeroes(List<IslamicHero> heroes) async {
    await _heroesBox.clear();
    final heroMap = {for (var hero in heroes) hero.id: hero};
    await _heroesBox.putAll(heroMap);
  }

  Future<void> saveHero(IslamicHero hero) async {
    await _heroesBox.put(hero.id, hero);
  }

  Future<void> deleteHero(String id) async {
    await _heroesBox.delete(id);
  }

  Future<void> clearCache() async {
    await _heroesBox.clear();
  }

  Future<void> dispose() async {
    await _heroesBox.close();
  }

  // Search functionality
  Future<List<IslamicHero>> searchHeroes(String query) async {
    final heroes = await getHeroes();
    if (query.isEmpty) return heroes;

    query = query.toLowerCase();
    return heroes.where((hero) {
      return hero.name.toLowerCase().contains(query) ||
          hero.era.toLowerCase().contains(query) ||
          hero.biography.toLowerCase().contains(query) ||
          hero.achievements.any((achievement) =>
              achievement.toLowerCase().contains(query));
    }).toList();
  }

  // Get heroes by era
  Future<List<IslamicHero>> getHeroesByEra(String era) async {
    final heroes = await getHeroes();
    return heroes.where((hero) => hero.era == era).toList();
  }

  // Get all unique eras
  Future<List<String>> getAllEras() async {
    final heroes = await getHeroes();
    return heroes.map((hero) => hero.era).toSet().toList();
  }
}