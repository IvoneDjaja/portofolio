import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// GoRouter configuration
final _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => ParentScreen(),
    ),
    GoRoute(
      path: '/sibling',
      builder: (context, state) => SiblingScreen(),
    ),
    GoRoute(
      path: '/sibling/:siblingID',
      builder: (context, state) => SiblingWithParamScreen(),
    ),
  ],
);

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