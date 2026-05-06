# Bug Council Phase Tracker — TEMPLATE

Copy into `docs/dev/bug-council-phases.md` when a multi-phase council upgrade is in flight. The tracker is the resumable plan: every agent that picks up the work updates this file as phases progress.

| # | Name | Status | Owner | Exit criteria |
| --- | --- | --- | --- | --- |
| 1 | Council process upgrades | _Pending / In progress / Done_ | _agent_ | Severity/confidence schema added, sibling-search rule documented, negative-space gate doc + script, behavior-pinning pattern documented. |
| 2 | Semantic analyzer beachhead | _Pending / In progress / Done_ | _agent_ | One language-appropriate semantic analyzer (Roslyn / Clippy / ESLint) implementing a taint-to-allocation or taint-to-path lens, with tests. |
| 3 | Adversarial fuzz harness | _Pending / In progress / Done_ | _agent_ | Roundtrip + adversarial-input property tests for protocol/parsing surfaces, gated by the baseline. |
| 4 | _project-specific phase_ | _Pending_ | _agent_ | _exit criteria_ |

## How to resume

1. Read recent commit messages prefixed `council:` to see what landed.
2. Read this file's phase table to find the first non-Done row.
3. Run `bash scripts/check-remediation-baseline.sh` and `bash scripts/check-council-sweep-counts.sh` to confirm a green baseline.
4. Pick up the phase, update its status to In Progress, and follow its exit checklist.

If a phase has been partially completed by another agent, treat the on-disk artifacts as the source of truth and reconcile this tracker against them rather than re-doing work.
