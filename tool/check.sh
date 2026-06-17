#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"

echo "=== nui_flutter ==="
cd "$ROOT"
flutter analyze
flutter test

# Uncomment when consumer apps are set up:
# echo "=== famsub-mobile ==="
# cd "$ROOT/../famsub-mobile"
# flutter analyze
# flutter test

# echo "=== tallyno-mobile ==="
# cd "$ROOT/../tallyno-mobile"
# flutter analyze
# flutter test

echo "=== All checks passed ==="
