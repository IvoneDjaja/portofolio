import 'package:flutter_test/flutter_test.dart';

import '../../robots.dart';

void main() {
  testWidgets('Sign in and sign out flow', (tester) async {
    final r = Robot(tester);
    await r.pumpMyApp();
    r.expectFindAllProductsCard();
  });
}
