import 'package:ecommerce_starter_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:ecommerce_starter_app/src/features/authentication/domain/app_user.dart';
import 'package:ecommerce_starter_app/src/features/cart/application/cart_service.dart';
import 'package:ecommerce_starter_app/src/features/cart/data/local/local_cart_repository.dart';
import 'package:ecommerce_starter_app/src/features/cart/data/remote/remote_cart_repository.dart';
import 'package:ecommerce_starter_app/src/features/cart/domain/cart.dart';
import 'package:ecommerce_starter_app/src/features/cart/domain/item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mocks.dart';

void main() {
  setUpAll(() {
    registerFallbackValue(const Cart());
  });

  late MockAuthRepository authRepository;
  late MockRemoteCartRepository remoteCartRepository;
  late MockLocalCartRepository localCartRepository;

  setUp(() {
    authRepository = MockAuthRepository();
    remoteCartRepository = MockRemoteCartRepository();
    localCartRepository = MockLocalCartRepository();
  });
  CartService makeCartService() {
    final container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(authRepository),
        localCartRepositoryProvider.overrideWithValue(localCartRepository),
        remoteCartRepositoryProvider.overrideWithValue(remoteCartRepository),
      ],
    );
    addTearDown(container.dispose);
    return container.read(cartServiceProvider);
  }

  group('setItem', () {
    test('null user, writes item to local cart', () async {
      // Setup.
      const expectedCart = Cart({'123': 1});
      when(() => authRepository.currentUser).thenReturn(null);
      when(localCartRepository.fetchCart)
          .thenAnswer((_) => Future.value(const Cart()));
      when(() => localCartRepository.setCart(expectedCart))
          .thenAnswer((_) => Future.value());
      final cartService = makeCartService();

      // Run.
      await cartService.setItem(const Item(productId: '123', quantity: 1));

      // Verify.
      verify(
        () => localCartRepository.setCart(expectedCart),
      ).called(1);
      verifyNever(
        () => remoteCartRepository.setCart(any(), any()),
      );
    });

    test('non-null user, writes item to remote cart', () async {
      // Setup.
      const testUser = AppUser(uid: 'abc', email: 'abc@test.com');
      const expectedCart = Cart({'123': 1});
      when(() => authRepository.currentUser).thenReturn(testUser);
      when(() => remoteCartRepository.fetchCart(testUser.uid))
          .thenAnswer((_) => Future.value(const Cart()));
      when(() => remoteCartRepository.setCart(testUser.uid, expectedCart))
          .thenAnswer((_) => Future.value());
      final cartService = makeCartService();

      // Run.
      await cartService.setItem(const Item(productId: '123', quantity: 1));

      // Verify.
      verify(
        () => remoteCartRepository.setCart(testUser.uid, expectedCart),
      ).called(1);
      verifyNever(
        () => localCartRepository.setCart(any()),
      );
    });
  });
}
