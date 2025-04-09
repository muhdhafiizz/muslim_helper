import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class ProfileProvider extends ChangeNotifier {
  String _location = "Tap to get location";

  String get location => _location;

  Future<void> updateLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      _location = "Lat: ${position.latitude}, Lon: ${position.longitude}";
      notifyListeners();
    } catch (e) {
      _location = "Failed to get location";
      notifyListeners();
    }
  }
}
