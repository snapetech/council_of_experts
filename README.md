# Council of Experts

A reusable bug-finding workflow that goes beyond regex linting to find higher-severity, deeper-fix bugs across a codebase. Extracted from the [slskNet.Runtime](https://github.com/snapetech/slskNet.Runtime) project where it has been used to drive multiple full sweeps of a network protocol implementation.

The council is a small, opinionated process layered on top of a few language-agnostic scripts. It is **not** a tool you install; it is a set of templates you copy into your repo and adapt.

## What the council does that linting does not

| Layer | What it catches |
| --- | --- |
| **Inventory-first regex sweep** | Surface patterns: mutable public state, raw byte arrays, length-prefix reads, lifecycle missteps, secret material. |
| **Severity / confidence schema** | Forces every accepted finding to be tiered, so triage is legible across hundreds of rows. |
| **Sibling-search rule** | When a fix lands, the same shape is swept across the codebase before the row is closed. |
| **Negative-space gate** | Declares trust boundaries by name and asserts each one's required validator is in place — catches the boundary you forgot to think about. |
| **Behavior-pinning pattern** | Every text-anchored fix gate has a paired behavior test, so a refactor that erases the guard fails in two places. |
| **Roslyn analyzer template (.NET)** | Semantic taint-to-allocation and taint-to-loop-bound lens guidance; ports the highest-severity scan classes from regex to dataflow. |
| **Calibration and fuzz templates** | Deliberate mutations, known-good validator paths, multi-seed adversarial corpora, and hostile boundary inputs that keep zero-finding runs honest. |
| **Phase tracker** | Multi-phase upgrades are resumable across sessions and across agents. |

## Repository layout

```
council_of_experts/
├── README.md
├── LICENSE
├── templates/
│   ├── scripts/                    # bash gates, language-agnostic
│   │   ├── scan-bug-council-candidates.sh
│   │   ├── check-council-sweep-counts.sh
│   │   ├── check-remediation-baseline.sh
│   │   └── check-council-negative-space.sh
│   ├── docs/                       # process docs, drop-in
│   │   ├── bug-council-phases.md
│   │   ├── bug-council-scan-registry.md
│   │   ├── bug-council-severity-schema.md
│   │   ├── bug-council-sibling-search.md
│   │   ├── bug-council-negative-space.md
│   │   ├── bug-council-behavior-pinning.md
│   │   ├── bug-council-adversarial-fuzz.md
│   │   ├── bug-burndown-ledger.md
│   │   └── bug-council-roslyn-analyzers.md
│   └── analyzers/csharp/           # Roslyn analyzer template
│       ├── CouncilAnalyzers/
│       ├── CouncilAnalyzers.Tests/
│       └── CouncilAnalyzers.Calibration/
└── examples/                       # short worked examples per ecosystem
    ├── dotnet/
    ├── rust/
    └── typescript/
```

## How to import the council into a repo

The council is intentionally not a package. Adapting it forces you to name your own boundaries, which is half the value.

1. Copy `templates/scripts/*` into `your-repo/scripts/`. Adapt the regex patterns in `scan-bug-council-candidates.sh` to your language and project layout. Keep the four-script structure: scanner, sweep-count drift gate, remediation baseline, negative-space gate.
2. Copy `templates/docs/*` into `your-repo/docs/dev/` (or wherever your dev docs live). The schema, sibling-search, and behavior-pinning docs are language-agnostic and drop in unchanged. The phases, registry, ledger, and negative-space docs need a first pass to reflect your codebase.
3. Decide if you need a Roslyn analyzer (only for .NET). If yes, copy `templates/analyzers/csharp/` into `your-repo/analyzers/`, reference it from your runtime project as `OutputItemType="Analyzer" ReferenceOutputAssembly="false"`, and keep the calibration project in CI.
4. Wire the four scripts into CI. The order matters: scanner is informational, the other three are gates.
5. Add the **negative-space boundaries** for your code. This is the single most valuable per-repo step — the rest of the council does nothing if you have not declared what your trust boundaries are.

## Workflow per sweep

1. Run `scan-bug-council-candidates.sh` to refresh the candidate inventory.
2. Pick one scan section. Open a new dated sweep register in `docs/dev/bug-council-sweep-<YYYY-MM-DD>-<topic>.md`.
3. Convert the section into a table; add severity/confidence per `bug-council-severity-schema.md`.
4. For each row, classify as `Accepted`, `Existing guard`, `False positive`, or `Out of scope`.
5. For each `Accepted`, fix it, run the sibling search, write a behavior test.
6. Add a `require_pattern` and behavior test to the remediation baseline.
7. Update sweep counts; both `check-council-sweep-counts.sh` and `check-remediation-baseline.sh` must stay green.
8. Close the register only when every row is non-`Unclassified`.

## Why "council of experts"

Each scan class plus each Roslyn analyzer plus each negative-space boundary is one expert lens. Together they cover what a single linter or a single reviewer cannot. The council process is the discipline that keeps the lenses honest: every finding is named, tiered, ledgered, fixed, sibling-swept, and pinned by a behavior test. The cost is one ratchet per finding; the payoff is that the codebase ratchets only forward.

## License

MIT. See `LICENSE`.
