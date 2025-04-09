import 'package:flutter/material.dart';
import 'package:hadith_reader/core/app_color.dart';
import '../model/hadith_model.dart';

class HadithDetailPage extends StatelessWidget {
  final HadithModel hadith;

  const HadithDetailPage({super.key, required this.hadith});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(Icons.arrow_back, color: AppColors.primary,)),
                  const SizedBox(width: 10),
                  const Text(
                    "Details",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30, color: AppColors.textPrimary,),
                  ),
                ],
              ),
              _buildHadithDetailsBody(hadith),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildHadithDetailsBody(HadithModel hadith) {
  return Expanded(
    child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: ListView(
        children: [
          Text(
            "Status: ${hadith.status}",
            style: const TextStyle(fontSize: 16, color: AppColors.accent,),
            textAlign: TextAlign.end,
          ),
          const SizedBox(height: 10),
          Text(
            hadith.headingEnglish,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primary),
          ),
          const SizedBox(height: 10),
          Text(
            hadith.englishNarrator,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 10),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                hadith.hadithArabic,
                style: const TextStyle(
                  fontSize: 20,
                ), 
                textAlign: TextAlign.right,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "English: \n\n${hadith.hadithEnglish}",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          
        ],
      ),
    ),
  );
}
