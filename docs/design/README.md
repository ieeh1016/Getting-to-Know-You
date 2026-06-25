# Design Proposal HTML Guide

`docs/design/*.html` files are lightweight visual proposal documents. They help
the user and implementation agent agree on UI direction before changing product
code.

They are useful design artifacts, but they are not the product source of truth.
In Korean terms, `docs/design/*.html`은 source of truth가 아니다. Final behavior
still belongs to `docs/spec.md`, the relevant `docs/spec/*.md` feature spec,
`docs/spec/domain_model.md` when data ownership is involved, and
`docs/test_plan.md`.

## When To Create One

Create or update a design proposal HTML when a task needs visual agreement before
implementation, such as:

- a new feature screen or major flow;
- a rework of a dense mobile screen;
- multiple competing UI approaches;
- a feature whose Firestore write boundary or ownership UI needs to be visible.

Do not use a design proposal as a substitute for spec/test updates. Once an
option is selected, update the relevant spec and test plan before production
code changes.

## Required Shape

Each proposal should be a standalone HTML file in `docs/design/` with inline CSS.
Keep it easy to open directly in a browser without a dev server.

Use this high-level structure unless the proposal has a strong reason not to:

1. `page-title`: title, short context, and gentle product framing.
2. `principles`, `diagnosis`, or `decision`: 2-4 cards explaining the problem,
   constraints, or recommended direction.
3. `stage` or `showcase`: the main comparison area containing 390px-class mobile
   screen mocks.
4. `phone` and `screen`: mobile-first frames that show real screen hierarchy,
   navigation, controls, empty states, and saving/error states when relevant.
5. `proposal-note`: implementation notes covering scope, data model impact,
   Firestore write boundary, tests, and any open tradeoffs.

Use semantic section labels through headings and `aria-label` where practical.
The page should read as a proposal, not a marketing landing page.

## Mobile Frame

- Optimize for a 390px-class mobile screen.
- Use stable dimensions for repeated controls, tiles, calendars, lists, and
  bottom navigation.
- Text must not overlap or clip inside buttons, tabs, cards, or bottom sheets.
- Do not include a fake status bar mock such as `9:41`, battery, signal, or Wi-Fi
  rows. Browser chrome and OS status indicators are outside the app.
- A phone-like outer frame is allowed for side-by-side proposal review, but the
  actual app UI inside the frame should not depend on decorative device chrome.

## Visual Language

Match the current `조금씩` visual direction:

- warm paper background;
- sage as the main accent;
- restrained lavender, clay, gold, or soft neutral support colors;
- calm Korean copy;
- serif display headings only where the current app already uses that tone;
- soft dividers and low-contrast surfaces;
- mobile controls that feel tappable without becoming loud.

Avoid one-note color palettes, generic dashboard styling, score/ranking language,
relationship pressure, decorative gradients, and purely atmospheric visuals that
do not explain the actual UI.

## Content Rules

Every proposal should make the following clear:

- what user problem or product moment it addresses;
- which option is recommended, when multiple options are shown;
- how the design preserves the low-pressure private tone;
- what happens in empty, loading, saved, failed, and owner/partner states when
  those states matter;
- whether draft typing, scrolling, tab movement, or preview opening creates a
  Firestore write;
- which explicit actions create, update, or delete Firestore documents;
- what should be tested before the feature is considered done.

If the design changes a Firebase-backed behavior, include a Firestore write note.
Use the phrase `Firestore write` in the proposal note so reviewers can find the
data boundary quickly.

## Suggested Skeleton

```html
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>조금씩 · 기능 제안</title>
<style>
  *{box-sizing:border-box;margin:0;padding:0}
  :root{
    --outer:#e9e8e2;
    --bg:#f4f3ef;
    --paper:#fcfcfa;
    --text:#45443f;
    --muted:#8f8b82;
    --sage:#8a9a7e;
    --line:#e8e6df;
  }
  body{background:var(--outer);color:var(--text);font-family:system-ui,sans-serif}
  .wrap{max-width:1260px;margin:0 auto;padding:36px 18px 48px}
  .page-title{text-align:center;margin-bottom:28px}
  .principles{display:grid;grid-template-columns:repeat(3,1fr);gap:14px}
  .stage{display:grid;grid-template-columns:repeat(3,minmax(300px,390px));gap:24px;justify-content:center}
  .phone{width:390px;max-width:100%;min-height:844px;background:var(--bg);overflow:hidden}
  .screen{padding:27px 24px 110px}
  .proposal-note{max-width:980px;margin:32px auto 0}
  @media (max-width:760px){
    .principles,.stage{grid-template-columns:1fr}
  }
</style>
</head>
<body>
<main class="wrap">
  <header class="page-title">
    <span class="eyebrow">DESIGN PROPOSAL</span>
    <h1>제안 제목</h1>
    <p>왜 이 화면이 필요한지 짧게 설명한다.</p>
  </header>

  <section class="principles" aria-label="디자인 원칙">
    <!-- 2-4 principle cards -->
  </section>

  <section class="stage" aria-label="제안 화면">
    <article>
      <div class="caption">
        <span class="tag">추천안</span>
        <h2>화면 이름</h2>
        <p>이 화면에서 확인할 핵심.</p>
      </div>
      <div class="phone">
        <div class="screen">
          <!-- mobile UI mock -->
        </div>
      </div>
    </article>
  </section>

  <section class="proposal-note" aria-label="구현 방향 메모">
    <h2>구현 방향</h2>
    <ul>
      <li>선택된 UI 범위와 제외 범위.</li>
      <li>Firestore write가 발생하는 명시적 action.</li>
      <li>필요한 spec, test_plan, domain/widget test.</li>
    </ul>
  </section>
</main>
</body>
</html>
```

## After Implementation

When a proposal is implemented:

- keep the HTML file as historical design context;
- update feature specs and tests to become the durable source of truth;
- do not keep unimplemented proposal-only behavior in production copy;
- if the implemented UI intentionally diverges, record the final behavior in the
  relevant spec instead of editing old proposal text to hide the decision.
