
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/hero_model.dart';
import '../../../providers/favorites_provider.dart';
import '../../../providers/settings_provider.dart';
import '../../../services/share_service.dart';

class HeroDetailsScreen extends ConsumerWidget {
  final IslamicHero hero;

  const HeroDetailsScreen({
    super.key,
    required this.hero,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageProvider);
    final isArabic = language == 'ar';

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Hero(
                tag: 'name-${hero.id}',
                child: Material(
                  color: Colors.transparent,
                  child: Text(
                    hero.name,
                    style: const TextStyle(
                      shadows: [
                        Shadow(
                          offset: Offset(0, 0),
                          blurRadius: 3.0,
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              background: Hero(
                tag: 'hero-${hero.id}',
                child: Image.network(
                  hero.imageUrl ?? '',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.person,
                    size: 64,
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: isArabic ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                      children: [
                        Text(
                          hero.era,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        if (hero.birthDate != null || hero.deathDate != null) ...[
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              const Icon(Icons.calendar_today, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                '${hero.birthDate ?? '?'} - ${hero.deathDate ?? '?'}',
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ],
                          ),
                        ],
                        if (hero.birthPlace != null) ...[
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              const Icon(Icons.place, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                hero.birthPlace!,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: isArabic ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.history_edu),
                            const SizedBox(width: 8),
                            Text(
                              isArabic ? 'السيرة الذاتية' : 'Biography',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          hero.biography,
                          style: Theme.of(context).textTheme.bodyLarge,
                          textAlign: isArabic ? TextAlign.right : TextAlign.left,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: isArabic ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.star),
                            const SizedBox(width: 8),
                            Text(
                              isArabic ? 'الإنجازات' : 'Achievements',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        ...hero.achievements.map((achievement) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('• '),
                              Expanded(
                                child: Text(
                                  achievement,
                                  style: Theme.of(context).textTheme.bodyLarge,
                                  textAlign: isArabic ? TextAlign.right : TextAlign.left,
                                ),
                              ),
                            ],
                          ),
                        )),
                      ],
                    ),
                  ),
                ),
                if (hero.famousQuotes?.isNotEmpty ?? false) ...[
                  const SizedBox(height: 16),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: isArabic ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.format_quote),
                              const SizedBox(width: 8),
                              Text(
                                isArabic ? 'أقوال مأثورة' : 'Famous Quotes',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          ...hero.famousQuotes!.map((quote) => Card(
                            color: Theme.of(context).colorScheme.surfaceVariant,
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Text(
                                '"$quote"',
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  fontStyle: FontStyle.italic,
                                ),
                                textAlign: isArabic ? TextAlign.right : TextAlign.left,
                              ),
                            ),
                          )),
                        ],
                      ),
                    ),
                  ),
                ],
              ]),
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Consumer(
            builder: (context, ref, child) {
              final favorites = ref.watch(favoritesProvider);
              final isFavorite = favorites.contains(hero.id);

              return FloatingActionButton(
                heroTag: 'favorite_button',
                onPressed: () {
                  ref.read(favoritesProvider.notifier).toggleFavorite(hero.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        isFavorite
                            ? (isArabic ? 'تمت الإزالة من المفضلة' : 'Removed from favorites')
                            : (isArabic ? 'تمت الإضافة إلى المفضلة' : 'Added to favorites'),
                      ),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                child: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            heroTag: 'share_button',
            onPressed: () async {
              try {
                await ShareService.shareHero(hero);
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(isArabic ? 'خطأ في المشاركة: $e' : 'Error sharing: $e'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              }
            },
            child: const Icon(Icons.share),
          ),
        ],
      ),
    );
  }
}