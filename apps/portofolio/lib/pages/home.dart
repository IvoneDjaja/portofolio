import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:portofolio/data/demos.dart';
import 'package:portofolio/layout/adaptive.dart';
import 'package:transparent_image/transparent_image.dart';
import '../../constants.dart';
import 'package:rally/colors.dart' as rally_colors;
import 'package:rally/routes.dart' as rally_routes;
import 'package:gorouter/routes.dart' as gorouter_routes;
import 'package:material_3_demo/routes.dart' as material_3_demo_routes;
import 'package:widgetbook_workspace/routes.dart'
    as widgetbook_workspace_routes;
import 'package:scrolling/routes.dart' as scrolling_routes;

const _horizontalPadding = 32.0;
const _horizontalDesktopPadding = 81.0;
const _carouselHeightMin = 240.0;
const _carouselItemDesktopMargin = 8.0;
const _carouselItemMobileMargin = 4.0;
const _carouselItemWidth = 296.0;

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final studyDemos = Demos.studies();
    final carouselCards = <Widget>[
      // _CarouselCard(
      //   demo: studyDemos['drawing'],
      //   studyRoute: '/${drawing_routes.homeRoute}',
      // ),
      _CarouselCard(
        demo: studyDemos['rally'],
        textColor: rally_colors.RallyColors.accountColors[0],
        studyRoute: '/${rally_routes.homeRoute}',
        asset: const AssetImage(
          'assets/studies/rally_card.png',
          package: 'flutter_gallery_assets',
        ),
      ),
      _CarouselCard(
        demo: studyDemos['material'],
        studyRoute: '/${material_3_demo_routes.homeRoute}',
        asset: const AssetImage(
          'assets/images/material_3_card.png',
        ),
      ),
      _CarouselCard(
        demo: studyDemos['gorouter'],
        studyRoute: '/${gorouter_routes.homeRoute}',
        asset: const AssetImage(
          'assets/images/go_router_card.png',
        ),
      ),
      _CarouselCard(
        demo: studyDemos['widgetbook'],
        studyRoute: '/${widgetbook_workspace_routes.homeRoute}',
        asset: const AssetImage(
          'assets/images/widgetbook_card.png',
        ),
      ),
      _CarouselCard(
        demo: studyDemos['scrolling'],
        studyRoute: '/${scrolling_routes.homeRoute}',
      ),
    ];
    return Scaffold(
      body: ListView(
        key: const ValueKey('HomeListView'),
        children: [
          const _DesktopHomeItem(child: _GalleryHeader()),
          _DesktopCarousel(
            height: _carouselHeightMin,
            children: carouselCards,
          ),
        ],
      ),
    );
  }
}

class _GalleryHeader extends StatelessWidget {
  const _GalleryHeader();

  @override
  Widget build(BuildContext context) {
    return Header(
      color: Theme.of(context).colorScheme.primaryContainer,
      text: 'Gallery',
    );
  }
}

class Header extends StatelessWidget {
  const Header({
    super.key,
    required this.color,
    required this.text,
  });

  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Padding(
        padding: const EdgeInsets.only(
          top: kIsWeb ? 63 : 15,
          bottom: kIsWeb ? 21 : 11,
        ),
        child: SelectableText(
          text,
          style: Theme.of(context).textTheme.headlineMedium!.apply(
                color: color,
                fontSizeDelta: kIsWeb ? desktopDisplay1FontDelta : 0,
              ),
        ),
      ),
    );
  }
}

/// This creates a horizontally scrolling [ListView] of items.
///
/// This class uses a [ListView] with a custom [ScrollPhysics] to enable
/// snapping behavior. A [PageView] was considered but does not allow for
/// multiple pages visible without centering the first page.
class _DesktopCarousel extends StatefulWidget {
  const _DesktopCarousel({
    required this.height,
    required this.children,
  });

  final double height;
  final List<Widget> children;

  @override
  State<_DesktopCarousel> createState() => _DesktopCarouselState();
}

class _DesktopCarouselState extends State<_DesktopCarousel> {
  late final ScrollController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var showPreviousButton = false;
    var showNextButton = true;

    // Only check this after the _controller has been attached to the ListView.
    if (_controller.hasClients) {
      showPreviousButton = _controller.offset > 0;
      showNextButton =
          _controller.offset < _controller.position.maxScrollExtent;
    }

    return Align(
      alignment: Alignment.center,
      child: Container(
        height: widget.height,
        constraints: const BoxConstraints(maxWidth: maxHomeItemWidth),
        child: Stack(
          children: [
            ListView.builder(
              padding: const EdgeInsets.symmetric(
                horizontal: kIsWeb
                    ? _horizontalDesktopPadding - _carouselItemDesktopMargin
                    : _horizontalPadding - _carouselItemMobileMargin,
              ),
              scrollDirection: Axis.horizontal,
              primary:
                  false, // Set as false because we are passing a controller,
              controller: _controller,
              itemExtent: _carouselItemWidth,
              itemCount: widget.children.length,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: widget.children[index],
              ),
            ),
            if (showPreviousButton)
              _DesktopPageButton(
                onTap: () {
                  _controller.animateTo(
                    _controller.offset - _carouselItemWidth,
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                  );
                },
              ),
            if (showNextButton)
              _DesktopPageButton(
                isEnd: true,
                onTap: () {
                  _controller.animateTo(
                    _controller.offset + _carouselItemWidth,
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}

class _DesktopPageButton extends StatelessWidget {
  const _DesktopPageButton({
    this.isEnd = false,
    this.onTap,
  });

  final bool isEnd;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    const buttonSize = 58.0;
    const padding = _horizontalDesktopPadding - buttonSize / 2;
    return Container(
      width: buttonSize,
      height: buttonSize,
      margin: EdgeInsetsDirectional.only(
        start: isEnd ? 0 : padding,
        end: isEnd ? padding : 0,
      ),
      child: Material(
          color: Colors.black.withOpacity(0.5),
          shape: const CircleBorder(),
          child: InkWell(
              onTap: onTap,
              child: Icon(
                isEnd ? Icons.arrow_forward_ios : Icons.arrow_back_ios,
                color: Colors.white,
              ))),
    );
  }
}

class _CarouselCard extends StatelessWidget {
  const _CarouselCard({
    required this.demo,
    required this.studyRoute,
    this.asset,
    this.textColor,
  });

  final GalleryDemo? demo;
  final String studyRoute;
  final ImageProvider? asset;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
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
        child: Stack(
          children: [
            if (asset != null)
              FadeInImage(
                image: asset!,
                placeholder: MemoryImage(kTransparentImage),
                fit: BoxFit.cover,
                height: _carouselHeightMin,
                fadeInDuration: entranceAnimationDuration,
              ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    demo!.title,
                    style: textTheme.bodySmall!.apply(color: textColor),
                    maxLines: 3,
                    overflow: TextOverflow.visible,
                  ),
                  Text(
                    demo!.subtitle,
                    style: textTheme.labelSmall!.apply(color: textColor),
                    maxLines: 5,
                    overflow: TextOverflow.visible,
                  ),
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
          ],
        ),
      ),
    );
  }
}

class _DesktopHomeItem extends StatelessWidget {
  const _DesktopHomeItem({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        constraints: const BoxConstraints(maxWidth: maxHomeItemWidth),
        padding: const EdgeInsets.symmetric(
          horizontal: _horizontalDesktopPadding,
        ),
        child: child,
      ),
    );
  }
}
