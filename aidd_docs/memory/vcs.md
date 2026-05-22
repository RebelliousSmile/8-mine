---
name: branch
description: Conventions VCS pour 8-MINE
scope: all
---

# Versioning Control System (VCS) Guidelines

- Main Branch: `main`
- Platform: `github`
- CLI: `gh`

## Branch Naming Convention

### Format

```text
type/short-description
```

### Types

| Prefix       | Usage                     |
| ------------ | ------------------------- |
| `feat/`      | Nouvelle fonctionnalité   |
| `fix/`       | Correction de bug         |
| `docs/`      | Documentation seule       |
| `refactor/`  | Refacto (sans feat/fix)   |
| `chore/`     | Build, config, deps       |
| `test/`      | Ajout/maj de tests        |
| `aiw/`       | Atelier narratif (AIW workshop) |

### Examples

```text
feat/threshold-mirror-90
fix/dialogic-bridge-null-arg
docs/update-architecture-autoloads
aiw/thread-emma-cousinage
```

## Commit Convention

### Format

```text
type(scope): description
```

Pour les commits AIW (narratif), le scope est typiquement un thread ou un PNJ : `AIW: thread #4 Emma cousinage`.

### Types

| Type       | Usage                        |
| ---------- | ---------------------------- |
| `feat`     | Nouvelle fonctionnalité      |
| `fix`      | Bug fix                      |
| `docs`     | Documentation seule          |
| `refactor` | Refacto (no feat/fix)        |
| `test`     | Tests                        |
| `chore`    | Build, config, deps          |
| `AIW`      | Travail narratif (workshop)  |

### Description rules

- Impératif présent : "ajoute" pas "ajouté"
- Minuscules, pas de point final
- 72 caractères max

### Examples

```text
feat(surveillance): ajoute seuil 90 sans couplage hardcode
fix(dialogic-bridge): handle null arg sur signal relation
AIW: thread #4 Emma cousinage + design-rule pool romance
```

## Rappels

- Préférer un **nouveau commit** plutôt qu'amender.
- Ne jamais skip les hooks (`--no-verify`) sans demande explicite.
- Ne pas pousser sur `main` directement si une feature touche les autoloads — passer par une branche `feat/` et tester localement.
