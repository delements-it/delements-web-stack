#!/usr/bin/env bash
set -euo pipefail

URL="${1:-}"
if [[ -z "$URL" ]]; then
  echo "Usage: $0 <url>" >&2
  exit 1
fi

open -na "Google Chrome" --args --profile-directory="Profile 3" "$URL"
