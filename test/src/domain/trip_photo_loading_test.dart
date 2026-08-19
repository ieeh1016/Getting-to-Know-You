import 'package:flutter_test/flutter_test.dart';
import 'package:minyoung_pick/src/domain/alagagi_controller.dart';

import 'trip_repository_fake.dart';

void main() {
  AlagagiController buildController(FakeTripRepository repository) {
    return AlagagiController.forSession(
      const AlagagiSession(
        spaceId: 'main',
        me: AppProfile(
          id: 'youngwooUid',
          nickname: '영우',
          avatar: '🌿',
          isMe: true,
        ),
        partner: AppProfile(
          id: 'minyoungUid',
          nickname: '민영',
          avatar: '🪻',
          isMe: false,
        ),
        data: AlagagiSpaceData(),
      ),
      repository: repository,
    );
  }

  test('photos are not read until the trip screen asks for them', () async {
    final repository = FakeTripRepository(
      photos: const [
        TripPhoto(
          id: 'photo_1',
          tripId: 'trip_1',
          imageDataUrl: 'data:image/jpeg;base64,AAAA',
          createdByProfileId: 'youngwooUid',
        ),
      ],
    );
    final controller = buildController(repository);

    // session 로딩만으로는 사진을 읽지 않는다.
    expect(repository.loadPhotoCallCount, 0);
    expect(controller.tripPhotosFor('trip_1'), isEmpty);

    await controller.ensureTripPhotosLoaded('trip_1');

    expect(repository.loadPhotoCallCount, 1);
    expect(repository.loadedPhotoTripIds, ['trip_1']);
    expect(controller.tripPhotosFor('trip_1'), hasLength(1));

    // 두 번째 진입에서는 다시 읽지 않는다.
    await controller.ensureTripPhotosLoaded('trip_1');
    expect(repository.loadPhotoCallCount, 1);
  });

  test('deleting a trip also removes its items and photos remotely', () async {
    final repository = FakeTripRepository();
    final controller = buildController(repository);

    controller.saveTrip(
      title: '가을 제주',
      destination: '제주도',
      startDateKey: '2026-09-12',
      endDateKey: '2026-09-13',
    );
    final tripId = controller.trips.single.id;
    controller.saveTripItem(
      tripId: tripId,
      kind: TripItemKind.packing,
      title: '충전기',
    );
    controller.saveTripPhoto(
      tripId: tripId,
      imageDataUrl: 'data:image/jpeg;base64,AAAA',
    );
    final itemId = controller.tripItemsFor(tripId).single.id;
    final photoId = controller.tripPhotosFor(tripId).single.id;

    expect(await controller.deleteTrip(tripId), isTrue);
    await Future<void>.delayed(Duration.zero);

    // 남겨두면 화면에서만 사라지고 문서는 영원히 쌓인다.
    expect(repository.deletedTripIds, [tripId]);
    expect(repository.deletedItemIds, [itemId]);
    expect(repository.deletedPhotoIds, [photoId]);
  });
}
