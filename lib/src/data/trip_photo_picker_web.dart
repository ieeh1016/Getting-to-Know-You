// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use

import 'dart:async';
import 'dart:html' as html;

import 'trip_photo_picker.dart';

TripPhotoPicker createTripPhotoPicker() => BrowserTripPhotoPicker();

/// 브라우저 file input으로 갤러리를 연다.
///
/// 모바일 브라우저에서는 `accept="image/*"`가 갤러리/카메라 선택으로 이어진다.
/// 원본을 그대로 저장하면 Firestore 문서 한도를 넘기므로 canvas로 긴 변을
/// [_maxEdge]까지 줄이고, 목표 용량에 들어올 때까지 품질을 낮춰 다시 굽는다.
class BrowserTripPhotoPicker implements TripPhotoPicker {
  static const int _maxEdge = 1280;
  static const int _targetLength = 600000;
  static const List<double> _qualitySteps = [0.82, 0.7, 0.58, 0.45, 0.35];

  @override
  bool get isSupported => true;

  @override
  Future<PickedTripPhoto?> pickImage() async {
    final input = html.FileUploadInputElement()
      ..accept = 'image/*'
      ..multiple = false;
    input.click();

    await input.onChange.first;
    final files = input.files;
    if (files == null || files.isEmpty) {
      return null;
    }

    final dataUrl = await _readAsDataUrl(files.first);
    if (dataUrl == null) {
      return null;
    }
    final resized = await _downscale(dataUrl);
    return PickedTripPhoto(dataUrl: resized ?? dataUrl);
  }

  Future<String?> _readAsDataUrl(html.File file) async {
    final reader = html.FileReader()..readAsDataUrl(file);
    await reader.onLoadEnd.first;
    final result = reader.result;
    return result is String ? result : null;
  }

  Future<String?> _downscale(String dataUrl) async {
    final image = html.ImageElement();
    final loaded = Completer<bool>();
    image.onLoad.listen((_) {
      if (!loaded.isCompleted) {
        loaded.complete(true);
      }
    });
    image.onError.listen((_) {
      if (!loaded.isCompleted) {
        loaded.complete(false);
      }
    });
    image.src = dataUrl;
    if (!await loaded.future) {
      return null;
    }

    final width = image.naturalWidth;
    final height = image.naturalHeight;
    if (width <= 0 || height <= 0) {
      return null;
    }
    final longestEdge = width > height ? width : height;
    final scale = longestEdge > _maxEdge ? _maxEdge / longestEdge : 1.0;
    final targetWidth = (width * scale).round();
    final targetHeight = (height * scale).round();

    final canvas = html.CanvasElement(
      width: targetWidth,
      height: targetHeight,
    );
    canvas.context2D.drawImageScaled(
      image,
      0,
      0,
      targetWidth.toDouble(),
      targetHeight.toDouble(),
    );

    for (final quality in _qualitySteps) {
      final encoded = canvas.toDataUrl('image/jpeg', quality);
      if (encoded.length <= _targetLength) {
        return encoded;
      }
    }
    // 마지막 단계까지 줄여도 크면 그대로 돌려주고 도메인 한도에서 걸러낸다.
    return canvas.toDataUrl('image/jpeg', _qualitySteps.last);
  }
}
