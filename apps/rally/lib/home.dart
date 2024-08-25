import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../tabs/overview.dart';

const int tabCount = 1;

class RallyHomePage extends StatefulWidget {
  const RallyHomePage({Key? key}) : super(key: key);

  @override
  State<RallyHomePage> createState() => _RallyHomePageState();
}

class _RallyHomePageState extends State<RallyHomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 1, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const verticalRotation = 1;
    const revertVerticalRotation = 3;
    Widget tabBarView;
    if (kIsWeb) {
      tabBarView = Row(
        children: [
          Container(
            width: 150,
            alignment: Alignment.topCenter,
            padding: const EdgeInsets.symmetric(vertical: 32),
            // Rotate the tab bar, so the animation is vertical for desktops.
            child: RotatedBox(
              quarterTurns: verticalRotation,
              child: _RallyTabBar(
                tabs: _buildTabs(
                  context: context,
                  theme: theme,
                  isVertical: true,
                ).map((widget) {
                  // Revert the rotation on the tabs.
                  return RotatedBox(
                    quarterTurns: revertVerticalRotation,
                    child: widget,
                  );
                }).toList(),
                tabController: _tabController,
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: _buildTabViews(),
            ),
          )
        ],
      );
    } else {
      tabBarView = const Placeholder();
    }
    return Scaffold(
      body: Scaffold(
        body: SafeArea(
          top: !kIsWeb,
          bottom: !kIsWeb,
          child: tabBarView,
        ),
      ),
    );
  }

  List<Widget> _buildTabs({
    required BuildContext context,
    required ThemeData theme,
    bool isVertical = false,
  }) {
    return [
      _RallyTab(
        theme: theme,
        iconData: Icons.pie_chart,
        title: 'OVERVIEW',
        tabIndex: 0,
        tabController: _tabController,
        isVertical: isVertical,
      ),
    ];
  }

  List<Widget> _buildTabViews() {
    return const [
      DemoPage(slug: 'rally'),
    ];
  }
}

class _RallyTabBar extends StatelessWidget {
  const _RallyTabBar({
    required this.tabs,
    this.tabController,
  });

  final List<Widget> tabs;
  final TabController? tabController;

  @override
  Widget build(BuildContext context) {
    // Setting isScrollable to true prevents the tabs from being
    // wrapped in [Expanded] widgets, which allows for more
    // flexible sizes and size animations among tabs.
    return TabBar(
      isScrollable: true,
      labelPadding: EdgeInsets.zero,
      tabs: tabs,
      controller: tabController,
      indicatorColor: Colors.transparent,
    );
  }
}

class _RallyTab extends StatefulWidget {
  _RallyTab({
    required ThemeData theme,
    IconData? iconData,
    required String title,
    int? tabIndex,
    required TabController tabController,
    required this.isVertical,
  })  : titleText = Text(title, style: theme.textTheme.labelLarge),
        isExpanded = tabController.index == tabIndex,
        icon = Icon(iconData, semanticLabel: title);

  final Text titleText;
  final Icon icon;
  final bool isExpanded;
  final bool isVertical;

  @override
  _RallyTabState createState() => _RallyTabState();
}

class _RallyTabState extends State<_RallyTab>
    with SingleTickerProviderStateMixin {
  late Animation<double> _titleSizeAnimation;
  late Animation<double> _titleFadeAnimation;
  late Animation<double> _iconFadeAnimation;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _titleSizeAnimation = _controller.view;
    _titleFadeAnimation = _controller.drive(CurveTween(curve: Curves.easeOut));
    _iconFadeAnimation = _controller.drive(Tween<double>(begin: 0.6, end: 1));
    if (widget.isExpanded) {
      _controller.value = 1;
    }
  }

  @override
  void didUpdateWidget(_RallyTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isExpanded) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isVertical) {
      return Column(children: [
        const SizedBox(height: 18),
        FadeTransition(
          opacity: _iconFadeAnimation,
          child: widget.icon,
        ),
        const SizedBox(height: 12),
        FadeTransition(
          opacity: _titleFadeAnimation,
          child: SizeTransition(
            axis: Axis.horizontal,
            axisAlignment: -1,
            sizeFactor: _titleSizeAnimation,
            child: Center(child: ExcludeSemantics(child: widget.titleText)),
          ),
        ),
        const SizedBox(height: 18),
      ]);
    }

    // Calculate the width of each unexpanded tab by counting the number of
    // units and dividing it into the screen width. Each unexpanded tab is 1
    // unit, and there is always 1 expanded tab which is 1 unit + any extra
    // space determined by the multiplier.
    final width = MediaQuery.of(context).size.width;
    const expandedTitleWidthMultiplier = 2;
    final unitWidth = width / (tabCount + expandedTitleWidthMultiplier);

    return ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 56),
        child: Row(
          children: [
            FadeTransition(
                opacity: _iconFadeAnimation,
                child: SizedBox(
                  width: unitWidth,
                  child: widget.icon,
                )),
            FadeTransition(
                opacity: _titleFadeAnimation,
                child: SizeTransition(
                    axis: Axis.horizontal,
                    axisAlignment: -1,
                    sizeFactor: _titleSizeAnimation,
                    child: SizedBox(
                        width: unitWidth * expandedTitleWidthMultiplier,
                        child: Center(
                          child: ExcludeSemantics(child: widget.titleText),
                        ))))
          ],
        ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
