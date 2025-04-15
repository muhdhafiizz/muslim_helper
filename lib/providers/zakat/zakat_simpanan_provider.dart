import 'package:flutter/material.dart';

class ZakatSimpananEntry {
  final int year;
  final String bankName;
  final double bankAmount;

  ZakatSimpananEntry({
    required this.year,
    required this.bankName,
    required this.bankAmount,
  });
}

class ZakatSimpananProvider with ChangeNotifier {
  final List<ZakatSimpananEntry> _entries = [];
  final yearController = TextEditingController();
  final amountController = TextEditingController();

  List<ZakatSimpananEntry> get entries => _entries;

  static const double nisab = 29740.0;

  final List<String> malaysiaBankName = [
    'Maybank',
    'Public Bank',
    'CIMB Bank',
    'RHB Bank',
    'Hong Leong Bank',
    'AmBank',
    'Alliance Bank',
    'Affin Bank',
    'Bank Islam Malaysia',
    'Bank Muamalat Malaysia',
    'MBSB Bank',
    'Agrobank',
    'Bank Rakyat',
    'Bank Simpanan Nasional (BSN)',
    'Al Rajhi Bank',
    'OCBC Bank (Malaysia)',
    'Standard Chartered Bank Malaysia',
    'HSBC Bank Malaysia',
    'UOB Malaysia',
    'Kuwait Finance House (Malaysia)',
    'Affin Islamic Bank',
    'Alliance Islamic Bank',
    'AmBank Islamic',
    'CIMB Islamic Bank',
    'Hong Leong Islamic Bank',
    'Maybank Islamic Berhad',
    'Public Islamic Bank',
    'RHB Islamic Bank',
    'Standard Chartered Saadiq Berhad',
    'HSBC Amanah Malaysia Berhad',
    'OCBC Al-Amin Bank Berhad',
    'GXBank',
    'Boost Bank',
    'AEON Bank',
    'KAF Digital Bank',
    'Ryt Bank (formerly YTL-Sea Digital Bank)',
  ];

  String _selectedBank = '';
  String get selectedBank => _selectedBank;

  void setSelectedBank(String bank) {
    _selectedBank = bank;
    notifyListeners();
  }

  void addEntry(int year, String bankName, double bankAmount) {
    if (year > 0 && bankName.isNotEmpty && bankAmount > 0) {
      _entries.add(ZakatSimpananEntry(
          year: year, bankName: bankName, bankAmount: bankAmount));
      notifyListeners();
    }
  }

  void clearEntries() {
    _entries.clear();
    notifyListeners();
  }

  double get totalAmount => _entries.fold(0, (sum, e) => sum + e.bankAmount);

  double get zakatPayable => totalAmount >= nisab ? totalAmount * 0.025 : 0.0;

  bool get isZakatApplicable => totalAmount >= nisab;
}
