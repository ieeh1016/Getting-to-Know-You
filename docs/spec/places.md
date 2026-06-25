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
