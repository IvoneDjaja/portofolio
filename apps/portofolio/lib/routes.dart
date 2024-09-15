import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:portofolio/main.dart';

import 'package:drawing/app.dart' as drawing;
import 'package:drawing/routes.dart' as drawing_routes;
import 'package:gorouter/app.dart' as gorouter;
import 'package:gorouter/routes.dart' as gorouter_routes;
import 'package:material_3_demo/main.dart' as material_3_demo;
import 'package:material_3_demo/routes.dart' as material_3_demo_routes;
import 'package:rally/app.dart' as rally;
import 'package:rally/routes.dart' as rally_routes;
import 'package:widgetbook_workspace/app.dart' as widgetbook_workspace;
import 'package:widgetbook_workspace/routes.dart'
    as widgetbook_workspace_routes;
import 'package:scrolling/routes.dart' as scrolling_routes;
import 'package:scrolling/app.dart' as scrolling;

typedef PathWidgetBuilder = Widget Function(BuildContext, String?);

class Path {
  const Path(this.pattern, this.builder);

  /// A RegEx string for route matching.
  final String pattern;

  /// The builder for the associated pattern route. The first argument is the
  /// [BuildContext] and the second argument a RegEx match if that is included
  /// in the pattern.
  ///
  /// ```dart
  /// Path(
  ///   'r'^/demo/([\w-]+)$',
  ///   (context, matches) => Page(argument: match),
  /// )
  /// ```
  final PathWidgetBuilder builder;
}

class RouteConfiguration {
  /// List of [Path] to for route matching. When a named route is pushed with
  /// [Navigator.pushNamed], the route name is matched with the [Path.pattern]
  /// in the list below. As soon as there is a match, the associated builder
  /// will be returned. This means that the paths higher up in the list will
  /// take priority.
  static List<Path> paths = [
    Path(
      r'^' + drawing_routes.homeRoute,
      (context, match) => const drawing.DrawingApp(),
    ),
    Path(
      r'^' + gorouter_routes.homeRoute,
      (context, match) => const gorouter.GoRouterApp(),
    ),
    Path(
      r'^' + material_3_demo_routes.homeRoute,
      (context, match) => const material_3_demo.App(),
    ),
    Path(
      r'^' + rally_routes.homeRoute,
      (context, match) => const rally.RallyApp(),
    ),
    Path(
      r'^' + widgetbook_workspace_routes.homeRoute,
      (context, match) => const widgetbook_workspace.WidgetbookApp(),
    ),
    Path(
      r'^' + scrolling_routes.homeRoute,
      (context, match) => const scrolling.PageViewExampleApp(),
    ),
    Path(
      r'^',
      (context, match) => const RootPage(),
    ),
  ];

  /// The route generator callback used when the app is navigated to a named
  /// route. Set it on the [MaterialApp.onGenerateRoute] or
  /// [WidgetsApp.onGenerateRoute] to make use of the [paths] for route
  /// matching.
  static Route<dynamic>? onGenerateRoute(
    RouteSettings settings,
  ) {
    for (final path in paths) {
      final regExpPattern = RegExp(path.pattern);
      if (regExpPattern.hasMatch(settings.name!)) {
        final firstMatch = regExpPattern.firstMatch(settings.name!)!;
        final match = (firstMatch.groupCount == 1) ? firstMatch.group(1) : null;
        if (kIsWeb) {
          return NoAnimationMaterialPageRoute<void>(
            builder: (context) => path.builder(context, match),
            settings: settings,
          );
        }
        return MaterialPageRoute<void>(
          builder: (context) => path.builder(context, match),
          settings: settings,
        );
      }
    }
    return null;
  }
}

class NoAnimationMaterialPageRoute<T> extends MaterialPageRoute<T> {
  NoAnimationMaterialPageRoute({
    required super.builder,
    super.settings,
  });

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return child;
  }
}
