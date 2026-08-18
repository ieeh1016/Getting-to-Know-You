import 'trip_photo_picker_stub.dart'
    if (dart.library.html) 'trip_photo_picker_web.dart';

/// 갤러리에서 고른 사진 한 장.
class PickedTripPhoto {
  const PickedTripPhoto({required this.dataUrl});

  /// `data:image/jpeg;base64,...` 형태로 이미 줄여둔 이미지.
  final String dataUrl;
}

/// 단말기 갤러리를 열어 사진 한 장을 고른다.
///
/// 고르지 않고 닫으면 null을 돌려준다. 웹이 아닌 환경에서는 지원하지 않는다.
abstract class TripPhotoPicker {
  Future<PickedTripPhoto?> pickImage();

  bool get isSupported;
}

TripPhotoPicker createDefaultTripPhotoPicker() => createTripPhotoPicker();
