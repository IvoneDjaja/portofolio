import 'package:ecommerce_starter_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:ecommerce_starter_app/src/features/authentication/presentation/account/account_screen_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements FakeAuthRepository {}

void main() {
  late MockAuthRepository authRepository;
  late AccountScreenController controller;
  setUp(() {
    authRepository = MockAuthRepository();
    controller = AccountScreenController(
      authRepository: authRepository,
    );
  });
  group('AccountScreenController', () {
    test('initial state is AsyncData', () {
      verifyNever(authRepository.signOut);
      expect(controller.debugState, const AsyncData<void>(null));
    });

    test(
      'signOut success',
      () async {
        when(authRepository.signOut).thenAnswer((_) => Future.value());
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

    test(
      'signOut failure',
      () async {
        final exception = Exception('Connection failed');
        when(authRepository.signOut).thenThrow(exception);
        expectLater(
          controller.stream,
          emitsInOrder([
            const AsyncLoading<void>(),
            predicate<AsyncError<void>>((value) {
              expect(value.hasError, true);
              return true;
            }),
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
  });
}
