import 'package:flutter/material.dart';

class ZakatSahamEntry {
  final int year;
  final String shariahCompliance;
  final String nameOfInvestment;
  final double unit;
  final double price;
  final double dividend;

  ZakatSahamEntry({
    required this.year,
    required this.shariahCompliance,
    required this.nameOfInvestment,
    required this.unit,
    required this.price,
    required this.dividend,
  });

  double get totalValue => price + dividend;
}

class ZakatSahamProvider with ChangeNotifier {
  final TextEditingController yearController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController unitController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController dividendController = TextEditingController();
  final TextEditingController trustBalanceController = TextEditingController();
  final TextEditingController relatedCostController = TextEditingController();

  String shariahCompliance = "Shariah";
  String? errorText;

  List<ZakatSahamEntry> entries = [];

  final List<String> shariahCompliant = [
    "Shariah compliance",
    "Non shariah compliance",
  ];

  static const double nisabAmount = 29740.0;

  void setShariahCompliance(String? value) {
    if (value != null) {
      shariahCompliance = value;

      if (value.toLowerCase() == "non shariah compliance") {
        errorText =
            'Any profits from the resale of non-Shariah compliant shares must be disposed of by handing them over to Baitulmal (Treasury of Muslims) or charitable channels.';
      } else {
        errorText = null;
      }

      notifyListeners();
    }
  }

  void addEntry() {
    final entry = ZakatSahamEntry(
      year: int.tryParse(yearController.text) ?? 0,
      shariahCompliance: shariahCompliance,
      nameOfInvestment: nameController.text,
      unit: double.tryParse(unitController.text) ?? 0.0,
      price: double.tryParse(priceController.text) ?? 0.0,
      dividend: double.tryParse(dividendController.text) ?? 0.0,
    );

    entries.add(entry);
    clearInputs();
    notifyListeners();
  }

  void clearInputs() {
    yearController.clear();
    nameController.clear();
    unitController.clear();
    priceController.clear();
    dividendController.clear();
  }

  void clearEntries() {
    entries.clear();
    notifyListeners();
  }

  double get totalValue => entries.fold(0, (sum, e) => sum + e.totalValue);

  double get finalValue {
    final trust = double.tryParse(trustBalanceController.text) ?? 0.0;
    final cost = double.tryParse(relatedCostController.text) ?? 0.0;
    return totalValue + trust - cost;
  }

  bool get isZakatApplicable => finalValue >= nisabAmount;

  double get zakatPayable => isZakatApplicable ? finalValue * 0.025 : 0.0;
}
