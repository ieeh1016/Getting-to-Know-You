import 'package:flutter/widgets.dart';

typedef KakaoMapFallbackBuilder =
    Widget Function(BuildContext context, String reason);

@immutable
class KakaoMapMarkerData {
  const KakaoMapMarkerData({
    required this.id,
    required this.title,
    required this.latitude,
    required this.longitude,
  });

  final String id;
  final String title;
  final double latitude;
  final double longitude;

  Map<String, Object?> toBridgeMap() {
    return {
      'id': id,
      'title': title,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
