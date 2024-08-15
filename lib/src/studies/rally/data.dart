import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:portofolio/src/studies/rally/formatters.dart';

/// Calculates the sum of the primary amounts of a list of [AccountData].
double sumAccountDataPrimaryAmount(List<AccountData> items) =>
    sumOf<AccountData>(items, (item) => item.primaryAmount);

/// Calculates the sum of the primary amounts of a list of [BillData].
double sumBillDataPrimaryAmount(List<BillData> items) =>
    sumOf<BillData>(items, (item) => item.primaryAmount);

/// Calculates the sum of the primary amounts of a list of [BudgetData].
double sumBudgetDataPrimaryAmount(List<BudgetData> items) =>
    sumOf<BudgetData>(items, (item) => item.primaryAmount);

/// Utility function to sum up values in a list.
double sumOf<T>(List<T> list, double Function(T elt) getValue) {
  var sum = 0.0;
  for (var elt in list) {
    sum += getValue(elt);
  }
  return sum;
}

/// A data model for an account.
///
/// The [primaryAmount] is the balance of the account in USD.
class AccountData {
  const AccountData({
    required this.name,
    required this.primaryAmount,
    required this.accountNumber,
  });

  /// The display name of this entity.
  final String name;

  /// The primary amount or value of this entity.
  final double primaryAmount;

  /// The full displayable account number.
  final String accountNumber;
}

/// A data model for a bill.
///
/// The [primaryAmount] is the amount due in USD.
class BillData {
  const BillData({
    required this.name,
    required this.primaryAmount,
    required this.dueDate,
    this.isPaid = false,
  });

  /// The display name of this entity.
  final String name;

  /// The primary amount or value of this entity.
  final double primaryAmount;

  /// The due date of this bill.
  final String dueDate;

  /// If this bill has been paid.
  final bool isPaid;
}

/// A data model for a budget.`
///
/// The [primaryAmount] is the budget cap in USD.
class BudgetData {
  const BudgetData({
    required this.name,
    required this.primaryAmount,
    required this.amountUsed,
  });

  /// The display name of this entity.
  final String name;

  /// The primary amount or value of this entity.
  final double primaryAmount;

  /// Amount of the budget that is consumed or used.
  final double amountUsed;
}

/// A data model for an alert
class AlertData {
  AlertData({this.message, this.iconData});

  /// The alert message to display.
  final String? message;

  /// The icon to display with the alert.
  final IconData? iconData;
}

class DetailedEventData {
  const DetailedEventData({
    required this.title,
    required this.date,
    required this.amount,
  });

  final String title;
  final DateTime date;
  final double amount;
}

/// Class to return dummy data lists.
///
/// In a real app, this might be replaced with some asynchronous service.
class DummyDataService {
  static List<AccountData> getAccountDataList() {
    return <AccountData>[
      const AccountData(
        name: 'Current',
        primaryAmount: 2215.13,
        accountNumber: '1234561234',
      ),
      const AccountData(
        name: 'Home Savings',
        primaryAmount: 8678.88,
        accountNumber: '8888885678',
      ),
      const AccountData(
        name: 'Car Savings',
        primaryAmount: 987.48,
        accountNumber: '8888889012',
      ),
      const AccountData(
        name: 'Annual Percentage Yield',
        primaryAmount: 253,
        accountNumber: '1231233456',
      ),
    ];
  }

  static List<DetailedEventData> getDetailedEventItems() {
    // The following titles are not localized as they're product/brand names.
    return <DetailedEventData>[
      DetailedEventData(
        title: 'Genoe',
        date: DateTime.utc(2019, 1, 24),
        amount: -16.54,
      ),
      DetailedEventData(
        title: 'Fortnightly Subscribe',
        date: DateTime.utc(2019, 1, 5),
        amount: -12.54,
      ),
      DetailedEventData(
        title: 'Circle Cash',
        date: DateTime.utc(2019, 1, 5),
        amount: 365.65,
      ),
      DetailedEventData(
        title: 'Crane Hospitality',
        date: DateTime.utc(2019, 1, 4),
        amount: -705.13,
      ),
      DetailedEventData(
        title: 'ABC Payroll',
        date: DateTime.utc(2018, 12, 15),
        amount: 1141.43,
      ),
      DetailedEventData(
        title: 'Shrine',
        date: DateTime.utc(2018, 12, 15),
        amount: -88.88,
      ),
      DetailedEventData(
        title: 'Foodmates',
        date: DateTime.utc(2018, 12, 4),
        amount: -11.69,
      ),
    ];
  }

  static List<BillData> getBillDataList() {
    // The following names are not localized as they're product/brand names.
    return <BillData>[
      BillData(
        name: 'RedPay Credit',
        primaryAmount: 45.36,
        dueDate:
            dateFormatAbbreviatedMonthDay().format(DateTime.utc(2019, 1, 29)),
      ),
      BillData(
        name: 'Rent',
        primaryAmount: 1200,
        dueDate:
            dateFormatAbbreviatedMonthDay().format(DateTime.utc(2019, 2, 9)),
      ),
      BillData(
        name: 'TabFine Credit',
        primaryAmount: 87.33,
        dueDate:
            dateFormatAbbreviatedMonthDay().format(DateTime.utc(2019, 2, 22)),
      ),
      BillData(
        name: 'ABC Loans',
        primaryAmount: 400,
        dueDate:
            dateFormatAbbreviatedMonthDay().format(DateTime.utc(2019, 2, 29)),
      ),
    ];
  }

  static List<BudgetData> getBudgetDataList() {
    return <BudgetData>[
      const BudgetData(
        name: 'Coffee Shops',
        primaryAmount: 70,
        amountUsed: 45.49,
      ),
      const BudgetData(
        name: 'Groceries',
        primaryAmount: 170,
        amountUsed: 16.45,
      ),
      const BudgetData(
        name: 'Restaurants',
        primaryAmount: 170,
        amountUsed: 123.25,
      ),
      const BudgetData(
        name: 'Clothing',
        primaryAmount: 70,
        amountUsed: 19.45,
      ),
    ];
  }

  static List<AlertData> getAlerts() {
    final firstData = percentFormat().format(0.9);
    final secondData = usdWithSignFormat().format(120);
    final thirdData = usdWithSignFormat().format(24);
    final fourthData = percentFormat().format(0.04);
    const fifthData = 16;
    return <AlertData>[
      AlertData(
          message:
              'Heads up, you\'ve used up $firstData of your Shopping budget for this month.',
          iconData: Icons.sort),
      AlertData(
          message: 'You\'ve spent $secondData on Restaurants this week.',
          iconData: Icons.sort),
      AlertData(
        message: 'You\'ve spent $thirdData in ATM fees this month;',
        iconData: Icons.credit_card,
      ),
      AlertData(
        message:
            'Good work! Your checking account is $fourthData higher than last month.',
        iconData: Icons.attach_money,
      ),
      AlertData(
        message:
            'Increase your potential tax deduction! Assign categories to $fifthData unassigned transactions.',
        iconData: Icons.not_interested,
      ),
    ];
  }
}
