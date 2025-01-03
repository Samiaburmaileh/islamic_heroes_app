import 'package:flutter/material.dart';
import '../../data/models/hero_model.dart';
import 'hero_image.dart';

class HeroCard extends StatelessWidget {
  final IslamicHero hero;
  final VoidCallback onTap;

  const HeroCard({
    super.key,
    required this.hero,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeroImage(
              imageUrl: hero.imageUrl,
              heroTag: 'hero-${hero.id}',
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Hero(
                    tag: 'name-${hero.id}',
                    child: Material(
                      color: Colors.transparent,
                      child: Text(
                        hero.name,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Hero(
                    tag: 'era-${hero.id}',
                    child: Material(
                      color: Colors.transparent,
                      child: Text(
                        hero.era,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    hero.biography,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}