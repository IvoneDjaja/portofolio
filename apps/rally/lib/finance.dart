import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

import 'charts/vertical_fraction_bar.dart';
import 'colors.dart';
import 'data.dart';
import '../formatters.dart';

/// A reusable widget to show balance information of a single entity as a card.
class FinancialEntityCategoryView extends StatelessWidget {
  const FinancialEntityCategoryView({
    super.key,
    required this.indicatorColor,
    required this.indicatorFraction,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.suffix,
  });

  final Color indicatorColor;
  final double indicatorFraction;
  final String title;
  final String subtitle;
  final String amount;
  final Widget suffix;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return OpenContainer(
      transitionDuration: const Duration(milliseconds: 350),
      transitionType: ContainerTransitionType.fade,
      openBuilder: (context, openContainer) => Placeholder(),
      openColor: RallyColors.primaryBackground,
      closedColor: RallyColors.primaryBackground,
      closedElevation: 0,
      closedBuilder: (context, openContainer) {
        return TextButton(
          onPressed: openContainer,
          child: Column(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                child: Row(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      height: 32,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: VerticalFractionBar(
                        color: indicatorColor,
                        fraction: indicatorFraction,
                      ),
                    ),
                    Expanded(
                      child: Wrap(
                        alignment: WrapAlignment.spaceBetween,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                style: textTheme.bodyMedium!
                                    .copyWith(fontSize: 16),
                              ),
                              Text(
                                subtitle,
                                style: textTheme.bodyMedium!
                                    .copyWith(color: RallyColors.gray60),
                              )
                            ],
                          ),
                          Text(
                            amount,
                            style: textTheme.bodyLarge!.copyWith(
                              fontSize: 20,
                              color: RallyColors.gray,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

FinancialEntityCategoryView buildFinancialEntityFromAccountData(
  AccountData model,
  int accountDataIndex,
) {
  final amount = usdWithSignFormat().format(model.primaryAmount);
  final shortAccountNumber = model.accountNumber.substring(6);
  return FinancialEntityCategoryView(
    suffix: const Icon(Icons.chevron_right, color: Colors.grey),
    title: model.name,
    subtitle: '• • • • • • $shortAccountNumber',
    indicatorColor: RallyColors.accountColor(accountDataIndex),
    indicatorFraction: 1,
    amount: amount,
  );
}

FinancialEntityCategoryView buildFinancialEntityFromBillData(
  BillData model,
  int accountDataIndex,
) {
  final amount = usdWithSignFormat().format(model.primaryAmount);
  return FinancialEntityCategoryView(
    suffix: const Icon(Icons.chevron_right, color: Colors.grey),
    title: model.name,
    subtitle: model.dueDate,
    indicatorColor: RallyColors.billColor(accountDataIndex),
    indicatorFraction: 1,
    amount: amount,
  );
}

FinancialEntityCategoryView buildFinancialEntityFromBudgetData(
  BudgetData model,
  int budgetDataIndex,
) {
  final amountUsed = usdWithSignFormat().format(model.amountUsed);
  final primaryAmount = usdWithSignFormat().format(model.primaryAmount);
  final amount =
      usdWithSignFormat().format(model.primaryAmount - model.amountUsed);
  return FinancialEntityCategoryView(
    suffix: const Text('LEFT'),
    title: model.name,
    subtitle: '$amountUsed / $primaryAmount',
    indicatorColor: RallyColors.budgetColor(budgetDataIndex),
    indicatorFraction: model.amountUsed / model.primaryAmount,
    amount: amount,
  );
}

class FinancialEntityCategoryDetailsPage extends StatelessWidget {
  FinancialEntityCategoryDetailsPage({super.key});

  final List<DetailedEventData> items =
      DummyDataService.getDetailedEventItems();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Checking',
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 18),
        ),
      ),
    );
  }
}

List<FinancialEntityCategoryView> buildAccountDataListViews(
  List<AccountData> items,
) {
  return List<FinancialEntityCategoryView>.generate(
    items.length,
    (i) => buildFinancialEntityFromAccountData(items[i], i),
  );
}

List<FinancialEntityCategoryView> buildBillDataListViews(
  List<BillData> items,
) {
  return List<FinancialEntityCategoryView>.generate(
    items.length,
    (i) => buildFinancialEntityFromBillData(items[i], i),
  );
}

List<FinancialEntityCategoryView> buildBudgetDataListViews(
  List<BudgetData> items,
) {
  return List<FinancialEntityCategoryView>.generate(
    items.length,
    (i) => buildFinancialEntityFromBudgetData(items[i], i),
  );
}
