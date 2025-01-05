// lib/presentation/screens/reading_history/reading_history_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/progress_model.dart';
import '../../../providers/progress_provider.dart';
import '../../../providers/settings_provider.dart';
import '../../providers/hero_provider.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/empty_state_widget.dart';
import '../../widgets/hero_card.dart';

class ReadingHistoryScreen extends ConsumerWidget {
  const ReadingHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progressAsync = ref.watch(progressStreamProvider);
    final language = ref.watch(languageProvider);
    final isArabic = language == 'ar';

    return Scaffold(
      appBar: AppBar(
        title: Text(isArabic ? 'سجل القراءة' : 'Reading History'),
      ),
      body: progressAsync.when(
        loading: () => const LoadingWidget(),
        error: (error, stack) => Center(
          child: Text('Error: $error'),
        ),
        data: (progressList) {
          if (progressList.isEmpty) {
            return EmptyStateWidget(
              title: isArabic ? 'لا يوجد سجل قراءة' : 'No Reading History',
              message: isArabic
                  ? 'ابدأ بقراءة قصص الأبطال لتتبع تقدمك'
                  : 'Start reading hero stories to track your progress',
              icon: Icons.history_edu,
            );
          }

          // Sort by last read date
          progressList.sort((a, b) => b.lastRead.compareTo(a.lastRead));

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: progressList.length,
            itemBuilder: (context, index) {
              final progress = progressList[index];
              return _buildProgressCard(context, ref, progress);
            },
          );
        },
      ),
    );
  }

  Widget _buildProgressCard(BuildContext context, WidgetRef ref, ReadingProgress progress) {
    final heroAsync = ref.watch(selectedHeroProvider(progress.heroId));

    return heroAsync.when(
      loading: () => const Card(
        child: ListTile(
          leading: CircularProgressIndicator(),
          title: Text('Loading...'),
        ),
      ),
      error: (error, stack) => Card(
        child: ListTile(
          leading: const Icon(Icons.error),
          title: Text('Error loading hero: $error'),
        ),
      ),
      data: (hero) {
        if (hero == null) return const SizedBox.shrink();

        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: HeroCard(
            hero: hero,
            uniqueTag: 'history_${hero.id}',
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