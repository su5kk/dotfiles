---
name: create-pr-spec
description: Create a concise implementation spec for one PR from a supplied checklist, feature spec, or design doc. Use when asked to write prN.md or a PR implementation brief with code references and ASCII data flow. Not for a GitHub PR description.
---

# Create PR spec

Write an implementation spec, not implementation code or a PR description.

## Workflow

1. Read the input and any prerequisite PR specs. If the selected PR is unclear, ask which PR to specify.
2. Trace the relevant code from input to side effects. Check callers, existing helpers, contracts, validation, persistence, and feature switches where relevant.
3. Keep the selected PR's scope and dependencies explicit. Do not pull in work assigned to other PRs.
4. Describe exact changes: files, functions, payload/field mappings, state transitions, deduplication, failure behavior, and config. Include only what this PR needs.
5. Link relevant code. Include short excerpts when they clarify a contract or a non-obvious change; omit obvious boilerplate. Label proposed code so readers cannot mistake it for existing code.
6. Include a fenced ASCII diagram using real component names. Show the data flow and relevant failure or no-op branches. No Mermaid.
7. List concrete acceptance checks and targeted verification commands. Include rollout steps only when relevant.
8. Ask one focused question if an unresolved decision affects behavior. Do not guess code facts or turn assumptions into requirements.
9. Use the requested output path. Otherwise write `pr<N>.md` beside the checklist or design doc when the PR number is known, or `pr-spec.md` when it is not. For pasted input use `.scratch/<feature>/`. Leave the input unchanged.

## Format

Use only the sections needed. Replace placeholders with actual names and paths.

````markdown
# PR <N>: <outcome>

- Depends on: <none or required PRs>.
- In scope: <specific change>.
- Out of scope: <important exclusions>.

## Data flow

```text
[Source] -> [Handler] -> [Validator] -> [Service] -> [Store/output]
                            |
                            +-- invalid -> [Failure path]
```

## Implementation

- [File.ts](relative/path/File.ts): change `<function>` to <exact behavior>.
- <Required contract or field mapping>.
- <Relevant state, error, deduplication, or config rule>.

## Checks

- <Scenario> -> <observable result>.
- `<Targeted verification command>`.
````

- Bullets, tables, diagrams, and small code excerpts only. No narrative paragraphs, essays, filler, or repeated background.
- Keep bullets short. Split dense requirements rather than writing a paragraph inside a bullet.
- Mark new files as planned; do not link to nonexistent files as if they already exist.
- Put code links next to the changes they explain. Add an appendix only if it helps.
- Before finishing, compare the spec with the selected todos, verify links/excerpts against source, and check the diagram against the actual flow. Reply with the output path.
