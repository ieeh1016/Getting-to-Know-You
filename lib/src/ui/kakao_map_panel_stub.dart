import 'package:flutter/widgets.dart';

import 'kakao_map_panel_base.dart';

class KakaoMapPanel extends StatelessWidget {
  const KakaoMapPanel({
    super.key,
    required this.markers,
    required this.fallbackBuilder,
    this.centerLatitude = 37.5665,
    this.centerLongitude = 126.9780,
    this.level = 6,
    this.appKey = defaultKakaoMapJsKey,
  });

  final List<KakaoMapMarkerData> markers;
  final KakaoMapFallbackBuilder fallbackBuilder;
  final double centerLatitude;
  final double centerLongitude;
  final int level;
  final String appKey;

  @override
  Widget build(BuildContext context) {
    return fallbackBuilder(context, '카카오 지도는 웹 빌드에서 표시돼요.');
  }
}

Future<List<KakaoPlaceSearchResult>> searchKakaoPlaces(
  String keyword, {
  String appKey = defaultKakaoMapJsKey,
}) async {
  return const [];
}
