# Example: .NET project import

Concrete worked example showing how the [slskNet.Runtime](https://github.com/snapetech/slskNet.Runtime) project imported the council. Use this as a reference for adapting the templates to your own repo.

## What that repo runs

```
scripts/
├── scan-bug-council-candidates.sh        # candidate scanner (noisy, informational)
├── check-council-sweep-counts.sh         # sweep-count drift gate
├── check-remediation-baseline.sh         # presence + behavior + secret gate
└── check-council-negative-space.sh       # boundary validator presence

docs/dev/
├── bug-council-phases.md                 # multi-phase upgrade tracker
├── bug-council-scan-registry.md          # the scan classes the council watches
├── bug-council-severity-schema.md        # severity & confidence tiers
├── bug-council-sibling-search.md         # sibling-search rule
├── bug-council-negative-space.md         # boundary -> validator declarations
├── bug-council-behavior-pinning.md       # text-gate + behavior-test pattern
├── bug-council-roslyn-analyzers.md       # Roslyn lens authoring
├── bug-burndown-ledger.md                # accepted findings (RT-### IDs)
└── bug-council-sweep-<date>-<topic>.md   # one register per sweep

analyzers/
└── Soulseek.CouncilAnalyzers/
    ├── Soulseek.CouncilAnalyzers.csproj  # netstandard2.0, runs as analyzer
    ├── ProtocolTaintAnalysis.cs          # shared taint classifier
    ├── TaintToAllocationAnalyzer.cs      # CSL0001
    └── TaintToLoopBoundAnalyzer.cs       # CSL0002

tests/
├── Soulseek.CouncilAnalyzers.Tests/       # positive/negative analyzer tests
└── Soulseek.CouncilAnalyzers.Calibration/ # known-bad/known-good mutation corpus
```

## Wiring into the runtime project

In `src/Soulseek.csproj`:

```xml
<ItemGroup>
  <ProjectReference Include="..\analyzers\Soulseek.CouncilAnalyzers\Soulseek.CouncilAnalyzers.csproj"
                    OutputItemType="Analyzer"
                    ReferenceOutputAssembly="false"
                    PrivateAssets="all" />
</ItemGroup>
```

The analyzer must live outside `src/` so the runtime's default `Compile` glob does not absorb its sources.

## CI hookup

```sh
bash scripts/check-remediation-baseline.sh
bash scripts/check-council-sweep-counts.sh
dotnet test --filter Category=Fuzz              # multi-seed + hostile corpus
dotnet test tests/Soulseek.CouncilAnalyzers.Tests
dotnet test tests/Soulseek.CouncilAnalyzers.Calibration
dotnet test                                   # the analyzer attaches automatically via the ProjectReference
```

## Reading the registers

A closed sweep register names the scan section, records the candidate count with a classification marker (e.g. `Mutable public byte arrays and array properties: 12/12 classified`), tables every candidate with severity/confidence, and lists the sibling search the closing agent ran. The remediation baseline asserts the marker is present so a re-run of the scanner that finds new candidates breaks the gate.

The calibration project is what makes a zero-finding semantic run meaningful: it proves the lens still fires on deliberate mutations even when current production code is clean.
