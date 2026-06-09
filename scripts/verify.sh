#!/usr/bin/env bash
set -euo pipefail

flutter pub get
dart analyze
flutter test
flutter build web

