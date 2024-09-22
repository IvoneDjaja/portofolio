import 'package:ecommerce_starter_app/src/features/products_list/products_list_screen.dart';
import 'package:ecommerce_starter_app/src/features/shopping_cart/shopping_cart_screen.dart';
import 'package:go_router/go_router.dart';

final goRouter = GoRouter(
  initialLocation: '/',
  debugLogDiagnostics: true,
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => ProductsListScreen(),
      routes: [
        GoRoute(
          path: 'cart',
          builder: (context, state) => ShoppingCartScreen(),
        ),
      ],
    ),
  ],
);