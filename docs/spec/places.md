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

## 직접 담기와 구글 지도

- 카카오 검색은 국내만 다룬다. 해외 장소는 `직접 담기`로 이름, 주소, 지도 링크, 메모를 적어 담는다.
- 적는 중에 `구글 지도에서 찾아보기`로 지금 적은 이름과 주소를 그대로 검색해 볼 수 있다. 저장하고 나가서 카드의 `지도`를 눌러야만 확인되면, 맞는 곳인지 모른 채 담게 된다.
- 이름이나 주소가 아직 비어 있으면 그 줄은 눌리지 않고, 무엇을 적어야 하는지 문구로 말해준다.
- 여는 주소는 저장된 장소의 `지도`와 같은 규칙(`googleMapsSearchUrl`)을 쓴다. 휴대폰에서는 구글 지도 app이 있으면 app으로, 없으면 web으로 이어진다. 앱마다 다른 scheme을 쓰지 않는다.
- `지도 링크`는 선택이다. 비워두면 이름과 주소로 찾아간다. 붙여넣은 링크가 있으면 그쪽이 우선이다.
- 지도를 여는 것은 Firestore write를 만들지 않는다.
- 직접 담은 장소에는 좌표도 provider id도 없다. `firestore.rules`의 생성 검사는 그 둘을 카카오로 담은 장소에만 요구해야 한다. 무조건 요구하면 직접 담기가 통째로 `permission-denied`가 되고, 해외 장소는 거의 전부 이 경로다.
- `mapLink`는 직접 담은 장소의 유일한 위치 정보다. 소유자 수정이 바꿀 수 있는 키 목록에 반드시 들어가야 한다.
- 장소 보드보다 나중에 생긴 필드(`mapLink`)는 그 전에 담은 문서에 없다. 규칙에서 무조건 읽으면 평가 자체가 오류가 되고, Firestore는 오류를 거부로 처리해 `||`로 이어붙인 뒤 갈래까지 함께 죽는다. 옛 장소를 계획에 붙이는 것조차 막히므로, 나중에 생긴 필드는 `keys().hasAny([...])`로 있을 때만 검사한다.
