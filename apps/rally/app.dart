import 'colors.dart';
import 'home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../portofolio/layout/letter_spacing.dart';
import 'routes.dart' as routes;

class RallyApp extends StatelessWidget {
  const RallyApp({super.key});

  static const String homeRoute = routes.homeRoute;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        restorationScopeId: 'rally_app',
        title: 'Rally',
        initialRoute: homeRoute,
        theme: _buildRallyTheme(),
        routes: <String, WidgetBuilder>{
          homeRoute: (context) => const RallyHomePage()
        });
  }

  ThemeData _buildRallyTheme() {
    final base = ThemeData.dark();
    return ThemeData(
        appBarTheme: const AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle.light,
          backgroundColor: RallyColors.primaryBackground,
          elevation: 0,
        ),
        scaffoldBackgroundColor: RallyColors.primaryBackground,
        focusColor: RallyColors.focusColor,
        textTheme: _buildRallyTextTheme(base.textTheme),
        inputDecorationTheme: const InputDecorationTheme(
          labelStyle: TextStyle(
            color: RallyColors.gray,
            fontWeight: FontWeight.w500,
          ),
          filled: true,
          fillColor: RallyColors.inputBackground,
          focusedBorder: InputBorder.none,
        ),
        visualDensity: VisualDensity.standard,
        colorScheme: base.colorScheme.copyWith(
          primary: RallyColors.primaryBackground,
        ));
  }

  TextTheme _buildRallyTextTheme(TextTheme base) {
    return base
        .copyWith(
            bodyMedium: GoogleFonts.robotoCondensed(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              letterSpacing: letterSpacingOrNone(0.5),
            ),
            bodyLarge: GoogleFonts.eczar(
              fontSize: 40,
              fontWeight: FontWeight.w400,
              letterSpacing: letterSpacingOrNone(1.4),
            ),
            labelLarge: GoogleFonts.robotoCondensed(
              fontWeight: FontWeight.w700,
              letterSpacing: letterSpacingOrNone(2.8),
            ),
            headlineSmall: GoogleFonts.eczar(
              fontSize: 40,
              fontWeight: FontWeight.w600,
              letterSpacing: letterSpacingOrNone(1.4),
            ))
        .apply(
          displayColor: Colors.white,
          bodyColor: Colors.white,
        );
  }
}
