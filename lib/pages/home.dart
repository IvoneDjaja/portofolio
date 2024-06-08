import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:portofolio/src/studies/drawing/routes.dart' as drawing_routes;

const _carouselItemDesktopMargin = 8.0;
const _carouselItemMobileMargin = 4.0;
const _carouselHeightMin = 240.0;
const _carouselItemWidth = 296.0;

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final carouselCards = <Widget>[
      const _CarouselCard(
        studyRoute: drawing_routes.homeRoute,
      )
    ];
    return Scaffold(
      body: ListView(
        key: const ValueKey('HomeListView'),
        children: carouselCards,
      ),
    );
  }
}

class _CarouselCard extends StatelessWidget {
  const _CarouselCard({
    super.key,
    required this.studyRoute,
  });

  final String studyRoute;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(
          horizontal:
              kIsWeb ? _carouselItemDesktopMargin : _carouselItemMobileMargin,
        ),
        margin: const EdgeInsets.symmetric(vertical: 16.0),
        height: _carouselHeightMin,
        width: _carouselItemWidth,
        child: Material(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(children: [
              const Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text('Title'),
                    Text('Subtitle'),
                  ],
                ),
              ),
              Positioned.fill(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context)
                          .popUntil((route) => route.settings.name == '/');
                      Navigator.of(context).restorablePushNamed(studyRoute);
                    },
                  ),
                ),
              )
            ])));
  }
}
