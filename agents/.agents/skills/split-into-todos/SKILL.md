---
name: split-into-todos
description: Split a supplied feature spec or design doc into a concise PR checklist with explicit dependencies. Use when asked to split work into PRs, plan a PR series, or create todos.md from a design.
---

# Split into todos

Create a document, not implementation code.

## Workflow

1. Read the supplied feature or design doc and its references. Check relevant code for existing support and ownership boundaries.
2. Use the fewest PRs that remain reviewable and safe to merge. Do not force a sequence when PRs are independent.
3. State each PR's dependencies explicitly: `none` or the required PR numbers. Keep dependencies acyclic and list prerequisites first.
4. Outline each PR as unchecked todos. Start each todo with a concrete verb; keep it to one short line.
5. Keep tests and required validation/generation with the PR they verify. Separate deployment or activation only when the design needs it.
6. Preserve requirements, exclusions, contracts, and rollout constraints. Reuse existing functionality; do not invent extra work.
7. Ask one focused question if an unresolved decision changes the split. Look up code facts yourself.
8. Use the requested output path. Otherwise write `todos.md` beside the input file; for pasted input use `.scratch/<feature>/todos.md`. Leave the input unchanged.

## Format

```markdown
# <Feature> PRs

## PR 1: <outcome>

Depends on: none

- [ ] <Concrete implementation task>
- [ ] <Required tests or checks>

## PR 2: <outcome>

Depends on: <none or required PR numbers>

- [ ] <Concrete implementation task>
- [ ] <Required tests or checks>
```

- No essays, repeated context, or vague todos such as "handle edge cases".
- Add a short scope note only when it prevents a misunderstanding.
- References appendix is optional. Use it only for useful source links.
- Before finishing, check requirement coverage, dependency order, PR boundaries, and any links. Reply with the output path.
