class Masjid {
  final String id;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final String? photoReference;
  final double? rating;

  Masjid({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    this.photoReference,
    this.rating,
  });

  factory Masjid.fromJson(Map<String, dynamic> json) {
    return Masjid(
      id: json["place_id"],
      name: json["name"],
      address: json["vicinity"] ?? "Unknown Address",
      latitude: json["geometry"]["location"]["lat"],
      longitude: json["geometry"]["location"]["lng"],
      photoReference: json["photos"] != null ? json["photos"][0]["photo_reference"] : null,
      rating: json["rating"]?.toDouble(),
    );
  }
}
