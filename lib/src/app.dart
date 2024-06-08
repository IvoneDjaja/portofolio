import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:portofolio/data/gallery_options.dart';
import 'package:portofolio/routes.dart';
import 'package:portofolio/themes/gallery_theme_data.dart';

/// The Widget that configures your application.
class PortofolioApp extends StatelessWidget {
  const PortofolioApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ModelBinding(
      initialModel: GalleryOptions(
        themeMode: ThemeMode.light,
      ),
      child: Builder(builder: (context) {
        final options = GalleryOptions.of(context);
        return MaterialApp(
          // Providing a restorationScopeId allows the Navigator built by the
          // MaterialApp to restore the navigation stack when a user leaves and
          // returns to the app after it has been killed while running in the
          // background.
          restorationScopeId: 'app',

          // Provide the generated AppLocalizations to the MaterialApp. This
          // allows descendant Widgets to display the correct translations
          // depending on the user's locale.
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', ''), // English, no country code
          ],

          // Use AppLocalizations to configure the correct application title
          // depending on the user's locale.
          //
          // The appTitle is defined in .arb files found in the localization
          // directory.
          onGenerateTitle: (BuildContext context) =>
              AppLocalizations.of(context)!.appTitle,
          themeMode: options.themeMode,
          theme: GalleryThemeData.lightThemeData,
          darkTheme: GalleryThemeData.darkThemeData,

          // Define a function to handle named routes in order to support
          // Flutter web url navigation and deep linking.
          onGenerateRoute: (settings) =>
              RouteConfiguration.onGenerateRoute(settings),
        );
      }),
    );
  }
}
