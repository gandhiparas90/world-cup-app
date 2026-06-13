#!/usr/bin/env bash
set -euo pipefail

env_file="${ENV_FILE:-.env.local}"
flutter_bin="${FLUTTER_BIN:-/Users/parasgandhi/Project/temp/flutter/bin/flutter}"
dart_defines=()
declare -A values

if [[ -f "$env_file" ]]; then
  while IFS='=' read -r key value; do
    [[ -z "${key:-}" || "$key" =~ ^# ]] && continue
    case "$key" in
      GEMINI_API_KEY|AI_MODEL|GEMINI_PROXY_URL)
        values["$key"]="$value"
        ;;
    esac
  done < "$env_file"
fi

for key in GEMINI_API_KEY GEMINI_PROXY_URL AI_MODEL; do
  if [[ -n "${!key:-}" ]]; then
    values["$key"]="${!key}"
  fi
done

if [[ -n "${values[GEMINI_PROXY_URL]:-}" ]]; then
  dart_defines+=("--dart-define=GEMINI_PROXY_URL=${values[GEMINI_PROXY_URL]}")
elif [[ -n "${values[GEMINI_API_KEY]:-}" ]]; then
  dart_defines+=("--dart-define=GEMINI_API_KEY=${values[GEMINI_API_KEY]}")
fi

if [[ -n "${values[AI_MODEL]:-}" ]]; then
  dart_defines+=("--dart-define=AI_MODEL=${values[AI_MODEL]}")
fi

exec "$flutter_bin" "$@" "${dart_defines[@]}"
