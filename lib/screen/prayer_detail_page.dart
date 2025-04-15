import 'package:flutter/material.dart';
import 'package:hadith_reader/screen/masjid_locator_page.dart';
import 'package:hadith_reader/widgets/buttons.dart';
import 'package:provider/provider.dart';

import '../core/app_color.dart';
import '../model/prayer_time_model.dart';
import '../providers/home_provider.dart';
import '../widgets/shimmer_loading_widget.dart';

class PrayerDetailPage extends StatelessWidget {
  final PrayerTimings prayer;

  const PrayerDetailPage({super.key, required this.prayer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
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
                  "Prayer",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      color: AppColors.textPrimary),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            _buildPrayerCard(context)
          ],
        ),
      )),
    );
  }
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
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Consumer<HadithProvider>(
            builder: (context, provider, child) {
              if (provider.isLoading) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const ShimmerLoadingWidget(width: 180, height: 16),
                    const SizedBox(height: 5),
                    const ShimmerLoadingWidget(width: 180, height: 16),
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

              return SizedBox(
                height: MediaQuery.of(context).size.height * 0.7,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTimeCoutdown(context),
                    const SizedBox(height: 10),
                    _buildPrayerTimeRow("Imsak", timings.imsak, false),
                    _buildPrayerTimeRow("Fajr", timings.fajr, false),
                    _buildPrayerTimeRow("Sunrise", timings.sunrise, false),
                    _buildPrayerTimeRow("Dhuhr", timings.dhuhr, false),
                    _buildPrayerTimeRow("Asr", timings.asr, false),
                    _buildPrayerTimeRow("Maghrib", timings.maghrib, false),
                    _buildPrayerTimeRow("Isha", timings.isha, false),
                    const Spacer(),
                    _buildMasjidLocatorButton(context),
                    const Spacer(),
                    Center(child: Text(timings.method)),
                  ],
                ),
              );
            },
          ),
        )),
  );
}

Widget _buildPrayerTimeRow(String name, String? time, bool isLoading) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            isLoading
                ? const ShimmerLoadingWidget(width: 80, height: 16)
                : Text(name,
                    style: const TextStyle(
                        fontSize: 16, color: AppColors.textPrimary)),
            isLoading
                ? const ShimmerLoadingWidget(width: 50, height: 16)
                : Text(time ?? "--:--",
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary)),
          ],
        ),
        const Divider(
          color: AppColors.primary,
          thickness: 0.5,
          height: 8,
        ),
      ],
    ),
  );
}

Widget _buildTimeCoutdown(BuildContext context) {
  return Consumer<HadithProvider>(
    builder: (context, provider, child) {
      final timings = provider.prayerTimings!;

      return Center(
        child: Column(
          children: [
            Text(
              "${provider.state}, ${provider.country}",
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary),
            ),
            Text(
              timings.date,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
            Text(
              timings.hijriDate,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              "Next: ${provider.nextPrayer} in",
              style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary),
            ),
            Text(
              provider.timeRemaining != null
                  ? _formatDuration(provider.timeRemaining!)
                  : "Calculating...",
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      );
    },
  );
}

Widget _buildMasjidLocatorButton(BuildContext context) {
  return Buttons(
    iconData: Icons.map,
    text: "Locate nearest Masjid",
    onTap: () => Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MasjidLocatorPage(),
      ),
    ),
    backgroundColor: AppColors.success,
    textColor: Colors.white,
    borderColor: AppColors.success,
    isFilled: true,
  );
}

String _formatDuration(Duration duration) {
  int hours = duration.inHours;
  int minutes = duration.inMinutes.remainder(60);
  int seconds = duration.inSeconds.remainder(60);
  return "${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
}
