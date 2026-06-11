import 'dart:async';
import 'dart:convert';
import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import 'dart:ui_web' as ui_web;

import 'package:flutter/widgets.dart';
import 'package:web/web.dart' as web;

import 'kakao_map_panel_base.dart';

Future<void>? _kakaoBridgeLoadFuture;

extension type _KakaoMapBridge(JSObject _) implements JSObject {
  external JSPromise<JSAny?> renderMapFromJson(JSString optionsJson);
  external JSPromise<JSString> searchPlacesFromJson(JSString optionsJson);
}

class KakaoMapPanel extends StatefulWidget {
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
  State<KakaoMapPanel> createState() => _KakaoMapPanelState();
}

class _KakaoMapPanelState extends State<KakaoMapPanel> {
  late final String _elementId;
  late final String _viewType;
  String? _error;
  int _renderGeneration = 0;

  @override
  void initState() {
    super.initState();
    final unique = DateTime.now().microsecondsSinceEpoch;
    _elementId = 'jogeumssik-kakao-map-$unique';
    _viewType = 'jogeumssik-kakao-map-view-$unique';
    _registerViewFactory();
    unawaited(_renderMap());
  }

  @override
  void didUpdateWidget(covariant KakaoMapPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.appKey != widget.appKey ||
        oldWidget.centerLatitude != widget.centerLatitude ||
        oldWidget.centerLongitude != widget.centerLongitude ||
        oldWidget.level != widget.level ||
        oldWidget.markers != widget.markers) {
      unawaited(_renderMap());
    }
  }

  @override
  Widget build(BuildContext context) {
    final appKey = effectiveKakaoMapJsKey(widget.appKey);
    if (appKey.isEmpty) {
      return widget.fallbackBuilder(context, 'KAKAO_MAP_JS_KEY가 비어 있어요.');
    }
    if (_error != null) {
      return widget.fallbackBuilder(context, _error!);
    }
    return HtmlElementView(viewType: _viewType);
  }

  void _registerViewFactory() {
    ui_web.platformViewRegistry.registerViewFactory(_viewType, (int viewId) {
      final element = web.HTMLDivElement()
        ..id = _elementId
        ..style.width = '100%'
        ..style.height = '100%'
        ..style.border = '0'
        ..style.margin = '0'
        ..style.padding = '0'
        ..style.overflow = 'hidden';
      return element;
    });
  }

  Future<void> _renderMap({bool allowAutoRetry = true}) async {
    final generation = ++_renderGeneration;
    final appKey = effectiveKakaoMapJsKey(widget.appKey);
    if (appKey.isEmpty) {
      return;
    }

    try {
      await _ensureKakaoBridgeLoaded();
      final bridge = web.window.getProperty<JSObject?>(
        'jogeumssikKakaoMaps'.toJS,
      );
      if (bridge == null) {
        throw StateError(
          '지도 연결 객체를 찾을 수 없어요. web/kakao_maps_bridge.js 등록 여부를 확인해주세요.',
        );
      }
      final optionsJson = jsonEncode({
        'elementId': _elementId,
        'appKey': appKey,
        'centerLatitude': widget.centerLatitude,
        'centerLongitude': widget.centerLongitude,
        'level': widget.level,
        'markers': [for (final marker in widget.markers) marker.toBridgeMap()],
      });
      await _KakaoMapBridge(bridge).renderMapFromJson(optionsJson.toJS).toDart;
      if (!mounted || generation != _renderGeneration) {
        return;
      }
      if (_error != null) {
        setState(() => _error = null);
      }
    } catch (error) {
      if (!mounted || generation != _renderGeneration) {
        return;
      }
      if (allowAutoRetry) {
        await Future<void>.delayed(const Duration(milliseconds: 450));
        if (!mounted || generation != _renderGeneration) {
          return;
        }
        await _renderMap(allowAutoRetry: false);
        return;
      }
      if (mounted) {
        setState(() => _error = _kakaoUiMessage('지도 오류', error));
      }
    }
  }
}

Future<void> _ensureKakaoBridgeLoaded() {
  final bridge = web.window.getProperty<JSObject?>('jogeumssikKakaoMaps'.toJS);
  if (bridge != null) {
    return Future<void>.value();
  }
  final pendingLoad = _kakaoBridgeLoadFuture;
  if (pendingLoad != null) {
    return pendingLoad;
  }

  late final Future<void> loadFuture;
  loadFuture = _loadKakaoBridgeScript().whenComplete(() {
    if (identical(_kakaoBridgeLoadFuture, loadFuture)) {
      _kakaoBridgeLoadFuture = null;
    }
  });
  _kakaoBridgeLoadFuture = loadFuture;
  return loadFuture;
}

Future<void> _loadKakaoBridgeScript() {
  final completer = Completer<void>();
  final script = web.HTMLScriptElement()
    ..src = 'kakao_maps_bridge.js'
    ..async = true;

  late JSFunction loadListener;
  late JSFunction errorListener;

  loadListener = ((web.Event event) {
    final bridge = web.window.getProperty<JSObject?>(
      'jogeumssikKakaoMaps'.toJS,
    );
    if (bridge == null) {
      completer.completeError(
        StateError(
          '지도 연결 스크립트가 등록되지 않았어요. web/kakao_maps_bridge.js 경로를 확인해주세요.',
        ),
      );
    } else {
      completer.complete();
    }
    script.removeEventListener('load', loadListener);
    script.removeEventListener('error', errorListener);
  }).toJS;

  errorListener = ((web.Event event) {
    completer.completeError(
      StateError('지도 연결 스크립트 로드 실패. 배포 경로 또는 정적 파일 설정을 확인해주세요.'),
    );
    script.removeEventListener('load', loadListener);
    script.removeEventListener('error', errorListener);
  }).toJS;

  script.addEventListener('load', loadListener);
  script.addEventListener('error', errorListener);
  web.document.head?.append(script);
  return completer.future;
}

Future<List<KakaoPlaceSearchResult>> searchKakaoPlaces(
  String keyword, {
  String appKey = defaultKakaoMapJsKey,
}) async {
  final trimmed = keyword.trim();
  if (trimmed.length < 2) {
    return const [];
  }

  try {
    await _ensureKakaoBridgeLoaded();
    final bridge = web.window.getProperty<JSObject?>(
      'jogeumssikKakaoMaps'.toJS,
    );
    if (bridge == null) {
      throw StateError(
        '지도 연결 객체를 찾을 수 없어요. web/kakao_maps_bridge.js 등록 여부를 확인해주세요.',
      );
    }
    final optionsJson = jsonEncode({
      'appKey': effectiveKakaoMapJsKey(appKey),
      'keyword': trimmed,
    });
    final resultJson = await _KakaoMapBridge(
      bridge,
    ).searchPlacesFromJson(optionsJson.toJS).toDart;
    final decoded = jsonDecode(resultJson.toDart);
    if (decoded is! List) {
      throw StateError('장소 검색 응답 형식이 올바르지 않아요.');
    }
    return decoded
        .whereType<Map<String, Object?>>()
        .map(_placeSearchResultFromMap)
        .whereType<KakaoPlaceSearchResult>()
        .toList(growable: false);
  } catch (error, stackTrace) {
    Error.throwWithStackTrace(
      StateError(_kakaoUiMessage('장소 검색 오류', error)),
      stackTrace,
    );
  }
}

KakaoPlaceSearchResult? _placeSearchResultFromMap(Map<String, Object?> data) {
  final id = data['id']?.toString() ?? '';
  final name = data['name']?.toString() ?? '';
  final latitude = _readDouble(data['latitude']);
  final longitude = _readDouble(data['longitude']);
  if (id.isEmpty || name.isEmpty || latitude == null || longitude == null) {
    return null;
  }
  return KakaoPlaceSearchResult(
    id: id,
    name: name,
    address: data['address']?.toString() ?? '',
    roadAddress: data['roadAddress']?.toString() ?? '',
    latitude: latitude,
    longitude: longitude,
    categoryName: data['categoryName']?.toString() ?? '',
    categoryGroupCode: data['categoryGroupCode']?.toString() ?? '',
  );
}

double? _readDouble(Object? value) {
  if (value is num) {
    return value.toDouble();
  }
  if (value is String) {
    return double.tryParse(value);
  }
  return null;
}

String _kakaoUiMessage(String title, Object error) {
  final detail = _kakaoErrorDetail(error);
  return detail.isEmpty ? title : '$title: $detail';
}

String _kakaoErrorDetail(Object error) {
  var message = error.toString().trim();
  for (final prefix in const [
    'Bad state: ',
    'Exception: ',
    'Error: ',
    'JavaScriptError: ',
    'JogeumssikKakaoMapError: ',
  ]) {
    if (message.startsWith(prefix)) {
      message = message.substring(prefix.length).trim();
    }
  }
  message = message
      .replaceAll('Kakao Developers', '개발자 콘솔')
      .replaceAll('Kakao Maps SDK', '지도 SDK')
      .replaceAll('Kakao Maps', '지도')
      .replaceAll('Kakao Places', '장소 검색')
      .replaceAll('Kakao 장소 검색', '장소 검색')
      .replaceAll('Kakao 도메인', '지도 도메인')
      .replaceAll('카카오 장소 검색', '장소 검색')
      .replaceAll('카카오 지도', '지도');
  return message.isEmpty ? '알 수 없는 오류' : message;
}
