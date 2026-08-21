#!/usr/bin/env bash
# firestore.rules를 emulator에 올려 실제 쓰기로 검사한다.
#
# check_firestore_rules_sync.sh는 규칙 파일과 문서가 같은지만 본다. 규칙이
# 실제 쓰기를 받아주는지는 아무도 확인하지 않아, 앱은 통과하는데 서버가
# 거부하는 상태가 여러 번 배포됐다. 이 script가 그 구멍을 막는다.
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TEST_DIR="$ROOT_DIR/tools/firestore_rules_test"

if ! command -v node >/dev/null 2>&1; then
  echo "node is required to run the Firestore rules behavior tests." >&2
  exit 1
fi
if ! command -v java >/dev/null 2>&1; then
  echo "java is required by the Firestore emulator." >&2
  exit 1
fi

if [ ! -d "$TEST_DIR/node_modules" ]; then
  (cd "$TEST_DIR" && npm install --silent)
fi

cd "$ROOT_DIR"
npx --yes "firebase-tools@${FIREBASE_TOOLS_VERSION:-13}" emulators:exec \
  --only firestore \
  --project rules-test \
  "cd tools/firestore_rules_test && node --test rules.test.js"
