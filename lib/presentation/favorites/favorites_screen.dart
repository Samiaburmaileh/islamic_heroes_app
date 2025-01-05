import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/favorites_provider.dart';
import '../providers/hero_provider.dart';
import '../widgets/hero_card.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final heroesAsync = ref.watch(heroesStreamProvider);
    final favorites = ref.watch(favoritesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
      ),
      body: heroesAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stack) => _buildErrorState(context, error),
        data: (heroes) {
          final favoriteHeroes = heroes
              .where((hero) => favorites.contains(hero.id))
              .toList();

          if (favoriteHeroes.isEmpty) {
            return _buildEmptyState(context);
          }

          return _buildFavoritesList(context, favoriteHeroes, ref);
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.favorite_outline,
            size: 64,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          Text(
            'No Favorites Yet',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          const Text(
            'Start adding heroes to your favorites',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, Object error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 48,
            color: Colors.red,
          ),
          const SizedBox(height: 16),
          Text(
            'Error loading favorites',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            error.toString(),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // Retry loading
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoritesList(
      BuildContext context,
      List<dynamic> heroes,
      WidgetRef ref,
      ) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: heroes.length,
      itemBuilder: (context, index) {
        final hero = heroes[index];
        return Dismissible(
          key: Key(hero.id),
          background: Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 16),
            child: const Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
          direction: DismissDirection.endToStart,
          onDismissed: (_) {
            ref.read(favoritesProvider.notifier).toggleFavorite(hero.id);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${hero.name} removed from favorites'),
                action: SnackBarAction(
                  label: 'Undo',
                  onPressed: () {
                    ref.read(favoritesProvider.notifier).toggleFavorite(hero.id);
                  },
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16),child: Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: HeroCard(
              hero: hero,
              uniqueTag: 'favorite_$index',  // Add uniqueTag
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/hero-details',
                  arguments: hero,
                );
              },
            ),
          ),
          ),
        );
      },
    );
  }
}