import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Formatting {
  // Currency formatting
  static String currency(double amount, {int decimalDigits = 2}) {
    return NumberFormat.currency(
      symbol: 'RM ',
      decimalDigits: decimalDigits,
    ).format(amount);
  }

  // Percentage formatting
  static String percentage(double value, {int decimalDigits = 1}) {
    return NumberFormat.decimalPercentPattern(
      decimalDigits: decimalDigits,
    ).format(value);
  }

  // Date formatting
  static String date(DateTime date, {String format = 'dd/MM/yyyy'}) {
    return DateFormat(format).format(date);
  }

  // Compact number formatting (e.g., 1.2K, 3.5M)
  static String compact(double number) {
    return NumberFormat.compact().format(number);
  }

  // Widget for formatted currency display
  static Widget currencyText(double amount, {
    TextStyle? style,
    int decimalDigits = 2,
  }) {
    return Text(
      currency(amount, decimalDigits: decimalDigits),
      style: style,
    );
  }

  // Widget for formatted percentage display
  static Widget percentageText(double value, {
    TextStyle? style,
    int decimalDigits = 1,
  }) {
    return Text(
      percentage(value, decimalDigits: decimalDigits),
      style: style,
    );
  }
}