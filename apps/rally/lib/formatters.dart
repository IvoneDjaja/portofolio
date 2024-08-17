import 'package:intl/intl.dart';

/// Currency formatter for USD.
NumberFormat usdWithSignFormat() {
  return NumberFormat.currency(
    name: '\$',
  );
}

/// Percent formatter with two decimal points.
NumberFormat percentFormat() {
  return NumberFormat.decimalPercentPattern();
}

/// Date formatter with abbreviated month and day.
DateFormat dateFormatAbbreviatedMonthDay() => DateFormat.MMMd();
