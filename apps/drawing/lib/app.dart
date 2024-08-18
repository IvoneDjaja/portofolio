import 'package:flutter/material.dart';
import 'home.dart';
import 'routes.dart' as routes;

class DrawingApp extends StatelessWidget {
  const DrawingApp({super.key});

  static const String homeRoute = routes.homeRoute;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        restorationScopeId: 'drawing_app',
        title: 'Drawing',
        initialRoute: homeRoute,
        routes: <String, WidgetBuilder>{
          homeRoute: (context) => const DrawingHomePage()
        });
  }
}
