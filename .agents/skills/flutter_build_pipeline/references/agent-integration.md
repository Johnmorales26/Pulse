# Agent integration notes

Use the same bash entrypoint for any coding agent:

```bash
bash scripts/run_flutter_pipeline.sh /path/to/flutter/project
```

## Gemini CLI prompt pattern

```text
Run scripts/run_flutter_pipeline.sh from the Flutter project root. If it succeeds, print exactly "✅ Success". If it fails, print only the markdown error report.
```

## Claude Code prompt pattern

```text
Execute scripts/run_flutter_pipeline.sh in the repository root. Do not run flutter run. Return exactly "✅ Success" on success; otherwise return only the generated markdown error report.
```

## Output expectations

- Success: exactly `✅ Success`
- Failure: markdown report beginning with `# Flutter pipeline error report`
