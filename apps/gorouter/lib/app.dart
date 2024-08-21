import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// GoRouter configuration

// Dynamic routing config
final ValueNotifier<RoutingConfig> myRoutingConfig =
    ValueNotifier<RoutingConfig>(
  RoutingConfig(
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        builder: (_, __) => ParentScreen(),
        routes: [
          GoRoute(
            path: 'child',
            builder: (context, state) {
              return ChildScreen();
            },
          ),
        ],
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

/// Providers are declared globally and specify how to create a state
final counterProvider = NotifierProvider<Counter, int>(Counter.new);

class Counter extends Notifier<int> {
  @override
  int build() {
    // Inside "build", we return the initial state of the counter.
    return 0;
  }

  void increment() {
    state++;
  }
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

class ParentScreen extends ConsumerWidget {
  const ParentScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(counterProvider);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('I am a parent screen'),
            Text('Count: $count'),
            TextButton(
              child: Text('Increase counter'),
              onPressed: () => ref.read(counterProvider.notifier).increment(),
            ),
            TextButton(
              child: Text('Go to child screen'),
              onPressed: () => context.go('/child'),
            )
          ],
        ),
      ),
    );
  }
}

class ChildScreen extends ConsumerWidget {
  const ChildScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(counterProvider);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('I am a child screen'),
            Text('Count: $count'),
            TextButton(
              child: Text('Increase counter'),
              onPressed: () => ref.read(counterProvider.notifier).increment(),
            ),
            TextButton(
              child: Text('Go back'),
              onPressed: () => context.pop(),
            )
          ],
        ),
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
