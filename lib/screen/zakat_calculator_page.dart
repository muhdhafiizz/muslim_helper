import 'package:flutter/material.dart';
import 'package:hadith_reader/core/app_color.dart';
import 'package:hadith_reader/screen/zakat_calculator_detail_page.dart';

class ZakatCalculatorPage extends StatelessWidget {
  const ZakatCalculatorPage({super.key});

  @override
  Widget build(BuildContext context) {
    final zakatList = [
      'Income Zakat',
      'Gold Zakat',
      'Silver Zakat',
      'Business Zakat',
      'Investment Zakat',
      'Fidyah',
      'KWSP Zakat',
      'Savings Zakat',
    ];

    final zakatDescList = [
      'Zakat on your earnings or salary.',
      'Zakat on gold you own.',
      'Zakat on silver you own.',
      'Zakat on your business and its assets.',
      'Zakat on the value of your investments like stocks, shares, or mutual funds.',
      'A religious compensation for missed fasts or other religious duties.',
      'Zakat on your Employees Provident Fund (EPF) savings.',
      'Zakat on your savings in bank accounts or cash.',
    ];

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                      Icons.arrow_back,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    "Zakat Calculator",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 26,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // ListView inside Expanded to avoid unbounded height
              Expanded(
                child: ListView.builder(
                  itemCount: zakatList.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.secondary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading:
                            Icon(Icons.calculate, color: AppColors.primary),
                        title: Text(
                          zakatList[index],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Text(zakatDescList[index]),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ZakatCalculatorDetailPage(
                                title: zakatList[index],
                                description: zakatDescList[index],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
