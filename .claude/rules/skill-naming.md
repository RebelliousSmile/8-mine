---
description: Naming convention for project skills. Apply when creating or naming any skill in this project.
---

# Skill naming

## Program-prefixed skills

Skills that write for or interact with a specific program must be prefixed with that program's name.

- `dialogic-draft` — produces `.dtl` timelines for Dialogic
- `dialogic-review` — reviews `.dtl` timelines via personas
- `godot-export` — triggers a Godot export pipeline
- `gut-run` — runs GUT tests

## Unprefixed skills

Skills that manage project-level workflows without writing for a specific program do not take a prefix.

- `bank` — manages `bank.yml` resource registry
- `plan`, `review`, `deploy` — generic activity domains

## Anti-patterns

- `draft` without prefix when it produces Dialogic-specific output → use `dialogic-draft`
- `godot-review` when the review is not Godot-specific → use `review`
- Generic names like `write`, `generate` when the output is program-specific
