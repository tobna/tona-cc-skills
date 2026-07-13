#!/usr/bin/env bash
# Add the marketplaces and install the Claude Code plugins I use.
# Idempotent — safe to re-run. Restart Claude Code afterward to load them.
set -euo pipefail

marketplaces=(
  anthropics/claude-plugins-official
  forrestchang/andrej-karpathy-skills
  DietrichGebert/ponytail
  gnurio/tufte-vdqi-plugin
)
plugins=(
  pyright-lsp@claude-plugins-official
  frontend-design@claude-plugins-official
  andrej-karpathy-skills@karpathy-skills
  ponytail@ponytail
  tufte-vdqi@tufte-vdqi-marketplace
)

for m in "${marketplaces[@]}"; do
  echo "marketplace: $m"
  claude plugin marketplace add "$m" </dev/null || true   # already-added is fine
done
for p in "${plugins[@]}"; do
  echo "install: $p"
  claude plugin install "$p" -s user </dev/null
done
