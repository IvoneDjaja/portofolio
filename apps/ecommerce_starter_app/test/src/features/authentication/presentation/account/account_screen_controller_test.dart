import 'package:ecommerce_starter_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:ecommerce_starter_app/src/features/authentication/presentation/account/account_screen_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements FakeAuthRepository {}

void main() {
  group('AccountScreenController', () {
    test('initial state is AsyncData', () {
      final authRepository = MockAuthRepository();
      final controller =
          AccountScreenController(authRepository: authRepository);
      verifyNever(authRepository.signOut);
      expect(controller.debugState, const AsyncData<void>(null));
    });

    test(
      'signOut success',
      () async {
        final authRepository = MockAuthRepository();
        when(authRepository.signOut).thenAnswer((_) => Future.value());
        final controller =
            AccountScreenController(authRepository: authRepository);
        expectLater(
          controller.stream,
          emitsInOrder(const [
            AsyncLoading<void>(),
            AsyncData<void>(null),
          ]),
        );
        await controller.signOut();
        verify(authRepository.signOut).called(1);
      },
      timeout: const Timeout(
        Duration(
          milliseconds: 500,
        ),
      ),
    );

    test('signOut failure', () async {
      final authRepository = MockAuthRepository();
      final exception = Exception('Connection failed');
      when(authRepository.signOut).thenThrow(exception);
      final controller = AccountScreenController(
        authRepository: authRepository,
      );
      expectLater(
        controller.stream,
        emitsInOrder([
          AsyncLoading<void>(),
          predicate<AsyncError<void>>((value) {
            expect(value.hasError, true);
            return true;
          }),
        ]),
      );
      await controller.signOut();
      verify(authRepository.signOut).called(1);
      expect(controller.debugState.hasError, true);
    });
  });
}
