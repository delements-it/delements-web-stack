#!/usr/bin/env bash
# ============================================================================
# 09-copy-local-programs.sh - Copy local programs to $BSI_ROOT
# ============================================================================
set -euo pipefail

BSI_ROOT="${BSI_ROOT:-$HOME/Documents/Business Systems Integration}"

echo "📦 Copying local programs to $BSI_ROOT..."
echo ""

# Source directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"
SRC_DIR="$REPO_ROOT/local_programs"

if [[ ! -d "$SRC_DIR" ]]; then
  echo "❌ local_programs/ not found in repo"
  exit 1
fi

# Create target directory
mkdir -p "$BSI_ROOT/local_programs"

# Copy each program
for program in shopify_codex_bridge shopify_brain_builder webflow_codex_bridge; do
  if [[ -d "$SRC_DIR/$program" ]]; then
    if [[ -d "$BSI_ROOT/local_programs/$program" ]]; then
      echo "  ⚠️  $program already exists, skipping (backup first if you want to update)"
    else
      cp -R "$SRC_DIR/$program" "$BSI_ROOT/local_programs/"
      chmod +x "$BSI_ROOT/local_programs/$program"/* 2>/dev/null || true
      echo "  ✅ Copied $program"
    fi
  else
    echo "  ⚠️  $program not found in repo"
  fi
done

echo ""
echo "✅ Local programs copied to $BSI_ROOT/local_programs/"
