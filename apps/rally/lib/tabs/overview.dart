import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rally/pages/demo.dart';

import 'package:rally/data/demos.dart';
import 'package:flutter/foundation.dart';
import 'package:rally/codeviewer/code_displayer.dart';
import 'package:rally/codeviewer/code_style.dart';

import '../colors.dart';
import '../data.dart';
import '../finance.dart';
import '../formatters.dart';

enum _DemoState {
  code,
}

class DemoPage extends StatefulWidget {
  const DemoPage({
    super.key,
    required this.slug,
  });

  static const String baseRoute = '/demo';
  final String? slug;

  @override
  State<DemoPage> createState() => _DemoPageState();
}

class _DemoPageState extends State<DemoPage> {
  late Map<String?, GalleryDemo> slugToDemoMap;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // To make sure that we do not rebuild the map for every update to the demo
    // page, we save it in a variable. The cost of running `slugToDemo` is
    // still only close to constant, as it's just iterating over all of the
    // demos.
    slugToDemoMap = Demos.asSlugToDemoMap();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.slug == null || !slugToDemoMap.containsKey(widget.slug)) {
      Navigator.of(context).pop();
    }
    return ScaffoldMessenger(
        child: GalleryDemoPage(demo: slugToDemoMap[widget.slug]!));
  }
}

class GalleryDemoPage extends StatefulWidget {
  const GalleryDemoPage({
    super.key,
    required this.demo,
  });

  final GalleryDemo demo;

  @override
  State<GalleryDemoPage> createState() => _GalleryDemoPageState();
}

class _GalleryDemoPageState extends State<GalleryDemoPage> {
  // final RestorableInt _configIndex = RestorableInt(0);

  GalleryDemoConfiguration get _currentConfig {
    // return widget.demo.configurations[_configIndex.value];
    return widget.demo.configurations.first;
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final contentHeight = mediaQuery.size.height -
        mediaQuery.padding.top -
        mediaQuery.padding.bottom;
    final codeTheme = GoogleFonts.robotoMono(
      fontSize: 12,
    );
    final maxSectionHeight = kIsWeb ? contentHeight : contentHeight - 64;
    return CodeStyle(
        baseStyle: codeTheme.copyWith(color: const Color(0xFFFAFBFB)),
        numberStyle: codeTheme.copyWith(color: const Color(0xFFBD93F9)),
        commentStyle: codeTheme.copyWith(color: const Color(0xFF808080)),
        keywordStyle: codeTheme.copyWith(color: const Color(0xFF1CDEC9)),
        stringStyle: codeTheme.copyWith(color: const Color(0xFFFFA65C)),
        punctuationStyle: codeTheme.copyWith(color: const Color(0xFF8BE9FD)),
        classStyle: codeTheme.copyWith(color: const Color(0xFFD65BAD)),
        constantStyle: codeTheme.copyWith(color: const Color(0xFFFF8383)),
        child: _DemoSectionCode(
            maxHeight: maxSectionHeight,
            codeWidget: CodeDisplayPage(
              _currentConfig.code,
            )));
  }
}

class CodeDisplayPage extends StatelessWidget {
  const CodeDisplayPage(this.code, {super.key});

  final CodeDisplayer code;

  @override
  Widget build(BuildContext context) {
    final richTextCode = code(context);
    return Expanded(
      child: SingleChildScrollView(
        child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: SelectableText.rich(
              richTextCode,
              textDirection: TextDirection.ltr,
            )),
      ),
    );
  }
}

class _DemoSectionCode extends StatelessWidget {
  const _DemoSectionCode({
    super.key,
    this.maxHeight,
    this.codeWidget,
  });

  final double? maxHeight;
  final Widget? codeWidget;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          height: maxHeight,
          child: codeWidget,
        ));
  }
}

class OverviewView extends StatelessWidget {
  const OverviewView({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final contentHeight = mediaQuery.size.height -
        mediaQuery.padding.top -
        mediaQuery.padding.bottom;
    final maxSectionHeight = kIsWeb ? contentHeight : contentHeight - 64;

    if (kIsWeb) {
      return SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 24),
          child: Row(children: [
            // Flexible(
            //     flex: 7,
            //     child:
            //         _OverviewGrid(spacing: 24),
            //         DemoSectionCode(
            //       maxHeight: maxSectionHeight,
            //       codeWidget: CodeDisplayPage(
            //         _currentConfig.code,
            //       ),
            //     )),
            SizedBox(width: 24),
            Flexible(
              flex: 3,
              child: Placeholder(),
            )
          ]),
        ),
      );
    }
    return const SingleChildScrollView(
      child: Column(
        children: [
          Placeholder(),
          SizedBox(height: 12),
          Placeholder(),
        ],
      ),
    );
  }
}

class _OverviewGrid extends StatelessWidget {
  const _OverviewGrid({required this.spacing});

  final double spacing;

  @override
  Widget build(BuildContext context) {
    final accountDataList = DummyDataService.getAccountDataList();
    final billDataList = DummyDataService.getBillDataList();
    final budgetDataList = DummyDataService.getBudgetDataList();

    return LayoutBuilder(builder: (context, constraints) {
      const minWidthForTwoColumns = 600;
      final hasMultipleColumns =
          kIsWeb && constraints.maxWidth > minWidthForTwoColumns;
      final boxWidth = hasMultipleColumns
          ? constraints.maxWidth / 2 - spacing / 2
          : double.infinity;

      return Wrap(runSpacing: spacing, children: [
        SizedBox(
          width: boxWidth,
          child: _FinancialView(
            title: 'Accounts',
            total: sumAccountDataPrimaryAmount(accountDataList),
            financialItemViews: buildAccountDataListViews(accountDataList),
          ),
        ),
        if (hasMultipleColumns) SizedBox(width: spacing),
        SizedBox(
          width: boxWidth,
          child: _FinancialView(
            title: 'Bills',
            total: sumBillDataPrimaryAmount(billDataList),
            financialItemViews: buildBillDataListViews(billDataList),
          ),
        ),
        _FinancialView(
          title: 'Budgets',
          total: sumBudgetDataPrimaryAmount(budgetDataList),
          financialItemViews: buildBudgetDataListViews(budgetDataList),
        ),
      ]);
    });
  }
}

class _FinancialView extends StatelessWidget {
  const _FinancialView({
    required this.title,
    required this.total,
    this.financialItemViews,
  });

  final String title;
  final double? total;
  final List<FinancialEntityCategoryView>? financialItemViews;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      color: RallyColors.cardBackground,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 16,
              left: 16,
              right: 16,
            ),
            child: SelectableText(title),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SelectableText(usdWithSignFormat().format(total),
                style: theme.textTheme.bodyLarge!.copyWith(
                  fontSize: 44,
                  fontWeight: FontWeight.w600,
                )),
          ),
          ...financialItemViews!
              .sublist(0, math.min(financialItemViews!.length, 3)),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.white),
            onPressed: () {},
            child: const Text(
              'SEE ALL',
            ),
          ),
        ],
      ),
    );
  }
}
