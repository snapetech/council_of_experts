# Council Roslyn Analyzers — C# template

A minimal Roslyn analyzer project demonstrating the **TaintToAllocation** lens (`CSL0001`). Copy this directory into `analyzers/` in your repo and rename the project as you like. Treat it as a beachhead: production councils should broaden the source/sink lists, add batches of distinct lenses such as loop-bound, stream-position, file-path, timeout, endpoint, enum/status, and slice-bound sinks, and add calibration tests before trusting zero-finding runs.

## What CSL0001 catches

Allocations whose size derives (intra-procedurally) from a known untrusted-input reader without passing through a sanctioned validator. The default lens is wired to a wire reader named `MessageReader` with methods `ReadInteger` / `ReadLong`. To adapt:

1. Open `CouncilAnalyzers/TaintToAllocationAnalyzer.cs`.
2. Edit `TaintedReaderTypeNames` to your reader's simple type name.
3. Edit `TaintedReaderMethodNames` to your reader's untrusted-source methods.
4. Edit `SanctionedValidatorMethodNames` to the validators that sanitize a tainted value.
5. Update tests in `CouncilAnalyzers.Tests/TaintToAllocationAnalyzerTests.cs` accordingly.

## Wiring

In your runtime project's `.csproj`:

```xml
<ItemGroup>
  <ProjectReference Include="..\analyzers\CouncilAnalyzers\CouncilAnalyzers.csproj"
                    OutputItemType="Analyzer"
                    ReferenceOutputAssembly="false"
                    PrivateAssets="all" />
</ItemGroup>
```

**Important**: keep the analyzer project outside your runtime's `src/` directory, otherwise the SDK's default `Compile` glob will try to compile the analyzer sources into your runtime build.

## Running tests

```sh
dotnet test analyzers/CouncilAnalyzers.Tests/CouncilAnalyzers.Tests.csproj
```

The tests use direct Roslyn compilation rather than the heavier `Microsoft.CodeAnalysis.Testing` framework, to keep the test project small.

Add a separate calibration test project once the first lens is wired. It should compile intentionally bad snippets that must produce every shipped `CSL00xx` diagnostic, plus intentionally good snippets that route the same values through sanctioned validators and must stay silent. This answers the common "did we find zero bugs because the code is clean, or because the lens is too narrow?" question.

## Adding more lenses

See `docs/dev/bug-council-roslyn-analyzers.md` (template) for the council's design rules: intra-procedural by default, enumerated allowlists, deterministic, calibrated, and every lens must earn its keep over a sweep cycle.
