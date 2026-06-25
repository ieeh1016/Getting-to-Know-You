# Music Spec

## 목적

Music note는 screen을 긴 unfiltered list로 만들지 않으면서 user가 song, note, 들었는지 여부를 공유하게 한다.

## 필수 동작

- user는 song title, artist, optional link, mood, note를 추가할 수 있다.
- mood는 quick label에서 고르거나 custom text로 직접 입력할 수 있다.
- user는 자신의 music note를 edit할 수 있다.
- partner note는 listen-state action을 제외하고 read-only다.
- listen emoji/state는 detail sheet를 열지 않고 toggle할 수 있다.
- music count가 늘어나면 list filtering이 탐색을 도와야 한다.
- 새롭거나 아직 보지 않은 partner addition은 home summary에 표시될 수 있다.

## 데이터 규칙

- add/edit write는 `updatedAt`을 갱신한다.
- listen-state write는 `listenedByProfileIds`만 update하며 `updatedAt`을 갱신하지 않는다.
- external link는 열기 전에 normalize한다.

## 수용 기준

- music list는 유용한 unread/unlistened state를 우선한다.
- edit action은 내 note에만 보인다.
- link action은 normalized URL을 external link opener로 연다.
- long note는 readable detail sheet에서 열린다.
