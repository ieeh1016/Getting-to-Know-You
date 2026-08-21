#!/usr/bin/env bash
set -euo pipefail

flutter pub get
./scripts/check_firestore_rules_sync.sh
./scripts/check_firestore_rules_behavior.sh
dart analyze
flutter test
flutter build web
