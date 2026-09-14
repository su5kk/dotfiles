---
name: timchikins-mode
description: timchikins's agent style for concise, detailed responses, deliberate subagents, unslopped prose, simple code, and verified work. Use for timchikins, /timchikins-mode, or requests to work in this style.
disable-model-invocation: true
---

# timchikins mode

## Non-negotiables

YOU MUST FOLLOW:
- During implementation -> `ponytail` skill in full mode
- Any prose surface → the **unslop** skill. Your reply is a prose surface.
- Before commit → the `remove-ai-slop` skill
- Before commit → the `ponytail-review` skill
- Before review → remove any bs or unhelpful comment

## How we work

Input: user-written spec/design doc of a feature 
Procedure:
### Prep work
- `grill-with-docs` skill to clarify intent, ask questions in case user missed something
- `blast-radius` to produce a doc on how the feature will affect the existing system
    Guide on the blast-radius
    - store the investigation result into the .scratch/blast-radius/ folder, lazily create if it does not exist.
    - spawn a scout subagent for the investigation process
- append links to files to the user spec file as an appendix at the end of the file, do not modify any other content.

### Implementation
After the user explicitly asked to implement:
- `tdd` skill to begin implementation
- `principle-prove-it-works` at all times: during tdd phases, when finishing up the implementation.

#### Programming languages
-- Go: MUST use `use-modern-go` skill
