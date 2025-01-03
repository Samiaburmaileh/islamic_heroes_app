import 'package:share_plus/share_plus.dart';
import '../data/models/hero_model.dart';

class ShareService {
  static Future<void> shareHero(IslamicHero hero) async {
    final text = '''
Learn about ${hero.name} - ${hero.era}

${hero.biography}

Notable achievements:
${hero.achievements.map((a) => "• $a").join("\n")}

${hero.famousQuotes?.isNotEmpty == true ? '\nFamous Quotes:\n${hero.famousQuotes!.map((q) => '"$q"').join("\n")}' : ''}
''';

    try {
      await Share.share(
        text,
        subject: 'Learn about ${hero.name}',
      );
    } catch (e) {
      rethrow;
    }
  }
}