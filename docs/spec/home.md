# Home And Navigation Spec

## Purpose

Home is the calm entry point for the day. It should show the current question, small progress, unread activity, and feature entry points without becoming a dashboard full of secondary cards.

## Required Behavior

- Home header shows the current app brand and menu action.
- The main card prioritizes today's question and answer state.
- Quiet progress summary may show the next useful action.
- Feature launcher opens from the home menu.
- Bottom navigation remains stable and does not cover scroll content.
- Home should not show the old `닮은 취향 키워드` card. Similarity details belong in records, not home.
- The unread activity panel shows only a short latest preview on Home. When there are more than three unread activities, a `더 보기` action opens a scrollable bottom sheet with the full unread list.

## Navigation

- Bottom tabs: home, questions, music, meetings, places, my.
- Additional features open from the menu: curiosity, stocks, improvements, taste match, profile cards, wishlist, first visit guide.
- Feature screens should preserve the soft sub-screen header and clear back action unless they are bottom-tab roots.

## Acceptance Criteria

- Home fits a 390px-class mobile viewport without overlapping text or bottom nav.
- Home does not expose score-like copy such as percent, points, ranking, or compatibility numbers.
- Home menu can launch every plus feature.
- New home cards must have a clear repeated use case; otherwise prefer moving the content into its feature screen.
- Multiple unread activities do not make Home long or cramped; the full list is readable in a separate sheet.
