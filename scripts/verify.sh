#!/usr/bin/env bash
set -euo pipefail

flutter pub get
./scripts/check_firestore_rules_sync.sh
dart analyze
flutter test
flutter build web
