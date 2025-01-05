import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/search_provider.dart';
import '../../providers/hero_provider.dart';
import '../../widgets/hero_card.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/app_error_widget.dart';
import '../../widgets/empty_state_widget.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final heroesAsync = ref.watch(heroesStreamProvider);
    final searchQuery = ref.watch(searchQueryProvider);
    final selectedEra = ref.watch(selectedEraProvider);

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
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
        actions: [
          if (_searchController.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _searchController.clear();
                ref.read(searchQueryProvider.notifier).state = '';
              },
            ),
        ],
      ),
      body: heroesAsync.when(
        loading: () => const LoadingWidget(),
        error: (error, stack) => AppErrorWidget(
          message: error.toString(),
          onRetry: () => ref.refresh(heroesStreamProvider),
        ),
        data: (heroes) {
          if (searchQuery.isEmpty) {
            return _buildEmptySearch();
          }

          if (heroes.isNotEmpty) {
            _buildEraFilter(heroes);
          }

          final filteredHeroes = _getFilteredHeroes(heroes, searchQuery, selectedEra);

          if (filteredHeroes.isEmpty) {
            return const EmptyStateWidget(
              title: 'No Results',
              message: 'Try adjusting your search or filters',
              icon: Icons.search_off,
            );
          }

          return Column(
            children: [
              if (heroes.isNotEmpty) _buildEraFilter(heroes),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filteredHeroes.length,
                  itemBuilder: (context, index) {
                    final hero = filteredHeroes[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
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
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEmptySearch() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search,
            size: 64,
            color: Colors.grey,
          ),
          SizedBox(height: 16),
          Text('Start typing to search heroes'),
        ],
      ),
    );
  }

  Widget _buildEraFilter(List<dynamic> heroes) {
    final eras = heroes.map((hero) => hero.era).toSet().toList();
    final selectedEra = ref.watch(selectedEraProvider);

    return Container(
      height: 50,
      margin: const EdgeInsets.only(top: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemCount: eras.length + 1,
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
                ref.read(selectedEraProvider.notifier).state = selected ? era : null;
              },
            ),
          );
        },
      ),
    );
  }

  List<dynamic> _getFilteredHeroes(List<dynamic> heroes, String query, String? era) {
    return heroes.where((hero) {
      final matchesQuery = hero.name.toLowerCase().contains(query.toLowerCase()) ||
          hero.biography.toLowerCase().contains(query.toLowerCase());

      final matchesEra = era == null || hero.era == era;

      return matchesQuery && matchesEra;
    }).toList();
  }
}