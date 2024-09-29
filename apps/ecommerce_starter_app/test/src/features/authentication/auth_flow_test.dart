import 'package:flutter_test/flutter_test.dart';

import '../../robots.dart';

void main() {
  testWidgets('Sign in and sign out flow', (tester) async {
    final r = Robot(tester);
    await r.pumpMyApp();
    r.expectFindAllProductsCard();
    await r.openPopupMenu();
    await r.auth.openEmailPasswordSignInScreen();
    await r.auth.signInWithEmailAndPassword();
    r.expectFindAllProductsCard();
    await r.auth.openAccountScreen();
    await r.auth.tapLogoutButton();
    await r.auth.tapDialogLogoutButton();
    r.expectFindAllProductsCard();
  });
}
