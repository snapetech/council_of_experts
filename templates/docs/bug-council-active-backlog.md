# Bug Council Active Backlog

Copy into `docs/dev/bug-council-active-backlog.md` and replace the rows below
with the sections emitted by `scripts/run-council-active-bughunt.sh`.

This backlog is the durable handoff for active discovery. A green all-phases
council run is not proof that no bugs exist; this file records the active
discovery piles that still need review, splitting, or burn-down.

Every active-bughunt section must have a row below with the current candidate
count. `scripts/check-council-active-backlog.sh` fails when a section is
missing, left `Untriaged`, or has a stale count.

Status meanings:

- `Open` - broad queue still needs classification or narrower subgroup probes.
- `Guarded` - narrow probe is empty and protected by remediation checks.
- `Accepted` - confirmed bug class exists and is being fixed.
- `Existing guard` - candidates are covered by existing behavior and gates.
- `False positive` - scanner shape is not a bug for the listed rationale.
- `Out of scope` - candidate belongs outside this council.

| Section | Candidate count | Status | Current classification | Next action |
| --- | ---: | --- | --- | --- |
| `Example suspicious boundary` | 0 | Guarded | Replace this placeholder with a real active-bughunt section. | Keep the corresponding remediation or negative-space gate. |
| `Example broad queue` | 0 | Open | Replace this placeholder with a broad queue emitted by the active bughunt runner. | Split into narrower subgroups, classify every subgroup, and promote confirmed bug classes into the ledger. |
