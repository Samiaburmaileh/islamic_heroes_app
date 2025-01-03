import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/hero_provider.dart';
import '../../widgets/hero_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final heroesAsync = ref.watch(heroesStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Islamic Heroes'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.refresh(heroesStreamProvider);
            },
          ),
        ],
      ),
      body: heroesAsync.when(
        loading: () => _buildLoadingState(),
        error: (error, stack) => _buildErrorState(context, error),
        data: (heroes) => _buildHeroesList(context, heroes),
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildErrorState(BuildContext context, Object error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
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
              'Error loading heroes',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Provides a way to retry loading the data
                // ref.refresh(heroesStreamProvider);
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroesList(BuildContext context, List<dynamic> heroes) {
    if (heroes.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.person_search,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              'No Heroes Found',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            const Text(
              'Check back later for updates',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        // Refresh the heroes list
        // ref.refresh(heroesStreamProvider);
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: heroes.length,
        itemBuilder: (context, index) {
          final hero = heroes[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: HeroCard(
              hero: hero,
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/hero-details',
                  arguments: hero,
                );
              },
            ),
          );
        },
      ),
    );
  }
}