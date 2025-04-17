import 'package:flutter/material.dart';
import 'package:hadith_reader/core/app_color.dart';
import 'package:hadith_reader/providers/zakat/fidyah_provider.dart';
import 'package:hadith_reader/providers/zakat/zakat_kwsp_provider.dart';
import 'package:hadith_reader/providers/zakat/zakat_simpanan_provider.dart';
import 'package:hadith_reader/widgets/buttons.dart';
import 'package:hadith_reader/widgets/feature_not_ready_page.dart';
import 'package:hadith_reader/widgets/formatting.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../providers/zakat/zakat_saham_provider.dart' show ZakatSahamProvider;
import '../widgets/bottom_sheet.dart' show CustomBottomSheet;

class ZakatCalculatorDetailPage extends StatelessWidget {
  final String title;
  final String description;

  const ZakatCalculatorDetailPage({
    super.key,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    Widget content;

    if (title.toLowerCase() == 'fidyah') {
      content = _buildFidyahWidget();
    } else if (title.toLowerCase() == 'kwsp zakat') {
      content = _buildZakatKWSPWidget();
    } else if (title.toLowerCase() == 'savings zakat') {
      content = _buildZakatSimpananWidget();
    } else if (title.toLowerCase() == 'investment zakat') {
      content = buildZakatSahamWidget();
    } else {
      content = FeatureNotReadyPage();
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                      Icons.arrow_back,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 26,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(child: content),
          ],
        ),
      ),
    );
  }

  Widget _buildFidyahWidget() {
    return Consumer<FidyahProvider>(
      builder: (context, provider, child) {
        return SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Days input
                Text('Days missed',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                const SizedBox(height: 10),
                TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Days",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  onChanged: provider.setDays,
                ),

                const SizedBox(height: 20),

                // Year input
                Text('Year',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                const SizedBox(height: 10),
                TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "(e.g. 2022)",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  onChanged: provider.setYear,
                ),

                const SizedBox(height: 16),

                Buttons(
                  iconData: Icons.add,
                  text: "Add Entry",
                  onTap: () {
                    provider.addEntry();
                  },
                  backgroundColor: AppColors.success,
                  textColor: Colors.white,
                  borderColor: AppColors.success,
                  isFilled: true,
                ),

                Buttons(
                  iconData: Icons.delete,
                  text: "Clear Entry",
                  onTap: () => provider.clearEntry(),
                  backgroundColor: Colors.transparent,
                  textColor: AppColors.success,
                  borderColor: AppColors.success,
                  isFilled: false,
                ),

                const SizedBox(height: 24),

                // Entries List
                if (provider.entries.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Your Fidyah Entries:",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18)),
                      const SizedBox(height: 12),
                      ...provider.entries.map(
                        (entry) => Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Year ${entry.year}: ${entry.days} days"),
                              Text(
                                "RM ${(entry.days * 4).toStringAsFixed(2)}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                const SizedBox(height: 24),
                Divider(),

                // Total
                Text(
                  "Total to Pay: RM ${provider.total.toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildZakatPendapatanWidget() {
    return Center(
      child: Text(
        "Zakat Pendapatan Calculator UI here",
        style: TextStyle(fontSize: 18),
      ),
    );
  }

  Widget buildZakatSahamWidget() {
    return Consumer<ZakatSahamProvider>(
      builder: (context, provider, child) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Year',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextField(
                controller: provider.yearController,
                decoration: InputDecoration(
                  labelText: "e.g. 2023",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              const Text('Type of Investment',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () async {
                  await showShariahComplianceSheet(
                    context: context,
                    bankList: (provider.shariahCompliant),
                    onSelected: (type) {
                      provider.setShariahCompliance(type);
                    },
                  );
                },
                child: InputDecorator(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(provider.shariahCompliance.isEmpty
                          ? 'Select Type'
                          : provider.shariahCompliance),
                      Icon(Icons.arrow_drop_down),
                    ],
                  ),
                ),
              ),
              if (provider.errorText != null) ...[
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.error, color: Colors.red, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        provider.errorText!,
                        style: const TextStyle(color: Colors.red, fontSize: 13),
                        softWrap: true,
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 12),
              const Text('Name of Investment',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextField(
                controller: provider.nameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 12),
              const Text('Unit',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextField(
                controller: provider.unitController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              const Text('Price',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextField(
                controller: provider.priceController,
                decoration: InputDecoration(
                  labelText: "e.g. 100000",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              const Text('Dividend',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextField(
                controller: provider.dividendController,
                decoration: InputDecoration(
                  labelText: "e.g. 100000",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(
                height: 12,
              ),
              Buttons(
                iconData: Icons.add,
                text: "Add Entry",
                onTap: () {
                  provider.addEntry();
                },
                backgroundColor: AppColors.success,
                textColor: Colors.white,
                borderColor: AppColors.success,
                isFilled: true,
              ),
              Buttons(
                iconData: Icons.delete,
                text: "Clear Entry",
                onTap: () => provider.clearEntries(),
                backgroundColor: Colors.transparent,
                textColor: AppColors.success,
                borderColor: AppColors.success,
                isFilled: false,
              ),
              const SizedBox(height: 16),
              const Text('Trust Account Balance',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextField(
                controller: provider.trustBalanceController,
                decoration: InputDecoration(
                  labelText: "e.g. 100000",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              const Text('Related Cost (if any)',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextField(
                controller: provider.relatedCostController,
                decoration: InputDecoration(
                  labelText: "e.g. 100000",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              if (provider.entries.isNotEmpty)
                Column(
                  children: [
                    const Text("Entries:"),
                  ],
                ),
              ...provider.entries.map((e) => ListTile(
                    title: Text(
                      e.nameOfInvestment,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle:
                        Text("Year: ${e.year} | Type: ${e.shariahCompliance}"),
                    trailing: Text("RM ${Formatting.currency(e.totalValue)}"),
                  )),
              const Divider(),
              Text("Total Price: ${Formatting.currency(provider.totalValue)}"),
              Text("Final Amount: ${Formatting.currency(provider.finalValue)}"),
              provider.isZakatApplicable
                  ? Text(
                      "Zakat Payable (2.5%): ${Formatting.currency(provider.zakatPayable)}",
                      style: TextStyle(
                          color: Colors.green, fontWeight: FontWeight.bold))
                  : Text("Not eligible for Zakat (Below Nisab RM 29,740)",
                      style: TextStyle(
                          color: Colors.red, fontWeight: FontWeight.bold))
            ],
          ),
        );
      },
    );
  }

  Widget _buildZakatKWSPWidget() {
    return Consumer<ZakatKwspProvider>(
      builder: (context, provider, child) {
        final yearController = TextEditingController();
        final amountController = TextEditingController();

        return StatefulBuilder(builder: (context, setState) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Year',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                TextField(
                  controller: yearController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "e.g. 2023",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(height: 20),
                const Text('Amount of Cashout (RM)',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "e.g. 100000.00",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(height: 20),
                const Text('Nisab Amount',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                const Text('RM 29740.00', style: TextStyle(fontSize: 16)),
                const SizedBox(height: 20),
                const Text('Type of Cashout',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),

                // GestureDetector to show the custom bottom sheet
                GestureDetector(
                  onTap: () async {
                    await showTypeOfCashoutSelectionSheet(
                      context: context,
                      bankList: [
                        ...provider.zakatReasons,
                        ...provider.nonZakatReasons
                      ],
                      onSelected: (type) {
                        setState(() {
                          provider.setTypeOfCashout(type);
                        });
                      },
                    );
                  },
                  child: InputDecorator(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(provider.selectedType.isEmpty
                            ? 'Select Type'
                            : provider.selectedType),
                        Icon(Icons.arrow_drop_down),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Buttons(
                  iconData: Icons.add,
                  text: "Add Entry",
                  onTap: () {
                    final year = int.tryParse(yearController.text) ?? 0;
                    final amount =
                        double.tryParse(amountController.text) ?? 0.0;
                    provider.addEntry(year, amount);
                    yearController.clear();
                    amountController.clear();
                  },
                  backgroundColor: AppColors.success,
                  textColor: Colors.white,
                  borderColor: AppColors.success,
                  isFilled: true,
                ),
                Buttons(
                  iconData: Icons.delete,
                  text: "Clear Entry",
                  onTap: () => provider.clearAll(),
                  backgroundColor: Colors.transparent,
                  textColor: AppColors.success,
                  borderColor: AppColors.success,
                  isFilled: false,
                ),
                const SizedBox(height: 30),
                Divider(),

                // Total
                Text(
                  "Total to Pay: RM ${provider.totalZakat.toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                ...provider.entries.map((entry) => ListTile(
                      title: Text(
                          "${entry.year} - RM ${entry.amountOfCashout.toStringAsFixed(2)}"),
                      subtitle: Text("Reason: ${entry.typeOfCashout}"),
                    )),

                const SizedBox(height: 12),
              ],
            ),
          );
        });
      },
    );
  }

  Widget _buildZakatSimpananWidget() {
    return Consumer<ZakatSimpananProvider>(
      builder: (context, provider, child) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Year',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                TextField(
                  controller: provider.yearController,
                  decoration: InputDecoration(
                    labelText: "e.g. 2023",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 12),

                /// Custom bottom sheet picker
                const Text('Bank Name',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () async {
                    await showBankSelectionSheet(
                      context: context,
                      bankList: provider.malaysiaBankName,
                      onSelected: (bank) {
                        provider.setSelectedBank(bank);
                        print('This is the selected bank${bank}');
                      },
                    );
                  },
                  child: InputDecorator(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(provider.selectedBank.isEmpty
                            ? 'Select Bank'
                            : provider.selectedBank),
                        Icon(Icons.arrow_drop_down),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 12),
                const Text('Bank Amount (RM)',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                TextField(
                  controller: provider.amountController,
                  decoration: InputDecoration(
                    labelText: "e.g. 100000",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                ),
                const SizedBox(height: 16),
                Buttons(
                  iconData: Icons.add,
                  text: "Add Entry",
                  onTap: () {
                    final year =
                        int.tryParse(provider.yearController.text) ?? 0;
                    final amount =
                        double.tryParse(provider.amountController.text) ?? 0.0;

                    provider.addEntry(year, provider.selectedBank, amount);

                    provider.yearController.clear();
                    provider.amountController.clear();
                  },
                  backgroundColor: AppColors.success,
                  textColor: Colors.white,
                  borderColor: AppColors.success,
                  isFilled: true,
                ),

                Buttons(
                  iconData: Icons.delete,
                  text: "Clear Entry",
                  onTap: () => provider.clearEntries(),
                  backgroundColor: Colors.transparent,
                  textColor: AppColors.success,
                  borderColor: AppColors.success,
                  isFilled: false,
                ),
                const SizedBox(height: 16),
                if(provider.entries.isNotEmpty)
                Column(
                  children: [
                    Text(
                      'Entries:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ...provider.entries.map((e) => ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            e.bankName,
                          ),
                          Text(
                            '${Formatting.currency(e.bankAmount)}',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      subtitle: Text('${e.year}'),
                    )),
                const SizedBox(height: 16),
                Divider(),
                Text(
                  'Total Amount: ${Formatting.currency(provider.totalAmount)}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  provider.isZakatApplicable
                      ? 'Zakat Payable (2.5%): ${Formatting.currency(provider.zakatPayable)}'
                      : 'Not eligible for Zakat (Below Nisab RM 29,740)',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: provider.isZakatApplicable
                          ? Colors.green
                          : Colors.red),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

Future<void> showBankSelectionSheet({
  required BuildContext context,
  required List<String> bankList,
  required Function(String) onSelected,
}) {
  return showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    isScrollControlled: false,
    builder: (_) => CustomBottomSheet(
      title: 'Select a Bank',
      bankList: bankList,
      onSelected: onSelected,
    ),
  );
}

Future<void> showTypeOfCashoutSelectionSheet({
  required BuildContext context,
  required List<String> bankList,
  required Function(String) onSelected,
}) {
  return showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    isScrollControlled: false,
    builder: (_) => CustomBottomSheet(
      title: 'Select a Reason',
      bankList: bankList,
      onSelected: onSelected,
    ),
  );
}

Future<void> showShariahComplianceSheet({
  required BuildContext context,
  required List<String> bankList,
  required Function(String) onSelected,
}) {
  return showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    isScrollControlled: false,
    builder: (_) => CustomBottomSheet(
      title: 'Select a Type of Investment',
      bankList: bankList,
      onSelected: onSelected,
    ),
  );
}
