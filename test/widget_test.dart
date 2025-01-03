import 'package:flutter_test/flutter_test.dart';
import 'package:islamic_heroes_app/core/app.dart';

void main() {
  testWidgets('Basic app test', (WidgetTester tester) async {
    await tester.pumpWidget(const IslamicHeroesApp());
  });
}