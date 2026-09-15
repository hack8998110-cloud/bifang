#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
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
      echo "Usage: ./install.sh [--all] [--destination /path/to/skills]"
      exit 1
      ;;
  esac
done

CORE_SKILLS=(
  "bifang"
)

ADVANCED_SKILLS=(
  "bifang-starter"
  "bifang-topic"
  "bifang-script"
  "bifang-review"
  "bifang-rewrite"
  "bifang-feedback"
  "bifang-intake"
  "bifang-diagnosis"
  "bifang-profile"
  "bifang-assets"
  "bifang-report"
  "bifang-clip"
  "bifang-account-plan"
  "bifang-evidence"
)

LEGACY_SKILLS=(
  "bifang-baokuan"
  "bifang-baokuan-batch"
)

SKILLS=("${CORE_SKILLS[@]}")
if [[ "$INSTALL_ALL" == "1" ]]; then
  SKILLS+=("${ADVANCED_SKILLS[@]}" "${LEGACY_SKILLS[@]}")
fi

mkdir -p "$DESTINATION"

echo "Bifang skills destination: $DESTINATION"
echo "Installed:"

for skill in "${SKILLS[@]}"; do
  source_dir="$(find "${ROOT}/skills" -mindepth 2 -maxdepth 2 -type d -name "$skill" -print -quit)"
  if [[ ! -f "${source_dir}/SKILL.md" ]]; then
    echo "  - skipped missing: ${skill}"
    continue
  fi

  rm -rf "${DESTINATION}/${skill}"
  cp -R "$source_dir" "$DESTINATION/"
  echo "  - ${skill}"
done

echo "Done. Restart Codex or open a new conversation, then tell Bifang what you need."
