import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/favorites_provider.dart';
import '../../providers/hero_provider.dart';
import '../../widgets/hero_card.dart';
import '../../widgets/empty_state_widget.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/app_error_widget.dart';

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
        loading: () => const LoadingWidget(),
        error: (error, stack) => AppErrorWidget(
          message: error.toString(),
          onRetry: () => ref.refresh(heroesStreamProvider),
        ),
        data: (heroes) {
          final favoriteHeroes = heroes
              .where((hero) => favorites.contains(hero.id))
              .toList();

          if (favoriteHeroes.isEmpty) {
            return const EmptyStateWidget(
              icon: Icons.favorite_outline,
              title: 'No Favorites Yet',
              message: 'Heroes you mark as favorites will appear here',
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: favoriteHeroes.length,
            itemBuilder: (context, index) {
              final hero = favoriteHeroes[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Dismissible(
                  key: Key(hero.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 16),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
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
                  child: HeroCard(
                    hero: hero,
                    uniqueTag: 'search_$index',
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/hero-details',
                        arguments: hero,
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}