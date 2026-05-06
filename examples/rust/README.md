# Example: Rust project import

The slskR project (a Rust Soulseek client) runs the council's bash gates over its `crates/` workspace. The templates below adapt to a Rust ecosystem.

## Scanner adaptations

Replace the C# patterns in `scan-bug-council-candidates.sh` with Rust-flavored equivalents:

```bash
scan "Protocol count/length candidates (Rust)" \
  'read_u32_le\(\)\? as usize|read_u16_le\(\)\? as usize|Vec::with_capacity\(|resize\(|read_chunk\(' \
  crates

scan "Task / cancellation lifecycle candidates (Rust)" \
  'tokio::spawn|spawn\(|abort\(|select!|timeout\(|sleep\(|interval\(|mpsc|broadcast|oneshot' \
  crates

scan "Unsafe blocks" \
  '\bunsafe\s*\{|\bunsafe\s+fn\b' \
  crates
```

## Semantic analyzer

There is no direct Roslyn equivalent for Rust. For higher-severity lenses, two paths:

1. **Clippy custom lints** via the `dylint` framework (https://github.com/trailofbits/dylint). Same shape as the Roslyn analyzer template: one lens per file, intra-procedural taint, enumerated allowlists.
2. **`cargo geiger`** for the unsafe-code lens (cheap and well-defined).

## Negative-space adaptation

Rust's type system catches many of the boundary-without-validator failures the .NET negative-space gate watches for. The negative-space gate is still useful for:

- FFI boundaries (`extern "C"` functions).
- Network-deserialization entry points (where a `Vec<u8>` becomes structured input).
- Custom `unsafe` invariants that the type system cannot express.
