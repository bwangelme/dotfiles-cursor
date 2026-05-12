#!/usr/bin/env bash
# Install Cursor rules and skills as symlinks into ~/.cursor/{rules,skills}.
# Run from anywhere; paths are resolved relative to this script's directory.

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RULES_SRC="${ROOT}/rules"
SKILLS_SRC="${ROOT}/skills"
RULES_DEST="${HOME}/.cursor/rules"
SKILLS_DEST="${HOME}/.cursor/skills"

if [[ ! -d "${RULES_SRC}" ]]; then
  echo "install.sh: missing directory: ${RULES_SRC}" >&2
  exit 1
fi
if [[ ! -d "${SKILLS_SRC}" ]]; then
  echo "install.sh: missing directory: ${SKILLS_SRC}" >&2
  exit 1
fi

mkdir -p "${RULES_DEST}" "${SKILLS_DEST}"

shopt -s nullglob dotglob

for path in "${RULES_SRC}"/*; do
  [[ -f "${path}" ]] || continue
  name="$(basename "${path}")"
  ln -sfn "${path}" "${RULES_DEST}/${name}"
  echo "rules -> ${RULES_DEST}/${name}"
done

for path in "${SKILLS_SRC}"/*; do
  [[ -d "${path}" ]] || continue
  name="$(basename "${path}")"
  ln -sfn "${path}" "${SKILLS_DEST}/${name}"
  echo "skills -> ${SKILLS_DEST}/${name}"
done

echo "Done."
