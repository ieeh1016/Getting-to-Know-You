# Music Spec

## 목적

Music note는 screen을 긴 unfiltered list로 만들지 않으면서 user가 song, note, 들었는지 여부를 공유하게 한다.

## 필수 동작

- user는 song title, artist, optional link, mood, note를 추가할 수 있다.
- mood는 quick label에서 고르거나 custom text로 직접 입력할 수 있다.
- user는 자신의 music note를 edit할 수 있다.
- partner note는 listen-state action을 제외하고 read-only다.
- listen emoji/state는 detail sheet를 열지 않고 toggle할 수 있다.
- user는 music note detail에서 짧은 댓글을 여러 개 남길 수 있다.
- music list card는 댓글 전체 thread를 펼치지 않고 댓글 수와 최신 댓글 preview만 보여준다.
- user는 자신이 남긴 music note comment만 edit/delete할 수 있다.
- partner가 남긴 music note comment는 read-only다.
- music count가 늘어나면 list filtering이 탐색을 도와야 한다.
- 새롭거나 아직 보지 않은 partner music note/comment addition은 home summary에 표시될 수 있다.

## 데이터 규칙

- add/edit write는 `updatedAt`을 갱신한다.
- listen-state write는 `listenedByProfileIds`만 update하며 `updatedAt`을 갱신하지 않는다.
- comment add/edit write는 `musicNoteComments/{commentId}` 한 문서만 쓰고, parent music note의 `updatedAt` 또는 ordering을 바꾸지 않는다.
- comment delete는 `musicNoteComments/{commentId}` 한 문서만 삭제한다.
- comment draft typing은 local state only이며 Firestore write를 만들지 않는다.
- external link는 열기 전에 normalize한다.

## 수용 기준

- music list는 유용한 unread/unlistened state를 우선한다.
- edit action은 내 note에만 보인다.
- link action은 normalized URL을 external link opener로 연다.
- long note는 readable detail sheet에서 열린다.
- music note detail은 댓글 목록과 댓글 composer를 보여준다.
- music note card는 최신 댓글 한 줄과 댓글 수를 보여주되, 댓글이 없으면 card height를 불필요하게 늘리지 않는다.
- 빈 댓글과 너무 긴 댓글은 저장하지 않고 composer 안에서 오류를 보여준다.
- 내가 남긴 댓글에만 edit/delete action이 보인다.
