import 'package:ecommerce_starter_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:ecommerce_starter_app/src/features/authentication/presentation/account/account_screen_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AccountScreenController', () {
    test('initial state is AsyncData', () {
      final authRepository = FakeAuthRepository();
      final controller =
          AccountScreenController(authRepository: authRepository);
      expect(controller.debugState, const AsyncData<void>(null));
    });
  });
}
