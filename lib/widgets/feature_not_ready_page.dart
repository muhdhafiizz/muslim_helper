import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class FeatureNotReadyPage extends StatelessWidget {
  const FeatureNotReadyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Lottie.asset(
                'assets/lottie/analysis_options.json',
              ),
              const SizedBox(height: 12),
              const Text('Work is in Progress...'),
            ],
          ),
        ),
    );
  }
}