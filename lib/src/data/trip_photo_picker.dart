import 'trip_photo_picker_stub.dart'
    if (dart.library.html) 'trip_photo_picker_web.dart';

/// 갤러리에서 고른 사진 한 장.
class PickedTripPhoto {
  const PickedTripPhoto({required this.dataUrl});

  /// `data:image/jpeg;base64,...` 형태로 이미 줄여둔 이미지.
  final String dataUrl;
}

/// 여행 사진은 한 번에 몇 장씩 올린다. 한 장씩만 받으면 갤러리를
/// 열 번 여닫게 된다. Firestore 문서가 사진마다 하나씩 생기므로
/// 한 번에 담는 장 수는 [maxTripPhotoPickCount]로 묶어둔다.
const int maxTripPhotoPickCount = 10;

/// 단말기 갤러리를 열어 사진을 고른다.
///
/// 고르지 않고 닫으면 빈 목록을 돌려준다. 웹이 아닌 환경에서는 지원하지 않는다.
abstract class TripPhotoPicker {
  Future<List<PickedTripPhoto>> pickImages({
    int max = maxTripPhotoPickCount,
  });

  bool get isSupported;
}

TripPhotoPicker createDefaultTripPhotoPicker() => createTripPhotoPicker();
