
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ImageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Base reference for hero images
  Reference get _heroImagesRef => _storage.ref().child('heroes');

  // Upload hero image
  Future<String?> uploadHeroImage(String heroId, String imagePath) async {
    try {
      final ref = _heroImagesRef.child('$heroId.jpg');
      final uploadTask = await ref.putFile(File(imagePath));
      return await uploadTask.ref.getDownloadURL();
    } catch (e) {
      debugPrint('Error uploading hero image: $e');
      return null;
    }
  }

  // Get hero image URL
  Future<String?> getHeroImageUrl(String heroId) async {
    try {
      final ref = _heroImagesRef.child('$heroId.jpg');
      return await ref.getDownloadURL();
    } catch (e) {
      debugPrint('Error getting hero image URL: $e');
      return null;
    }
  }

  // Delete hero image
  Future<void> deleteHeroImage(String heroId) async {
    try {
      final ref = _heroImagesRef.child('$heroId.jpg');
      await ref.delete();
    } catch (e) {
      debugPrint('Error deleting hero image: $e');
    }
  }
}

// Custom widget for hero images with proper error handling and loading states
class HeroImageWidget extends StatelessWidget {
  final String? imageUrl;
  final double size;
  final String heroId;

  const HeroImageWidget({
    super.key,
    this.imageUrl,
    required this.size,
    required this.heroId,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: imageUrl != null
          ? CachedNetworkImage(
        imageUrl: imageUrl!,
        fit: BoxFit.cover,
        placeholder: (context, url) => Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        errorWidget: (context, url, error) => _buildPlaceholder(context),
      )
          : _buildPlaceholder(context),
    );
  }

  Widget _buildPlaceholder(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surfaceVariant,
      child: Icon(
        Icons.person,
        size: size * 0.5,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
  }
}