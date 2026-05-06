#!/usr/bin/env bash
#
# Bug Council negative-space gate — TEMPLATE.
#
# Asserts that every declared trust boundary in
# docs/dev/bug-council-negative-space.md still has its required validator
# symbol present in the expected sink file. Catches the failure mode the
# candidate scanner cannot see: a new boundary added without a validator.
#
# Wired into scripts/check-remediation-baseline.sh.

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

failures=0

pass() { printf 'PASS %s\n' "$1"; }
fail() { printf 'FAIL %s\n' "$1" >&2; failures=$((failures + 1)); }

assert_validator_present() {
  local boundary="$1"
  local sink="$2"
  local symbol="$3"

  if [[ ! -e "$sink" ]]; then
    fail "negative-space: sink missing for boundary [$boundary]: $sink"
    return
  fi

  if rg -n --fixed-strings -- "$symbol" "$sink" >/dev/null; then
    pass "negative-space: [$boundary] $symbol present in $sink"
  else
    fail "negative-space: [$boundary] $symbol missing from $sink"
  fi
}

# Replace the placeholder rows below with one assert_validator_present per
# trust boundary declared in docs/dev/bug-council-negative-space.md.
#
# assert_validator_present \
#   "boundary-name" \
#   "src/path/to/sink.ext" \
#   "ValidatorSymbol"

if [[ "$failures" -gt 0 ]]; then
  printf '\n%d negative-space gate check(s) failed.\n' "$failures" >&2
  exit 1
fi

printf '\nAll negative-space gate checks passed.\n'
