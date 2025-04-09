class QiblaModel {
  final String imageUrl;

  QiblaModel({required this.imageUrl});

  factory QiblaModel.fromJson(Map<String, dynamic> json) {
    return QiblaModel(imageUrl: json['data']['image']);
  }
}
