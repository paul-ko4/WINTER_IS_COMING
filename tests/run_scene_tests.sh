#!/bin/zsh
set -euo pipefail

scene_repo_dir="$(cd "$(dirname "$0")/.." && pwd)"
scene_test_dir="$(mktemp -d "${TMPDIR:-/tmp}/winter-scene-tests.XXXXXX")"
trap 'rm -rf "$scene_test_dir"' EXIT

# Compile the scene and delegate unchanged, omitting only the script's app run loop.
sed '/^let app = NSApplication.shared$/,$d' "$scene_repo_dir/WinterIsComing.swift" > "$scene_test_dir/SnowTypes.swift"
swiftc -O -D SNOW_SCENE_TESTS -parse-as-library \
    -module-cache-path "$scene_test_dir/module-cache" \
    "$scene_test_dir/SnowTypes.swift" "$scene_repo_dir/tests/SnowSceneTests.swift" \
    -o "$scene_test_dir/SnowSceneTests"
"$scene_test_dir/SnowSceneTests"
