# Flutter Web 카카오 지도 연동 가이드

이 앱의 `장소` 기능은 카카오 지도만 사용한다. 네이버 지도, 직접 입력 provider, 서버 프록시 기반 지역 검색은 MVP 범위에서 제외한다.

## 현재 동작

- 장소 화면의 지도는 카카오 지도 JavaScript SDK를 동적으로 로드한다.
- 장소 추가는 카카오 `Places.keywordSearch` 검색 결과를 선택하는 방식이다.
- 선택한 결과의 `id`, 장소명, 주소, 위도, 경도만 앱 모델로 정규화해 저장한다.
- Firestore `provider` 값은 항상 `kakao`다.
- 현재 위치, 이동 경로, 검색 API raw payload, 이미지 blob은 저장하지 않는다.
- 같은 카카오 `providerPlaceId`를 다시 담으면 새 카드 대신 기존 카드를 업데이트하거나 내 관심만 추가한다.
- 내가 담은 장소는 수정/삭제할 수 있고, 상대가 담은 장소는 관심 표시만 바꾼다.
- 저장 실패는 장소 보드 안에 표시되며 저장 재시도를 제공한다.

## Kakao Developers 설정

1. Kakao Developers Console에서 애플리케이션을 연다.
2. 플랫폼 설정에 Web 사이트 도메인을 등록한다.
3. 운영 배포 도메인에는 `https://ieeh1016.github.io`를 등록한다.
4. 로컬 확인이 필요하면 실제 접속 Origin도 추가한다.
   - `http://localhost:8097`
   - `http://127.0.0.1:8097`
5. 앱 키 목록의 JavaScript Key를 사용한다.

## 키 주입

앱에는 기본 카카오 JavaScript Key가 포함되어 있다. 다른 키로 빌드해야 할 때만 `KAKAO_MAP_JS_KEY`를 넘긴다.

```bash
flutter run -d chrome --web-port=8097 --dart-define=KAKAO_MAP_JS_KEY=<KAKAO_JAVASCRIPT_KEY>
```

```bash
flutter build web --release --base-href /Getting-to-Know-You/ --dart-define=KAKAO_MAP_JS_KEY=<KAKAO_JAVASCRIPT_KEY>
```

GitHub Pages 배포 워크플로는 `secrets.KAKAO_MAP_JS_KEY`를 넘길 수 있다. Secret이 비어 있어도 앱에 포함된 기본 JavaScript Key를 사용한다.

## SDK 로딩

브리지는 `web/kakao_maps_bridge.js`에서 관리한다.

```text
https://dapi.kakao.com/v2/maps/sdk.js?appkey=<KAKAO_MAP_JS_KEY>&libraries=services&autoload=false
```

- `autoload=false`로 로드한 뒤 `kakao.maps.load(callback)`에서 지도와 장소 검색 객체를 만든다.
- 지도 표시는 `renderMapFromJson`을 통해 마커 목록을 전달한다.
- 장소 검색은 `searchPlacesFromJson`을 통해 키워드를 전달하고 정규화된 결과 배열을 받는다.

## 저장 모델

`spaces/{spaceId}/sharedPlaces/{placeId}`

```json
{
  "id": "place_uid_123",
  "name": "작은 전시 공간",
  "address": "서울 성동구 성수동",
  "category": "exhibition",
  "provider": "kakao",
  "providerPlaceId": "123456789",
  "latitude": 37.5446,
  "longitude": 127.0557,
  "note": "전시 보고 근처에서 커피 마시면 좋을 것 같아요.",
  "createdByProfileId": "{uid}",
  "interestedByProfileIds": ["{uid}"],
  "linkedDateKey": "",
  "updatedAt": "serverTimestamp"
}
```

`linkedDateKey`는 이전 데이터 호환성을 위해 빈 문자열로 저장하지만, 현재 `장소` 화면에서는 일정 날짜 연결 UI를 제공하지 않는다.

## 확인 포인트

- 카카오 콘솔에 접속 도메인이 정확히 등록되어 있는지 확인한다.
- 브라우저 콘솔에 SDK 로드 오류가 없는지 확인한다.
- 검색 결과 선택 후 저장하면 지도 마커가 추가되는지 확인한다.
- 같은 장소를 다시 저장해도 카드가 중복 생성되지 않는지 확인한다.
- 상대가 담은 장소에 관심을 표시하면 `interestedByProfileIds`만 바뀌고 Firestore rules를 통과하는지 확인한다.
- Firestore rules에서 `provider == 'kakao'`만 허용되는지 확인한다.
