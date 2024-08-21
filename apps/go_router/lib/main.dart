import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// GoRouter configuration

// Dynamic routing config
final ValueNotifier<RoutingConfig> myRoutingConfig =
    ValueNotifier<RoutingConfig>(
  RoutingConfig(
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        builder: (_, __) => ParentScreen(),
      ),
      GoRoute(
        path: '/sibling',
        builder: (_, __) => SiblingScreen(),
      ),
      GoRoute(
        path: '/sibling/:siblingID',
        builder: (_, __) => SiblingWithParamScreen(),
      ),
    ],
  ),
);

// To change the GoRoute later, modify the value of the ValueNotifier directly.
// myRoutingConfig.value = RoutingConfig(
//   routes: <RouteBase>[
//     GoRoute(path: '/', builder: (_, __) => AlternativeHomeScreen()),
//     GoRoute(path: '/a-new-route', builder: (_, __) => SomeScreen()),
//   ],
// );

final _router = GoRouter.routingConfig(routingConfig: myRoutingConfig);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
    );
  }
}

class ParentScreen extends StatelessWidget {
  const ParentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('I am a parent screen'),
      ),
    );
  }
}

class SiblingScreen extends StatelessWidget {
  const SiblingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('I am a sibling screen'),
      ),
    );
  }
}

class SiblingWithParamScreen extends StatelessWidget {
  const SiblingWithParamScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('I am a sibling with param screen'),
      ),
    );
  }
}
