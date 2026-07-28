#!/usr/bin/env bash
set -euo pipefail

DESTINATION="${HOME}/.codex/skills"
INSTALL_ALL=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    --all)
      INSTALL_ALL=1
      shift
      ;;
    --destination)
      DESTINATION="$2"
      shift 2
      ;;
    *)
      echo "Unknown option: $1"
      echo "Usage: ./validate-install.sh [--all] [--destination /path/to/skills]"
      exit 1
      ;;
  esac
done

CORE_SKILLS=(
  "bifang-starter"
  "bifang-topic"
  "bifang-script"
  "bifang-review"
  "bifang-rewrite"
  "bifang-feedback"
)

OPTIONAL_SKILLS=(
  "bifang-intake"
  "bifang-diagnosis"
  "bifang-profile"
  "bifang-assets"
  "bifang-report"
  "bifang-baokuan"
  "bifang-baokuan-batch"
)

SKILLS=("${CORE_SKILLS[@]}")
if [[ "$INSTALL_ALL" == "1" ]]; then
  SKILLS+=("${OPTIONAL_SKILLS[@]}")
fi

echo "Checking Bifang skills in: $DESTINATION"

FAILED=0

for skill in "${SKILLS[@]}"; do
  skill_file="${DESTINATION}/${skill}/SKILL.md"
  if [[ -f "$skill_file" ]]; then
    echo "[OK] ${skill}"
  else
    echo "[MISSING] ${skill} -> ${skill_file}"
    FAILED=1
  fi
done

if [[ "$FAILED" == "1" ]]; then
  echo "Validation failed. Run install.sh again or check your skills directory."
  exit 1
fi

echo "Validation passed. Restart Codex or open a new conversation, then test bifang-starter."
