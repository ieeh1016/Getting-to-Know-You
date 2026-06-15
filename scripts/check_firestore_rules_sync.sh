#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
RULES_FILE="$ROOT_DIR/firestore.rules"
DOC_FILE="$ROOT_DIR/docs/firebase_setup.md"
TMP_DOC_RULES="$(mktemp)"

cleanup() {
  rm -f "$TMP_DOC_RULES"
}
trap cleanup EXIT

awk '
  /^## 6\. Firestore Security Rules$/ { in_section = 1; next }
  in_section && /^```js$/ { in_block = 1; next }
  in_block && /^```$/ { exit }
  in_block { print }
' "$DOC_FILE" > "$TMP_DOC_RULES"

if [ ! -s "$TMP_DOC_RULES" ]; then
  echo "Could not extract Firestore rules block from $DOC_FILE" >&2
  exit 1
fi

if ! cmp -s "$RULES_FILE" "$TMP_DOC_RULES"; then
  echo "firestore.rules is out of sync with docs/firebase_setup.md." >&2
  echo "Update both files together, then rerun this script." >&2
  diff -u "$RULES_FILE" "$TMP_DOC_RULES" >&2 || true
  exit 1
fi

echo "Firestore rules are in sync."

