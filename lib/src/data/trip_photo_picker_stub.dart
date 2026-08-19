import 'trip_photo_picker.dart';

TripPhotoPicker createTripPhotoPicker() => const UnsupportedTripPhotoPicker();

/// 갤러리 접근이 없는 환경용. 화면은 이 상태를 안내로 바꿔 보여준다.
class UnsupportedTripPhotoPicker implements TripPhotoPicker {
  const UnsupportedTripPhotoPicker();

  @override
  bool get isSupported => false;

  @override
  Future<List<PickedTripPhoto>> pickImages({
    int max = maxTripPhotoPickCount,
  }) async => const [];
}
