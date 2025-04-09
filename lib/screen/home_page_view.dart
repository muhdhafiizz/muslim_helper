import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hadith_reader/core/app_color.dart';
import 'package:hadith_reader/screen/hadith_detail_page.dart';
import 'package:hadith_reader/screen/prayer_detail_page.dart';
import 'package:provider/provider.dart';
import '../providers/home_provider.dart';
import '../widgets/shimmer_loading_widget.dart';
import 'search_page_view.dart';

class HomePageView extends StatelessWidget {
  const HomePageView({super.key});

  Future<void> _refreshStockList(BuildContext context) async {
    final hadithProvider = Provider.of<HadithProvider>(context, listen: false);
    await hadithProvider.fetchHadiths();
  }

  @override
  Widget build(BuildContext context) {
      final provider = context.read<HadithProvider>();

    Future.microtask(() {
      Provider.of<HadithProvider>(context, listen: false).fetchHadiths();
      Provider.of<HadithProvider>(context, listen: false).fetchPrayerTimings();
    });

    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTopNavBar(context),
            const SizedBox(height: 10),
            Expanded(
              child: RefreshIndicator(
                backgroundColor: Colors.black,
                color: Colors.green,
                onRefresh: () => _refreshStockList(context),
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    _buildTimeCoutdown(context),
                    GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PrayerDetailPage(prayer: provider.prayerTimings!,),
                            ),
                          );
                        },
                        child: _buildTitleSection("Prayer")),
                    _buildPrayerCard(context),
                    const SizedBox(height: 20),
                    GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SearchPageView(),
                            ),
                          );
                        },
                        child: _buildTitleSection("Hadith")),
                    _buildHadithGridView(),
                  ],
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }
}

Widget _buildTopNavBar(BuildContext context) {
  final user = FirebaseAuth.instance.currentUser;

  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Assalamualaikum,",
              style: TextStyle(color: AppColors.textPrimary)),
          Text(
            user?.displayName ?? 'User',
            style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary),
          ),
        ],
      ),
    ],
  );
}

Widget _buildTitleSection(String title) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        title,
        style: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary),
      ),
      const Icon(
        Icons.arrow_forward,
        color: AppColors.primary,
      )
    ],
  );
}

Widget _buildHadithGridView() {
  return Consumer<HadithProvider>(
    builder: (context, provider, child) {
      if (provider.isLoading) {
        return SizedBox(
          height: 150,
          child: GridView.builder(
            scrollDirection: Axis.horizontal,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              childAspectRatio: 0.6,
            ),
            itemCount: 3,
            itemBuilder: (context, index) {
              return Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShimmerLoadingWidget(width: 150, height: 10),
                      SizedBox(height: 5),
                      ShimmerLoadingWidget(width: 180, height: 10),
                      SizedBox(height: 20),
                      ShimmerLoadingWidget(width: 150, height: 10),
                      SizedBox(height: 5),
                      ShimmerLoadingWidget(width: 180, height: 10),
                      Spacer(),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: ShimmerLoadingWidget(width: 80, height: 10),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      }

      if (provider.hadiths.isEmpty) {
        return const Center(child: Text("No Hadiths found"));
      }

      return SizedBox(
        height: 150,
        child: GridView.builder(
          scrollDirection: Axis.horizontal,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            childAspectRatio: 0.6,
          ),
          itemCount: provider.hadiths.length > 5 ? 6 : provider.hadiths.length,
          itemBuilder: (context, index) {
            if (index < 5) {
              final hadith = provider.hadiths[index];
              return Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              HadithDetailPage(hadith: hadith),
                        ),
                      );
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          hadith.headingEnglish,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          hadith.hadithEnglish,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const Spacer(),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Text(
                            hadith.status,
                            style: const TextStyle(color: AppColors.accent),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            } else {
              return SizedBox(
                child: InkWell(
                  onTap: () {
                    debugPrint("Navigating to full watchlist");
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SearchPageView(),
                      ),
                    );
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "View All",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          Icon(Icons.arrow_forward)
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }
          },
        ),
      );
    },
  );
}

Widget _buildPrayerCard(BuildContext context) {
  final provider = context.read<HadithProvider>();

  return SizedBox(
    child: GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PrayerDetailPage(
              prayer: provider.prayerTimings!,
            ),
          ),
        );
      },
      child: Card(
          color: AppColors.primary,
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Consumer<HadithProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // const ShimmerLoadingWidget(width: 180, height: 16),
                      // const SizedBox(height: 5),
                      // const ShimmerLoadingWidget(width: 100, height: 16),
                      // const SizedBox(height: 5),
                      // const ShimmerLoadingWidget(width: 150, height: 16),
                      // const SizedBox(height: 10),
                      // const ShimmerLoadingWidget(width: 100, height: 16),
                      // const SizedBox(height: 10),
                      // const ShimmerLoadingWidget(width: 180, height: 20),
                      const SizedBox(height: 20),
                      _buildPrayerTimeRow("Fajr", null, true),
                      _buildPrayerTimeRow("Dhuhr", null, true),
                      _buildPrayerTimeRow("Asr", null, true),
                      _buildPrayerTimeRow("Maghrib", null, true),
                      _buildPrayerTimeRow("Isha", null, true),
                    ],
                  );
                }

                if (provider.prayerTimings == null) {
                  return const Center(
                      child: Text("Unable to load prayer timings."));
                }

                final timings = provider.prayerTimings!;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // _buildTimeCoutdown(context),
                    const SizedBox(height: 10),
                    _buildPrayerTimeRow("Fajr", timings.fajr, false),
                    _buildPrayerTimeRow("Dhuhr", timings.dhuhr, false),
                    _buildPrayerTimeRow("Asr", timings.asr, false),
                    _buildPrayerTimeRow("Maghrib", timings.maghrib, false),
                    _buildPrayerTimeRow("Isha", timings.isha, false),
                  ],
                );
              },
            ),
          )),
    ),
  );
}

Widget _buildPrayerTimeRow(String name, String? time, bool isLoading) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        isLoading
            ? const ShimmerLoadingWidget(width: 80, height: 16)
            : Text(name,
                style: const TextStyle(
                    fontSize: 16, color: AppColors.textTertiaty)),
        isLoading
            ? const ShimmerLoadingWidget(width: 50, height: 16)
            : Text(time ?? "--:--",
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textTertiaty)),
      ],
    ),
  );
}

Widget _buildTimeCoutdown(BuildContext context) {
  return Container(
    padding: const EdgeInsets.all(20),
    margin: const EdgeInsets.symmetric(vertical: 10),
    decoration: BoxDecoration(
      color: AppColors.textTertiaty,
      borderRadius: BorderRadius.circular(10),
    ),
    child: Consumer<HadithProvider>(
      builder: (context, provider, child) {
        final timings = provider.prayerTimings;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            provider.state != null && provider.country != null
                ? Text(
                    "${provider.state}, ${provider.country}",
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary),
                  )
                : ShimmerLoadingWidget(width: 100, height: 20),
            timings?.date != null
                ? Text(
                    timings!.date,
                    style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary),
                  )
                : ShimmerLoadingWidget(width: 80, height: 15),
            timings?.hijriDate != null
                ? Text(
                    timings!.hijriDate,
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary),
                  )
                : ShimmerLoadingWidget(width: 90, height: 15),
            const SizedBox(height: 10),
            provider.nextPrayer != null
                ? Text(
                    "Next: ${provider.nextPrayer} in",
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary),
                  )
                : ShimmerLoadingWidget(width: 120, height: 25),
            provider.timeRemaining != null
                ? Text(
                    _formatDuration(provider.timeRemaining!),
                    style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary),
                  )
                : ShimmerLoadingWidget(width: 120, height: 25),
          ],
        );
      },
    ),
  );
}

String _formatDuration(Duration duration) {
  int hours = duration.inHours;
  int minutes = duration.inMinutes.remainder(60);
  int seconds = duration.inSeconds.remainder(60);
  return "${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
}
