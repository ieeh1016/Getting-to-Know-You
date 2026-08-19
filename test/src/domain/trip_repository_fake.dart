import 'package:minyoung_pick/src/domain/alagagi_controller.dart';

/// 여행 저장 호출만 들여다보는 fake.
///
/// 나머지 member는 이 test에서 부르지 않으므로 `noSuchMethod`로 넘긴다.
class FakeTripRepository implements AlagagiDataRepository {
  FakeTripRepository({this.photos = const []});

  final List<TripPhoto> photos;

  int loadPhotoCallCount = 0;
  final List<String> deletedTripIds = [];
  final List<String> deletedItemIds = [];
  final List<String> deletedPhotoIds = [];

  @override
  Future<List<TripPhoto>> loadTripPhotos(String spaceId) async {
    loadPhotoCallCount += 1;
    return photos;
  }

  @override
  Future<void> saveTrip(String spaceId, Trip trip) async {}

  @override
  Future<void> saveTripItem(String spaceId, TripItem item) async {}

  @override
  Future<void> saveTripPhoto(String spaceId, TripPhoto photo) async {}

  @override
  Future<void> deleteTrip(String spaceId, String tripId) async {
    deletedTripIds.add(tripId);
  }

  @override
  Future<void> deleteTripItem(String spaceId, String itemId) async {
    deletedItemIds.add(itemId);
  }

  @override
  Future<void> deleteTripPhoto(String spaceId, String photoId) async {
    deletedPhotoIds.add(photoId);
  }

  /// controller가 session 준비 중에 부르는 저장들. 이 test에서는 무시한다.
  @override
  Future<void> saveDailyQuestionProgress(
    String spaceId,
    DailyQuestionProgress progress,
  ) async {}

  @override
  Future<void> saveSpacePersonalization(
    String spaceId,
    SpacePersonalization personalization,
  ) async {}

  /// 그 밖의 member는 이 test 경로에서 부르지 않는다. 불리면 바로 드러나야
  /// 하므로 조용히 넘기지 않고 그대로 던진다.
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
