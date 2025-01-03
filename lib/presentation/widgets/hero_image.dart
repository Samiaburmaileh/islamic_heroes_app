import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HeroImage extends StatelessWidget {
  final String? imageUrl;
  final String heroTag;
  final double size;

  const HeroImage({
    super.key,
    this.imageUrl,
    required this.heroTag,
    this.size = 200,
  });

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: heroTag,
      child: Container(
        height: size,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
        ),
        child: imageUrl != null
            ? CachedNetworkImage(
          imageUrl: imageUrl!,
          fit: BoxFit.cover,
          placeholder: (context, url) => _buildLoadingIndicator(),
          errorWidget: (context, url, error) => _buildPlaceholder(),
        )
            : _buildPlaceholder(),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return const Center(
      child: Icon(
        Icons.person,
        size: 80,
        color: Colors.white,
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return const Center(
      child: CircularProgressIndicator(
        color: Colors.white,
      ),
    );
  }
}