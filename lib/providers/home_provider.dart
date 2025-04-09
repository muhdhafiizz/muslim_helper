import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hadith_reader/model/prayer_time_model.dart';
import 'package:intl/intl.dart';
import '../model/hadith_model.dart';
import '../service/hadith_service.dart';
import '../service/prayer_time_service.dart';
import 'profile_provider.dart';

class HadithProvider extends ChangeNotifier {
  List<HadithModel> hadiths = [];
  PrayerTimings? prayerTimings;
  bool isLoading = false;
  String? nextPrayer;
  Duration? timeRemaining;
  Timer? _timer;
  String? state;
  String? country;

  Future<void> fetchHadiths() async {
    isLoading = true;
    notifyListeners();

    hadiths = await HadithService.fetchHadiths();

    isLoading = false;
    notifyListeners();
  }

  Future<void> fetchPrayerTimings({ProfileProvider? profileProvider}) async {
    try {
      isLoading = true;
      notifyListeners();

      String todayDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
      String? latitude;
      String? longitude;

      if (profileProvider != null &&
          profileProvider.location.contains("Lat:")) {
        List<String> latLon = profileProvider.location
            .replaceAll("Lat: ", "")
            .replaceAll("Lon: ", "")
            .split(", ");

        if (latLon.length >= 2) {
          latitude = latLon[0];
          longitude = latLon[1];
        }
      }

      if (latitude == null || longitude == null) {
        Position position = await determinePosition();
        latitude = position.latitude.toString();
        longitude = position.longitude.toString();
      }

      prayerTimings = await PrayerTimingsService.getPrayerTimings(
        todayDate,
        latitude,
        longitude,
      );

      List<Placemark> placemarks = await placemarkFromCoordinates(
        double.parse(latitude),
        double.parse(longitude),
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        state = place.locality ?? "Unknown";
        country = place.country ?? "Unknown";
      }

      _startCountdown();
    } catch (e) {
      debugPrint("Error fetching prayer timings: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void _startCountdown() {
    if (prayerTimings == null) {
      debugPrint("Error: prayerTimings is null");
      return;
    }

    final now = DateTime.now();
    final Map<String, String> prayerTimes = {
      "Fajr": prayerTimings!.fajr,
      "Dhuhr": prayerTimings!.dhuhr,
      "Asr": prayerTimings!.asr,
      "Maghrib": prayerTimings!.maghrib,
      "Isha": prayerTimings!.isha,
    };

    DateTime? nextPrayerTime;
    String? nextPrayerName;

    prayerTimes.forEach((name, time) {
      DateTime prayerDateTime = _parsePrayerTime(time);
      if (prayerDateTime.isAfter(now) &&
          (nextPrayerTime == null ||
              prayerDateTime.isBefore(nextPrayerTime!))) {
        nextPrayerTime = prayerDateTime;
        nextPrayerName = name;
      }
    });

    if (nextPrayerTime == null) {
      debugPrint(
          "All today's prayers have passed. Looking for next day's Fajr...");

      nextPrayerName = "Fajr";
      nextPrayerTime =
          _parsePrayerTime(prayerTimings!.fajr).add(const Duration(days: 1));
    }

    if (nextPrayerTime != null) {
      debugPrint("Next prayer: $nextPrayerName at $nextPrayerTime");
      nextPrayer = nextPrayerName;
      timeRemaining = nextPrayerTime!.difference(now);

      _timer?.cancel();
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        final remaining = nextPrayerTime!.difference(DateTime.now());
        if (remaining.isNegative) {
          timer.cancel();
          fetchPrayerTimings();
        } else {
          timeRemaining = remaining;
          notifyListeners();
        }
      });

      notifyListeners();
    }
  }

  DateTime _parsePrayerTime(String time) {
    final now = DateTime.now();
    final parts = time.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    return DateTime(now.year, now.month, now.day, hour, minute);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  static Future<Position> determinePosition() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception("Location permissions are permanently denied.");
    }

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }
}
