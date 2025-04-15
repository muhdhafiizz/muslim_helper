import 'package:flutter/material.dart';

class FidyahEntry {
  final String year;
  final int days;

  FidyahEntry({required this.year, required this.days});
}

class FidyahProvider with ChangeNotifier {
  final List<FidyahEntry> _entries = [];
  final double _rate = 4.0;

  List<FidyahEntry> get entries => _entries;

  String _tempYear = '';
  int _tempDays = 0;

  void setDays(String value) {
    _tempDays = int.tryParse(value) ?? 0;
  }

  void setYear(String value) {
    _tempYear = value;
  }

  void addEntry() {
    if (_tempYear.isEmpty || _tempDays <= 0) return;
    _entries.add(FidyahEntry(year: _tempYear, days: _tempDays));
    _tempYear = '';
    _tempDays = 0;
    notifyListeners();
  }

  void clearEntry() {
    _entries.clear();
    notifyListeners();
  }

  double get total {
    return _entries.fold(0.0, (sum, entry) => sum + (entry.days * _rate));
  }
}
