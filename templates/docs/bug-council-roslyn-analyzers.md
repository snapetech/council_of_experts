# Council Roslyn Analyzers — TEMPLATE

For .NET projects only. Copy into `docs/dev/bug-council-roslyn-analyzers.md` and adapt the analyzer list to the lenses you ship.

The council ships a small Roslyn analyzer project that runs against the runtime build and adds semantic-aware lenses to the council. Analyzers complement the regex scanner: where the scanner asks "is there a line that looks like X," analyzers ask "does the dataflow into Y satisfy invariant Z."

## Layout

- `analyzers/CouncilAnalyzers/CouncilAnalyzers.csproj` — `netstandard2.0`, references `Microsoft.CodeAnalysis.CSharp`. Not packaged. **Lives outside `src/`** so the runtime project's default `Compile` glob does not pick up its sources.
- `analyzers/CouncilAnalyzers/*Analyzer.cs` — one file per lens.
- `analyzers/CouncilAnalyzers.Tests/` — analyzer unit tests using direct Roslyn compilation (lighter than `Microsoft.CodeAnalysis.Testing`).
- The runtime `.csproj` references the analyzer with `OutputItemType="Analyzer" ReferenceOutputAssembly="false"`.

## Lens table

| ID | Name | Council severity | Description |
| --- | --- | --- | --- |
| CSL0001 | TaintToAllocation | High | Network-derived allocation size without a sanctioned validator. |

## Adding a new lens

1. Pick an ID in the `CSL00xx` range.
2. Add the analyzer file to `analyzers/CouncilAnalyzers/`.
3. Add positive and negative tests.
4. Update the lens table.
5. Add a `require_pattern` to `scripts/check-remediation-baseline.sh` asserting the diagnostic ID is in source.
6. Build the runtime and confirm the lens does not fire on existing code. If it does, decide: accept the finding into a sweep register, or refine the lens.

## Design rules

- **Intra-procedural by default.** Inter-procedural taint produces false positives.
- **Sanctioned validators are an enumerated allowlist, not a heuristic.** Adding a name is a council-visible decision.
- **Lenses must be deterministic.** Roslyn calls them on every build.
- **Every lens earns its keep.** A lens that has never fired on a real bug after a full sweep cycle is a candidate for removal.
