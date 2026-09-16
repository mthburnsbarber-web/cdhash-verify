#!/usr/bin/env bash
# Copy this into a macOS release lane and edit the bundle id and candidate path.
set -euo pipefail

bundle_id="${1:-com.example.MyApp}"
candidate="${2:-./build/Release/MyApp.app}"

./cdhash-verify "$bundle_id" "$candidate"

printf '\nRelease gate passed: running app matches candidate artifact.\n'
