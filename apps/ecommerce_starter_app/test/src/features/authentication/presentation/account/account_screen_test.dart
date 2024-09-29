import 'package:ecommerce_starter_app/src/features/authentication/domain/app_user.dart';
import 'package:ecommerce_starter_app/src/features/authentication/presentation/account/account_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks.dart';
import '../../auth_robot.dart';

void main() {
  testWidgets('Cancel logout', (tester) async {
    final r = AuthRobot(tester);
    await r.pumpAccountScreen();
    await r.tapLogoutButton();
    r.expectLogoutDialogFound();
    await r.tapCancelButton();
    r.expectLogoutDialogNotFound();
  });

  testWidgets('Confirm logout success', (tester) async {
    final r = AuthRobot(tester);
    await r.pumpAccountScreen();
    await r.tapLogoutButton();
    r.expectLogoutDialogFound();
    await r.tapDialogLogoutButton();
    r.expectLogoutDialogNotFound();
  });

  testWidgets('Confirm logout failure', (tester) async {
    final r = AuthRobot(tester);
    final authRepository = MockAuthRepository();
    final exception = Exception('Connection Failed');
    when(authRepository.signOut).thenThrow(exception);
    when(authRepository.authStateChanges).thenAnswer(
      (_) => Stream.value(
        AppUser(uid: '123', email: 'test@test.com'),
      ),
    );
    await r.pumpAccountScreen(authRepository: authRepository);
    await r.tapLogoutButton();
    r.expectLogoutDialogFound();
    await r.tapDialogLogoutButton();
    r.expectErrorAlertFound();
  });
}
