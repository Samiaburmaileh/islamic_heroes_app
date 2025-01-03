import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'constants/app_theme.dart';
import 'constants/app_routes.dart';
import 'navigation/auth_guard.dart';
import '../providers/settings_provider.dart';

class IslamicHeroesApp extends ConsumerWidget {
  const IslamicHeroesApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final fontSize = ref.watch(fontSizeProvider);
    final language = ref.watch(languageProvider);

    return MaterialApp(
      title: 'Islamic Heroes',
      debugShowCheckedModeBanner: false,

      // Localization setup
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'), // English
        Locale('ar'), // Arabic
      ],
      locale: _getLocale(language),

      // Theme configuration
      theme: AppTheme.lightTheme.copyWith(
        textTheme: AppTheme.lightTheme.textTheme.apply(
          fontSizeFactor: fontSize,
        ),
      ),
      darkTheme: AppTheme.darkTheme.copyWith(
        textTheme: AppTheme.darkTheme.textTheme.apply(
          fontSizeFactor: fontSize,
        ),
      ),
      themeMode: themeMode,

      // Routing
      initialRoute: AppRoutes.initial,
      onGenerateRoute: (settings) {
        final publicRoutes = {
          AppRoutes.initial,
          AppRoutes.login,
          AppRoutes.register,
        };

        if (!publicRoutes.contains(settings.name)) {
          return MaterialPageRoute(
            builder: (context) => AuthGuard(
              child: Navigator(
                onGenerateRoute: (innerSettings) {
                  innerSettings = settings;
                  return AppRoutes.onGenerateRoute(settings);
                },
              ),
            ),
          );
        }

        return AppRoutes.onGenerateRoute(settings);
      },

      // Global app configuration
      builder: (context, child) {
        return GestureDetector(
          onTap: () {
            final currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
              FocusManager.instance.primaryFocus?.unfocus();
            }
          },
          child: Directionality(
            // Handle RTL for Arabic
            textDirection: language == 'Arabic' ? TextDirection.rtl : TextDirection.ltr,
            child: child!,
          ),
        );
      },
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        physics: const BouncingScrollPhysics(),
      ),
    );
  }

  Locale _getLocale(String language) {
    switch (language) {
      case 'Arabic':
        return const Locale('ar');
      default:
        return const Locale('en');
    }
  }
}