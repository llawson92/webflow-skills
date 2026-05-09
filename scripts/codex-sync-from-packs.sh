#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

packs=(
  "plugins/webflow-skills"
  "plugins/webflow-code-component-skills"
  "plugins/webflow-cli-skills"
  "plugins/webflow-designer-tools"
)

rm -rf "${repo_root}/skills"
mkdir -p "${repo_root}/skills"

for pack in "${packs[@]}"; do
  find "${repo_root}/${pack}/skills" -path "*/SKILL.md" -print0 |
    while IFS= read -r -d "" skill_file; do
      cp -R "$(dirname "${skill_file}")" "${repo_root}/skills/"
    done
done

skill_count="$(find "${repo_root}/skills" -maxdepth 2 -name SKILL.md | wc -l | tr -d " ")"
printf "Synced %s Webflow skills into %s\n" "${skill_count}" "${repo_root}/skills"
