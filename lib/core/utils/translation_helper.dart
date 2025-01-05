
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/settings_provider.dart';

String tr(BuildContext context, WidgetRef ref, String key) {
  final language = ref.watch(languageProvider);
  return AppTranslations.get(key, language);
}