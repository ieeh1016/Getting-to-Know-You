import 'package:flutter/widgets.dart';

const bundledKakaoMapJsKey = 'c8da918613366a485c81dffd0add8be7';
const defaultKakaoMapJsKey = String.fromEnvironment(
  'KAKAO_MAP_JS_KEY',
  defaultValue: bundledKakaoMapJsKey,
);

String effectiveKakaoMapJsKey([String appKey = defaultKakaoMapJsKey]) {
  final trimmed = appKey.trim();
  return trimmed.isEmpty ? bundledKakaoMapJsKey : trimmed;
}

typedef KakaoMapFallbackBuilder =
    Widget Function(BuildContext context, String reason);

@immutable
class KakaoPlaceSearchResult {
  const KakaoPlaceSearchResult({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    this.roadAddress = '',
    this.categoryName = '',
    this.categoryGroupCode = '',
  });

  final String id;
  final String name;
  final String address;
  final String roadAddress;
  final double latitude;
  final double longitude;
  final String categoryName;
  final String categoryGroupCode;
}

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
