#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"

echo "=== nui_flutter ==="
cd "$ROOT"
flutter analyze
flutter test

echo "=== All checks passed ==="
