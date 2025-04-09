import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../service/qibla_finder_service.dart';


class QiblaProvider with ChangeNotifier {
  String? _qiblaImageUrl;
  bool _isLoading = false;
  String? _errorMessage;

  String? get qiblaImageUrl => _qiblaImageUrl;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  final QiblaService _qiblaService = QiblaService();

  Future<void> fetchQiblaDirection() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      _qiblaImageUrl =
          _qiblaService.getQiblaCompassUrl(position.latitude, position.longitude);
    } catch (e) {
      _errorMessage = "Failed to get location: $e";
    }

    _isLoading = false;
    notifyListeners();
  }
}
