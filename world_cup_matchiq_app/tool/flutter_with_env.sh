#!/usr/bin/env bash
set -euo pipefail

env_file="${ENV_FILE:-.env.local}"
flutter_bin="${FLUTTER_BIN:-/Users/parasgandhi/Project/temp/flutter/bin/flutter}"
dart_defines=()

if [[ -f "$env_file" ]]; then
  while IFS='=' read -r key value; do
    [[ -z "${key:-}" || "$key" =~ ^# ]] && continue
    case "$key" in
      GEMINI_API_KEY|AI_MODEL)
        dart_defines+=("--dart-define=$key=$value")
        ;;
    esac
  done < "$env_file"
fi

exec "$flutter_bin" "$@" "${dart_defines[@]}"
