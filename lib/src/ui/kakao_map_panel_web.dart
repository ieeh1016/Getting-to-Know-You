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
}

class KakaoMapPanel extends StatefulWidget {
  const KakaoMapPanel({
    super.key,
    required this.markers,
    required this.fallbackBuilder,
    this.centerLatitude = 37.5665,
    this.centerLongitude = 126.9780,
    this.level = 6,
    this.appKey = const String.fromEnvironment('KAKAO_MAP_JS_KEY'),
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
    final appKey = widget.appKey.trim();
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

  Future<void> _renderMap() async {
    final appKey = widget.appKey.trim();
    if (appKey.isEmpty) {
      return;
    }

    try {
      await _ensureKakaoBridgeLoaded();
      final bridge = web.window.getProperty<JSObject?>(
        'jogeumssikKakaoMaps'.toJS,
      );
      if (bridge == null) {
        throw StateError('카카오 지도 브릿지를 찾을 수 없어요.');
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
      if (mounted && _error != null) {
        setState(() => _error = null);
      }
    } catch (error) {
      if (mounted) {
        setState(() => _error = '카카오 지도를 불러오지 못했어요.');
      }
    }
  }
}

Future<void> _ensureKakaoBridgeLoaded() {
  final bridge = web.window.getProperty<JSObject?>('jogeumssikKakaoMaps'.toJS);
  if (bridge != null) {
    return Future<void>.value();
  }
  return _kakaoBridgeLoadFuture ??= _loadKakaoBridgeScript();
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
      completer.completeError(StateError('Kakao map bridge did not register.'));
    } else {
      completer.complete();
    }
    script.removeEventListener('load', loadListener);
    script.removeEventListener('error', errorListener);
  }).toJS;

  errorListener = ((web.Event event) {
    completer.completeError(StateError('Kakao map bridge failed to load.'));
    script.removeEventListener('load', loadListener);
    script.removeEventListener('error', errorListener);
  }).toJS;

  script.addEventListener('load', loadListener);
  script.addEventListener('error', errorListener);
  web.document.head?.append(script);
  return completer.future;
}
