import 'package:flutter/material.dart';
import 'package:hadith_reader/widgets/shimmer_loading_widget.dart';
import 'package:provider/provider.dart';
import '../providers/qibla_finder_provider.dart';
import '../core/app_color.dart';

class QiblaFinderPage extends StatelessWidget {
  const QiblaFinderPage({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<QiblaProvider>().fetchQiblaDirection();
    });

    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTopNavBar(),
              const SizedBox(height: 20),
              Expanded(
                child: Consumer<QiblaProvider>(
                  builder: (context, qiblaProvider, child) {
                    if (qiblaProvider.isLoading) {
                      return const Center(
                          child: ShimmerLoadingWidget(
                        width: 250,
                        height: 150,
                      ));
                    } else if (qiblaProvider.errorMessage != null) {
                      return Center(
                        child: Text(qiblaProvider.errorMessage!,
                            style: const TextStyle(color: Colors.red)),
                      );
                    } else if (qiblaProvider.qiblaImageUrl != null) {
                      return RefreshIndicator(
                        onRefresh: () => qiblaProvider.fetchQiblaDirection(),
                        child: ListView(
                          physics:
                              const AlwaysScrollableScrollPhysics(),
                          children: [
                            Center(
                              child:
                                  Image.network(qiblaProvider.qiblaImageUrl!),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return const Center(
                          child: Text("Unable to get Qibla direction."));
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopNavBar() {
    return const Text(
      "Qibla",
      style: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary),
      textAlign: TextAlign.start,
    );
  }
}
