import 'package:ecommerce_starter_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:ecommerce_starter_app/src/features/orders/data/fake_orders_repository.dart';
import 'package:ecommerce_starter_app/src/features/orders/domain/order.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Watch the list of user orders
/// NOTE: Only watch this provider if the user is signed in.
final userOrdersProvider = StreamProvider.autoDispose<List<Order>>((ref) {
  final user = ref.watch(authStateChangesProvider).value;
  if (user != null) {
    final ordersRepository = ref.watch(ordersRepositoryProvider);
    return ordersRepository.watchUserOrders(user.uid);
  } else {
    // If the user is null, return an empty list (no orders)
    return Stream.value([]);
  }
});
