#!/usr/bin/env bash
#
# Build the versioned .vsix once and publish it to BOTH registries:
#   - Visual Studio Marketplace (via vsce)  -> needs VSCE_PAT
#   - Open VSX Registry        (via ovsx)   -> needs OVSX_PAT
#
# Usage:
#   VSCE_PAT='<azure-devops-pat>' OVSX_PAT='<open-vsx-token>' npm run publish:all
#
# Both tokens are read from the environment so they are never written to disk
# or committed. Run from the package root.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

POLYFILL="--require ./scripts/polyfill-file.js"
VSCE="node $POLYFILL ./node_modules/@vscode/vsce/vsce"
OVSX="node $POLYFILL ./node_modules/ovsx/lib/ovsx"

NAME="$(node -p "require('./package.json').name")"
VERSION="$(node -p "require('./package.json').version")"
PUBLISHER="$(node -p "require('./package.json').publisher")"
VSIX="${NAME}-${VERSION}.vsix"

if [[ -z "${VSCE_PAT:-}" ]]; then
  echo "ERROR: VSCE_PAT is not set (Azure DevOps PAT for the VS Marketplace)." >&2
  exit 1
fi
if [[ -z "${OVSX_PAT:-}" ]]; then
  echo "ERROR: OVSX_PAT is not set (Open VSX access token)." >&2
  exit 1
fi

echo ">> Packaging ${VSIX} ..."
# shellcheck disable=SC2086
$VSCE package --out "$VSIX"

echo ">> Publishing ${VSIX} to the Visual Studio Marketplace ..."
# vsce reads VSCE_PAT from the environment.
# shellcheck disable=SC2086
$VSCE publish --packagePath "$VSIX"

echo ">> Ensuring Open VSX namespace '${PUBLISHER}' exists ..."
# create-namespace is idempotent enough; ignore failure if it already exists.
# shellcheck disable=SC2086
$OVSX create-namespace "$PUBLISHER" -p "$OVSX_PAT" || \
  echo "   (namespace already exists or is owned by you; continuing)"

echo ">> Publishing ${VSIX} to Open VSX ..."
# shellcheck disable=SC2086
$OVSX publish "$VSIX" -p "$OVSX_PAT"

echo ">> Done. Published ${PUBLISHER}.${NAME} v${VERSION} to both registries."
