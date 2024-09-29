import 'package:ecommerce_starter_app/src/app.dart';
import 'package:flutter_test/flutter_test.dart';

import '../robots.dart';

void main() {
  testWidgets('Golden - products list', (tester) async {
    final r = Robot(tester);
    await r.golden.loadRobotoFont();
    await r.pumpMyApp();
    await expectLater(
        find.byType(MyApp), matchesGoldenFile('products_list.png'));
  });
}
