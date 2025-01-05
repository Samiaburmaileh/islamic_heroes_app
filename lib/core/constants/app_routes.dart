import 'package:flutter/material.dart';
import '../../data/models/hero_model.dart';
import '../../presentation/screens/auth/register_screen.dart';
import '../../presentation/screens/auth/verify_email_screen.dart';
import '../../presentation/screens/hero_details/hero_details_screen.dart';
import '../../presentation/screens/main_screen.dart';
import '../../presentation/screens/profile/edit_profile_screen.dart';
import '../../presentation/screens/reading_history/reading_history_screen.dart';
import '../../presentation/screens/splash/splash_screen.dart';
import '../../presentation/screens/search/search_screen.dart';
import '../../presentation/screens/auth/login_screen.dart';
import '../../presentation/screens/settings/settings_screen.dart';

class AppRoutes {
  // Route names
  static const String initial = '/';
  static const String home = '/home';
  static const String heroDetails = '/hero-details';
  static const String search = '/search';
  static const String login = '/login';
  static const String register = '/register';
  static const String settings = '/settings';
  static const String verifyEmail = '/verify-email';
  static const String readingHistory = '/reading-history';
  static const String editProfile = '/edit-profile';
  // Route generator
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
        );

      case '/home':
        return MaterialPageRoute(
          builder: (_) => const MainScreen(),
        );

      case '/hero-details':
        if (settings.arguments is! IslamicHero) {
          return _errorRoute('Hero data is required');
        }
        final hero = settings.arguments as IslamicHero;
        return MaterialPageRoute(
          builder: (_) => HeroDetailsScreen(hero: hero),
        );

      case editProfile:
        return MaterialPageRoute(
          builder: (_) => const EditProfileScreen(),
        );

      case '/search':
        return MaterialPageRoute(
          builder: (_) => const SearchScreen(),
        );

      case readingHistory:
        return MaterialPageRoute(
          builder: (_) => const ReadingHistoryScreen(),
        );

      case '/login':
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        );

      case '/register':
        return MaterialPageRoute(
          builder: (_) => const RegisterScreen(),
        );

      case '/settings':
        return MaterialPageRoute(
          builder: (_) => const SettingsScreen(),
        );

      case '/verify-email':
        return MaterialPageRoute(
          builder: (_) => const VerifyEmailScreen(),
        );

      default:
        return _errorRoute('Route not found');
    }
  }

  static Route<dynamic> _errorRoute(String message) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 60,
                ),
                const SizedBox(height: 16),
                Text(
                  message,
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Navigation methods
  static Future<void> navigateToHome(BuildContext context) async {
    await Navigator.pushNamedAndRemoveUntil(
      context,
      home,
          (route) => false,
    );
  }

  static Future<void> navigateToVerifyEmail(BuildContext context) async {
    await Navigator.pushNamedAndRemoveUntil(
      context,
      verifyEmail,
          (route) => false,
    );
  }

  static Future<void> navigateToHeroDetails(
      BuildContext context,
      IslamicHero hero,
      ) async {
    await Navigator.pushNamed(
      context,
      heroDetails,
      arguments: hero,
    );
  }

  static Future<void> navigateToSearch(BuildContext context) async {
    await Navigator.pushNamed(context, search);
  }

  static Future<void> navigateToLogin(BuildContext context) async {
    await Navigator.pushNamedAndRemoveUntil(
      context,
      login,
          (route) => false,
    );
  }

  static Future<void> navigateToRegister(BuildContext context) async {
    await Navigator.pushNamed(context, register);
  }

  static Future<void> navigateToSettings(BuildContext context) async {
    await Navigator.pushNamed(context, settings);
  }

  static bool isProtectedRoute(String routeName) {
    final publicRoutes = {initial, login, register};
    return !publicRoutes.contains(routeName);
  }

  static void handleUnauthorizedAccess(BuildContext context) {
    navigateToLogin(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Please login to continue'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}