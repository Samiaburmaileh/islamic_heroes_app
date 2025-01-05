
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/hero_model.dart';
import '../../../data/models/progress_model.dart';
import '../../../providers/progress_provider.dart';
import '../../../providers/settings_provider.dart';
import '../../providers/hero_provider.dart';
import '../../widgets/hero_card.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/app_error_widget.dart';
import '../../widgets/empty_state_widget.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final heroesAsync = ref.watch(heroesStreamProvider);
    final language = ref.watch(languageProvider);
    final isArabic = language == 'ar';

    return Scaffold(
      appBar: AppBar(
        title: Text(isArabic ? 'الأبطال الإسلاميين' : 'Islamic Heroes'),
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
        loading: () => const LoadingWidget(),
        error: (error, stack) => AppErrorWidget(
          message: error.toString(),
          onRetry: () => ref.refresh(heroesStreamProvider),
        ),
        data: (heroes) {
          if (heroes.isEmpty) {
            return EmptyStateWidget(
              title: isArabic ? 'لا يوجد أبطال' : 'No Heroes Found',
              message: isArabic
                  ? 'تحقق لاحقاً من التحديثات'
                  : 'Check back later for updates',
              icon: Icons.person_search,
            );
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildContinueReading(context, ref),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    isArabic ? 'جميع الأبطال' : 'All Heroes',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                _buildHeroesList(context, heroes),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildContinueReading(BuildContext context, WidgetRef ref) {
    final progressAsync = ref.watch(progressStreamProvider);
    final language = ref.watch(languageProvider);
    final isArabic = language == 'ar';

    return progressAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (progressList) {
        if (progressList.isEmpty) return const SizedBox.shrink();

        // Get in-progress items (not completed)
        final inProgress = progressList
            .where((p) => !p.isCompleted)
            .toList()
          ..sort((a, b) => b.lastRead.compareTo(a.lastRead));

        if (inProgress.isEmpty) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                isArabic ? 'متابعة القراءة' : 'Continue Reading',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            SizedBox(
              height: 280,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: inProgress.length,
                itemBuilder: (context, index) {
                  return SizedBox(
                    width: 200,
                    child: _buildProgressCard(context, ref, inProgress[index]),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildProgressCard(BuildContext context, WidgetRef ref, ReadingProgress progress) {
    final heroAsync = ref.watch(selectedHeroProvider(progress.heroId));

    return heroAsync.when(
      loading: () => const Card(
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => Card(
        child: Center(child: Icon(Icons.error)),
      ),
      data: (hero) {
        if (hero == null) return const SizedBox.shrink();

        return Padding(
          padding: const EdgeInsets.only(right: 16),
          child: HeroCard(
            hero: hero,
            uniqueTag: 'continue_${hero.id}',
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

  Widget _buildHeroesList(BuildContext context, List<IslamicHero> heroes) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: heroes.length,
      itemBuilder: (context, index) {
        final hero = heroes[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: HeroCard(
            hero: hero,
            uniqueTag: 'home_$index',
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
}