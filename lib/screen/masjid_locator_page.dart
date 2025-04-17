import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:hadith_reader/widgets/shimmer_loading_widget.dart';
import 'package:provider/provider.dart';
import '../core/app_color.dart';
import '../core/utils/location_helper.dart' show LocationHelper;
import '../providers/masjid_details_provider.dart';
import '../../core/utils/api_constants.dart';

class MasjidLocatorPage extends StatelessWidget {
  const MasjidLocatorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8),
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
                    "Masjid Near Me",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Consumer<MasjidProvider>(
                builder: (context, masjidProvider, child) {
                  if (masjidProvider.isLoading) {
                    return Expanded(
                      child: _buildLoadingShimmer(),
                    );
                  } else if (masjidProvider.errorMessage.isNotEmpty) {
                    return Expanded(
                      child: Center(
                        child: Text(masjidProvider.errorMessage),
                      ),
                    );
                  } else {
                    return Expanded(
                      child: RefreshIndicator(
                        onRefresh: () =>
                            Provider.of<MasjidProvider>(context, listen: false)
                                .fetchMasjids(),
                        child: ListView.builder(
                          itemCount: masjidProvider.masjids.length,
                          itemBuilder: (context, index) {
                            final masjid = masjidProvider.masjids[index];
                            double? distanceKm;

                            if (masjidProvider.currentLat != null &&
                                masjidProvider.currentLng != null) {
                              distanceKm = LocationHelper.calculateDistance(
                                masjidProvider.currentLat!,
                                masjidProvider.currentLng!,
                                masjid.latitude,
                                masjid.longitude,
                              );
                            }

                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                onTap: () => Provider.of<MasjidProvider>(
                                        context,
                                        listen: false)
                                    .openMap(masjid.latitude, masjid.longitude),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (masjid.photoReference != null)
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.network(
                                          "https://maps.googleapis.com/maps/api/place/photo?maxwidth=200&photoreference=${masjid.photoReference}&key=${ApiConstants.apiKey}",
                                          width: double.infinity,
                                          height: 120,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    else
                                      const Icon(Icons.image_not_supported,
                                          size: 80),
                                    const SizedBox(height: 8),
                                    Text(
                                      masjid.name,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      masjid.address,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Text(masjid.rating.toString()),
                                            const SizedBox(width: 5),
                                            RatingBarIndicator(
                                              itemBuilder: (context, index) =>
                                                  const Icon(
                                                Icons.star,
                                                color: Colors.amber,
                                              ),
                                              rating: masjid.rating ?? 0.0,
                                              itemCount: 5,
                                              itemSize: 20.0,
                                              direction: Axis.horizontal,
                                            ),
                                          ],
                                        ),
                                        if (distanceKm != null)
                                          Text(
                                            "${distanceKm.toStringAsFixed(2)} km away",
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: AppColors.textPrimary,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            textAlign: TextAlign.end,
                                          ),
                                      ],
                                    ),
                                    const Divider(color: AppColors.primary),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingShimmer() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        ShimmerLoadingWidget(width: 500, height: 100),
        SizedBox(height: 20),
        ShimmerLoadingWidget(width: 250, height: 20),
        SizedBox(height: 5),
        ShimmerLoadingWidget(width: 150, height: 12),
        SizedBox(height: 5),
        ShimmerLoadingWidget(width: 70, height: 12),
        Divider(
          color: AppColors.primary,
        )
      ],
    );
  }
}
