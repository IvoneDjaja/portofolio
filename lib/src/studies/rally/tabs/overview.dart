import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:portofolio/src/studies/rally/colors.dart';
import 'package:portofolio/src/studies/rally/data.dart';
import 'package:portofolio/src/studies/rally/finance.dart';
import 'package:portofolio/src/studies/rally/formatters.dart';

class OverviewView extends StatelessWidget {
  const OverviewView({super.key});

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 24),
          child: Row(children: [
            Flexible(
              flex: 7,
              child: _OverviewGrid(spacing: 24),
            ),
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
