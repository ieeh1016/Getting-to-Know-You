# Home And Navigation Spec

## 목적

Home은 하루를 시작하는 조용한 진입점이다. secondary card가 가득한 dashboard가 되지 않으면서 current question, 작은 progress, unread activity, feature entry point를 보여줘야 한다.

## 필수 동작

- Home header는 현재 app brand와 menu action을 보여준다.
- main card는 today's question과 answer state를 우선한다.
- today's question answer comment는 독립 card처럼 커지지 않고 answer card 하단의 작은 footer/shelf로 붙어야 한다.
- 조용한 progress summary는 다음에 유용한 action 하나를 보여줄 수 있다.
- feature launcher는 home menu에서 열린다.
- bottom navigation은 안정적으로 유지되고 scroll content를 덮지 않는다.
- Home에는 예전 `닮은 취향 키워드` card를 보여주지 않는다. similarity detail은 Home이 아니라 records에 둔다.
- unread activity panel은 Home에서 짧은 최신 preview만 보여준다. unread activity가 3개를 넘으면 `더 보기` action으로 전체 unread list를 담은 scrollable bottom sheet를 연다.

## Navigation

- bottom tabs: home, questions, music, meetings, places, my.
- additional features는 menu에서 연다: curiosity, stocks, improvements, taste match, profile cards, wishlist, memory cards, first visit guide.
- feature screen이 bottom-tab root가 아니라면 부드러운 sub-screen header와 명확한 back action을 유지한다.

## 수용 기준

- Home은 text나 bottom nav가 겹치지 않고 390px-class mobile viewport에 맞아야 한다.
- Home은 percent, points, ranking, compatibility number 같은 score-like copy를 노출하지 않는다.
- Home menu에서 모든 plus feature를 열 수 있다.
- `서로의 기억`은 하단 tab을 추가하지 않고 Home 주요 카드와 menu entry에서 연다.
- 새 Home card는 반복 사용 목적이 명확해야 한다. 그렇지 않다면 해당 feature screen으로 옮기는 것을 우선한다.
- unread activity가 여러 개여도 Home이 길거나 답답해지지 않는다. 전체 list는 별도 sheet에서 읽기 좋게 보여준다.
