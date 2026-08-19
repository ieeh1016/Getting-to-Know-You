# Places Spec

## 목적

Places는 user가 Kakao Map을 검색하고, 가고 싶은 place를 저장하고, place를 meeting plan에 연결하게 한다.

## 필수 동작

- map/search UI는 Kakao Map만 사용한다.
- map은 실제 사용하기 충분한 vertical space를 가진다.
- map drag/scroll gesture가 전체 page를 실수로 scroll하면 안 된다.
- map overlay UI는 임시로 숨길 수 있다.
- place는 name, address, category/source metadata, note, 가능한 경우 coordinates, creator profile과 함께 저장할 수 있다.
- place card는 필요한 곳에서 interest와 meeting-plan linking을 지원한다.
- UI는 API attribution에 필요한 수준을 넘어서 Kakao branding을 과하게 강조하지 않는다.

## 직접 담기와 해외 장소

- Kakao 지도 검색은 국내만 다룬다. 해외 여행이나 검색에 없는 곳은 직접 담는다.
- 직접 담은 장소는 `provider`가 `manual`이고 `providerPlaceId`와 좌표가 없다. 앱 안 지도에는 핀이 찍히지 않는다.
- 이름은 필수, 주소·메모·지도 링크는 선택이다.
- 지도 링크는 `http`/`https`만 받는다. 지도 앱에서 공유한 링크를 붙여넣는 용도다.
- 직접 담은 장소는 `providerPlaceId`가 없어 중복 판정을 이름과 주소로 한다. 띄어쓰기와 대소문자 차이는 같은 곳으로 본다. 같은 곳을 다시 담으면 새 카드 대신 기존 카드를 갱신하고 내 관심을 더한다.
- 주소가 다르면 이름이 같아도 다른 곳으로 둔다. 같은 이름의 지점이 여럿 있을 수 있다.

## 지도 앱으로 열기

- 모든 장소 카드는 `구글 지도` action을 가진다. 해외에서는 이쪽이 실제로 쓰인다.
- 여는 주소는 붙여넣은 링크 -> 좌표 -> 이름과 주소 검색 순으로 정한다. 그래서 좌표가 없는 직접 담은 장소도 항상 열린다.
- Kakao로 담은 국내 장소는 `카카오맵` action을 함께 가진다.

## 데이터 규칙

- place save는 shared place document 하나를 쓴다.
- interest/link operation은 관련 place 또는 meeting entry만 update한다.
- location tracking은 scope 밖이다. saved coordinate는 selected place result에서만 온다.

## 운영 Guide

- Kakao Developers domain setup, JavaScript key injection, SDK loading, map troubleshooting은 [`../map_open_api_guide.md`](../map_open_api_guide.md)에 둔다.

## 수용 기준

- Kakao map render가 실패하면 앱은 refresh/init을 한 번 retry한다.
- place save는 Firestore rules 아래에서 동작해야 한다.
- map을 세로로 drag하는 동안 page scroll이 움직이지 않는다.
- place count가 늘어나도 place list는 읽기 좋아야 한다.
