import 'package:flutter/material.dart';

class ZakatKWSPEntry {
  final int year;
  final String typeOfCashout;
  final double amountOfCashout;

  ZakatKWSPEntry({
    required this.year,
    required this.typeOfCashout,
    required this.amountOfCashout,
  });
}

class ZakatKwspProvider with ChangeNotifier {
  final List<ZakatKWSPEntry> _entries = [];

  List<ZakatKWSPEntry> get entries => _entries;

  static const double nisab = 29740.0;

  final List<String> nonZakatReasons = [
    "To go Hajj",
    "Become disable",
    "Because of health",
    "Because of education",
    "Because of housing (basic needs)",
  ];

  final List<String> zakatReasons = [
    "Saving over 1 million",
    "Age reached 50/55/60 years",
    "Leave country (lose citizenship)",
    "Retiree",
    "Because of housing (investment)",
  ];

  String _selectedType = '';
  String get selectedType => _selectedType;

  void setTypeOfCashout(String value) {
    _selectedType = value;
    notifyListeners();
  }

  void addEntry(int year, double amountOfCashout) {
    if (_selectedType.isEmpty || amountOfCashout <= 0) return;
    _entries.add(
      ZakatKWSPEntry(
        year: year,
        typeOfCashout: _selectedType,
        amountOfCashout: amountOfCashout,
      ),
    );
    _selectedType = '';
    notifyListeners();
  }

  double get totalZakat {
    return _entries.fold(0.0, (total, entry) {
      final shouldPay = zakatReasons.contains(entry.typeOfCashout);
      final isAboveNisab = entry.amountOfCashout >= nisab;
      if (shouldPay && isAboveNisab) {
        return total + (entry.amountOfCashout * 0.025);
      }
      return total;
    });
  }

  void clearAll() {
    _entries.clear();
    _selectedType = '';
    notifyListeners();
  }
}
