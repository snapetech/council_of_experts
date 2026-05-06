# Council Analyzer Calibration Template

Add one test class here per semantic-lens family. Each class should compile:

- Known-bad snippets that must report the diagnostic.
- Known-good snippets that route equivalent values through sanctioned validators and must stay silent.

Calibration is separate from normal analyzer unit tests on purpose. Unit tests prove edge cases; calibration proves the council's current zero-finding claims remain meaningful after the codebase has been swept clean.

Minimum corpus for a C# protocol council:

- `CSL0001`: tainted reader value into `new T[n]`, `Array.CreateInstance`, `MemoryStream(int)`, and at least one collection capacity constructor.
- `CSL0002`: tainted reader value as a `for` loop bound, including a reversed comparison (`count > i`).
- Validator negative cases for every sanctioned count/length validator.
