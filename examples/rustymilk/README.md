# RustyMilk-Style Polyglot Council

RustyMilk is a useful template for repos that mix Rust crates, browser packages, Node tooling, generated content, and release metadata.

Recommended phases:

1. Fresh candidate inventory across Rust, JS, content/catalog, lifecycle, filesystem, parser, renderer, and release surfaces.
2. Active discovery report saved under `.council/`, with a clear "not proof of no bugs" verdict boundary.
3. Active backlog drift gate that compares generated counts to a checked-in `docs/dev/bug-council-active-backlog.md`.
4. Negative-space gate that asserts the all-phases runner, package entrypoint, remediation baseline, calibrated fixtures, unsafe-code posture, and content validation remain wired.
5. Calibrated semantic lenses with known-bad and known-good Rust/JS fixtures before production scans.
6. Product verification in the same all-phases command: Rust workspace tests, web tests, app smoke tests, pack validation, and content validation.

High-value candidate classes:

- Rust filesystem/path sinks
- Rust parser/allocation/capacity sinks
- Rust lifecycle/concurrency sinks
- Rust dynamic command/process/plugin sinks
- JS DOM injection sinks
- JS storage/network/file sinks
- content/catalog path and generated artifact sinks
- release/package metadata sinks

Do not report a green run as "no bugs found." Report it as "all registered calibrated gates passed."
