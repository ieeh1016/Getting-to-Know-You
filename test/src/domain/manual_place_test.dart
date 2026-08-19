import 'package:flutter_test/flutter_test.dart';
import 'package:minyoung_pick/src/domain/alagagi_controller.dart';

void main() {
  AlagagiController buildController() {
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
    );
  }

  group('Manual places', () {
    test('a place can be saved without any map search result', () {
      final controller = buildController();

      final error = controller.saveManualPlace(
        name: 'Ramen Nagi',
        category: PlaceCategory.food,
        address: 'Shinjuku, Tokyo',
        note: '줄이 길다고 함',
      );

      expect(error, isNull);
      final place = controller.sharedPlaces.single;
      expect(place.provider, MapApiProvider.manual);
      expect(place.providerPlaceId, isEmpty);
      expect(place.latitude, isNull);
      expect(place.interestedByProfileIds, contains('youngwooUid'));
    });

    test('an empty name is rejected', () {
      final controller = buildController();

      expect(
        controller.saveManualPlace(name: '   ', category: PlaceCategory.food),
        isNotNull,
      );
      expect(controller.sharedPlaces, isEmpty);
    });

    test('a map link must be an http address', () {
      final controller = buildController();

      expect(
        controller.saveManualPlace(
          name: 'Ramen Nagi',
          category: PlaceCategory.food,
          mapLink: 'javascript:alert(1)',
        ),
        isNotNull,
      );
      expect(
        controller.saveManualPlace(
          name: 'Ramen Nagi',
          category: PlaceCategory.food,
          mapLink: 'https://maps.app.goo.gl/abc',
        ),
        isNull,
      );
      expect(controller.sharedPlaces.single.mapLink, 'https://maps.app.goo.gl/abc');
    });

    test('the same place saved twice merges instead of splitting', () {
      final controller = buildController();
      controller.saveManualPlace(
        name: 'Ramen Nagi',
        category: PlaceCategory.food,
        address: 'Shinjuku, Tokyo',
      );

      // 띄어쓰기와 대소문자만 다른 입력은 같은 곳으로 본다.
      final error = controller.saveManualPlace(
        name: 'ramen  nagi',
        category: PlaceCategory.food,
        address: 'Shinjuku,  Tokyo',
        note: '저녁에 가자',
      );

      expect(error, isNull);
      expect(controller.sharedPlaces, hasLength(1));
      expect(controller.sharedPlaces.single.note, '저녁에 가자');
    });

    test('a different address keeps them as separate places', () {
      final controller = buildController();
      controller.saveManualPlace(
        name: 'Ramen Nagi',
        category: PlaceCategory.food,
        address: 'Shinjuku, Tokyo',
      );
      controller.saveManualPlace(
        name: 'Ramen Nagi',
        category: PlaceCategory.food,
        address: 'Shibuya, Tokyo',
      );

      expect(controller.sharedPlaces, hasLength(2));
    });
  });

  group('Google maps url', () {
    SharedPlace place({
      String mapLink = '',
      double? latitude,
      double? longitude,
      String address = '',
    }) {
      return SharedPlace(
        id: 'place_1',
        name: 'Ramen Nagi',
        address: address,
        category: PlaceCategory.food,
        provider: MapApiProvider.manual,
        createdByProfileId: 'youngwooUid',
        interestedByProfileIds: const {'youngwooUid'},
        mapLink: mapLink,
        latitude: latitude,
        longitude: longitude,
      );
    }

    test('a pasted link wins', () {
      expect(
        place(mapLink: 'https://maps.app.goo.gl/abc').googleMapsUrl,
        'https://maps.app.goo.gl/abc',
      );
    });

    test('coordinates are used when there is no link', () {
      expect(
        place(latitude: 35.69, longitude: 139.7).googleMapsUrl,
        contains('query=35.69,139.7'),
      );
    });

    test('name and address are searched when nothing else is known', () {
      final url = place(address: 'Shinjuku, Tokyo').googleMapsUrl;

      expect(url, startsWith('https://www.google.com/maps/search/'));
      expect(url, contains(Uri.encodeComponent('Ramen Nagi Shinjuku, Tokyo')));
    });
  });
}
