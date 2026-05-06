# Example: TypeScript / JavaScript project import

The council adapts cleanly to TS/JS codebases, with most of the per-finding value coming from the negative-space gate (declaring auth/storage boundaries explicitly) rather than the regex scanner (most TS projects already have eslint).

## Scanner adaptations

```bash
scan "DOM/HTML injection candidates (TS/JS)" \
  'innerHTML\s*=|dangerouslySetInnerHTML|document\.write\(|eval\(|new Function\(' \
  src

scan "Auth/storage/CORS leakage candidates (TS/JS)" \
  'localStorage|window\.open|target="_blank"|Authorization: Bearer|Access-Control-Allow-Origin: \*' \
  src

scan "Side-channel candidates" \
  'crypto\.subtle|atob\(|btoa\(|Math\.random\(\)' \
  src
```

## Semantic analyzer

Use **eslint custom rules** the same way .NET projects use Roslyn analyzers. The `@typescript-eslint/utils` package exposes the AST + type-checker; a TaintToAllocation-equivalent here would be `untrusted-string-to-element-attribute`.

## Negative-space candidates

Boundaries unique to TS/JS that the negative-space gate is well-suited to lock down:

- Token storage: `sessionStorage` / `localStorage` access must funnel through one validator.
- `postMessage` listeners must validate `event.origin` before dispatch.
- API boundary modules: every `fetch` call must originate from `src/api/*`, not scattered across components.
