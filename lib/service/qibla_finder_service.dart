

class QiblaService {
  String getQiblaCompassUrl(double latitude, double longitude) {
    return 'https://api.aladhan.com/v1/qibla/$latitude/$longitude/compass';
  }
}

