import 'package:flutter_test/flutter_test.dart';

import '../../../../robot.dart';

void main() {
  testWidgets(
    'checkout when not previously signed in',
    (tester) async {
      final r = Robot(tester);
      await r.pumpMyApp();
      // add a product and start checkout
      await r.products.selectProduct();
      await r.cart.addToCart();
      await r.cart.openCart();
      await r.checkout.startCheckout();
      // sign in from checkout screen
      r.auth.expectEmailAndPasswordFieldsFound();
      await r.auth.enterAndSubmitEmailAndPassword();
      // check that we move to the payment page
      r.checkout.expectPayButtonFound();
    },
    skip: true,
  );

  testWidgets('checkout when previously signed in', (tester) async {
    final r = Robot(tester);
    await r.pumpMyApp();
    // create an account first
    await r.auth.openEmailPasswordSignInScreen();
    await r.auth.tapFormToggleButton();
    await r.auth.enterAndSubmitEmailAndPassword();
    // then add a product and start checkout
    await r.products.selectProduct();
    await r.cart.addToCart();
    await r.cart.openCart();
    await r.checkout.startCheckout();
    // expect that we see the payment page right away
    r.checkout.expectPayButtonFound();
  });
}
