import 'package:flutter/material.dart';
import 'package:portofolio/src/studies/drawing/home.dart';
import 'package:portofolio/src/studies/drawing/routes.dart' as routes;

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
        homeRoute: (context) => const HomePage()
      }
    );
  }
}