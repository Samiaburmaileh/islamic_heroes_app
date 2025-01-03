import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/hero_provider.dart';
import '../../widgets/hero_card.dart';

final searchQueryProvider = StateProvider<String>((ref) => '');
final selectedEraProvider = StateProvider<String?>((ref) => null);

class SearchScreen extends ConsumerWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final heroesAsync = ref.watch(heroesStreamProvider);
    final searchQuery = ref.watch(searchQueryProvider);
    final selectedEra = ref.watch(selectedEraProvider);

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          decoration: InputDecoration(
            hintText: 'Search heroes...',
            border: InputBorder.none,
            hintStyle: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.7),
            ),
          ),
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
          ),
          onChanged: (value) {
            ref.read(searchQueryProvider.notifier).state = value;
          },
        ),
      ),
      body: heroesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => _buildErrorState(context, error),
        data: (heroes) {
          final filteredHeroes = heroes.where((hero) {
            final matchesQuery = hero.name.toLowerCase().contains(
              searchQuery.toLowerCase(),
            ) ||
                hero.biography.toLowerCase().contains(
                  searchQuery.toLowerCase(),
                );

            final matchesEra =
                selectedEra == null || hero.era == selectedEra;

            return matchesQuery && matchesEra;
          }).toList();

          return Column(
            children: [
              if (heroes.isNotEmpty) _buildEraFilter(context, ref, heroes),
              Expanded(
                child: filteredHeroes.isEmpty
                    ? _buildEmptyState(context)
                    : _buildSearchResults(context, filteredHeroes),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEraFilter(
      BuildContext context,
      WidgetRef ref,
      List<dynamic> heroes,
      ) {
    final eras = heroes.map((hero) => hero.era).toSet().toList();
    final selectedEra = ref.watch(selectedEraProvider);

    return Container(
      height: 50,
      margin: const EdgeInsets.only(top: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemCount: eras.length + 1, // +1 for "All" chip
        itemBuilder: (context, index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: const Text('All'),
                selected: selectedEra == null,
                onSelected: (selected) {
                  ref.read(selectedEraProvider.notifier).state = null;
                },
              ),
            );
          }

          final era = eras[index - 1];
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(era),
              selected: selectedEra == era,
              onSelected: (selected) {
                ref.read(selectedEraProvider.notifier).state =
                selected ? era : null;
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildSearchResults(BuildContext context, List<dynamic> heroes) {
    return ListView.builder(
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
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.search_off,
            size: 64,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          Text(
            'No Results Found',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          const Text(
            'Try adjusting your search or filters',
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
            'Error loading data',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            error.toString(),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}