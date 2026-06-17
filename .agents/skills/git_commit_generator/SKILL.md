---
name: git-commit-generator
description: generate a conventional commit message from modified project files and produce an activity summary that follows the established CHANGELOG.md style without editing the changelog file directly. use when chatgpt needs to inspect workspace changes, propose or return a one-line commit message, summarize completed changes in release-note style, or keep the commit and activity summary aligned after code changes.
---

# Generate commit message and activity summary

You are an expert software engineer.

Inspect the modified files in the current workspace to understand the change. Do not run git commands.

## Capability 1: Generate the commit message

Analyze the changed files and produce a conventional commit message that reflects the main change.

### Commit format

`[Emoji] [Keyword]: Description`

### Language rules

- Write the commit message in English.
- Use clear and concise wording.
- Use imperative tense.

### Allowed keywords

- feat
- fix
- refactor
- docs
- style
- test
- chore
- perf

### Emoji mapping

- feat → ✨
- fix → 🐛
- refactor → ♻️
- docs → 📝
- style → 🎨
- test → 🧪
- chore → 🔧
- perf → ⚡

### Formatting rules

- Maximum 72 characters.
- One line only.
- No period at the end.
- Follow the format strictly: `[Emoji] [Keyword]: Description`

### Commit guidelines

- Determine the most relevant keyword based on the dominant change.
- Prefer concise and descriptive messages.
- Ignore generated files such as:
  - `build/`
  - `.dart_tool/`
  - `*.g.dart`
  - `*.freezed.dart`
  - `*.lock`

When the user asks only for the commit message, return only the commit message with no explanation.

## Capability 2: Produce an activity summary using the `CHANGELOG.md` model

When the user asks for a summary of activities, release notes, or a commit plus summary, read the existing `CHANGELOG.md` in the workspace first and use it only as the formatting and style reference. Do not edit `CHANGELOG.md` unless the user explicitly asks for that in a separate request.

### Activity summary workflow

1. Read the current `CHANGELOG.md` in the workspace before writing the summary.
2. Infer the existing pattern from the file itself instead of inventing a new format.
3. Group the changes under the most appropriate category heading already used by the file.
4. Write bullets that describe user-visible or developer-relevant changes based on the modified files.
5. Keep wording concise, consistent, and action-focused.
6. Preserve markdown cleanliness in the response:
   - do not claim the file was edited
   - do not invent unrelated sections
   - do not duplicate bullets
   - keep blank lines and heading spacing consistent with the model

### Style rules for the activity summary

- Follow the exact heading style already present in `CHANGELOG.md`.
- Reuse existing section labels when they fit.
- If a new section is needed, match the same heading level and emoji style used in the file.
- Write the summary in English unless the existing changelog clearly uses another language.
- Keep each bullet short and specific.
- Prefer describing what changed in the codebase, not the implementation process.

### Output format for activity summaries

- Return a ready-to-copy markdown summary block.
- Include only the relevant category heading and bullet list unless the user explicitly asks for a full version block.
- Keep the summary aligned with the generated commit.

## Output behavior

- If the user asks only for a commit message, return only the commit message.
- If the user asks only for the activity summary, return only the markdown summary.
- If the user asks for both, return them in this order:
  1. `Commit:` followed by the one-line commit message
  2. `Summary:` followed by the markdown summary block
- Never say that `CHANGELOG.md` was updated unless the user explicitly requested a real file edit.
