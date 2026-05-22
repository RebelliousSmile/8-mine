# AI-Driven Dev Docs

AIDD structures your AI coding assistant with skills, agents, rules, and a memory bank so it produces consistent, high-quality work, regardless of which AI tool you use (Claude Code, Cursor, Copilot, Codex, OpenCode).

- [What You Get](#what-you-get)
  - [Concepts](#concepts)
  - [Plugins](#plugins)
  - [Framework Structure](#framework-structure)
  - [Memory Block Lifecycle](#memory-block-lifecycle)
- [Installation](#installation)
- [Typical Workflow](#typical-workflow)
- [Optional: Async Automation](#optional-async-automation)
- [Validation Rules](#validation-rules)
- [References](#references)

---

## What You Get

A plugin marketplace of skills, agents, rules, templates, and a memory system. You invoke skills through your AI tool (slash command, MCP, or natural language trigger) and the AI follows structured workflows instead of guessing.

### Concepts

| Block     | Location                                          | What it does                                                                          |
| --------- | ------------------------------------------------- | ------------------------------------------------------------------------------------- |
| Memory    | `aidd_docs/memory/`                               | Project context the AI reads on every conversation                                    |
| Skills    | plugin `skills/` folders                          | Router-based workflows triggered by user phrases or slashes                           |
| Commands  | tool-specific commands dir (when supported)       | Plain slash commands (no router); used for shortcuts and simple flows                 |
| Agents    | plugin `agents/` folders                          | Specialized AI personas for focused tasks                                             |
| Rules     | tool-specific rules dir (see your AI tool docs)   | Coding standards the AI follows automatically                                         |
| Templates | plugin `assets/` folders                          | Scaffolding for new skills, rules, agents                                             |

### Plugins

Skills are grouped into plugins by domain. Install only the plugins you need.

| Plugin            | Purpose                                                                            | Example skills                                              |
| ----------------- | ---------------------------------------------------------------------------------- | ----------------------------------------------------------- |
| aidd-context      | Bootstrap, project init, context generation, mermaid diagrams, learn, discovery    | `02:project-init`, `03:context-generate`, `04:mermaid`      |
| aidd-refine       | Meta-cognition: brainstorm, challenge prior work, condensed communication mode     | `01:brainstorm`, `02:challenge`, `03:condense`              |
| aidd-pm           | Product management: ticket info, user stories, PRD, spec                           | `01:ticket-info`, `02:user-stories-create`, `03:prd`        |
| aidd-dev          | Code transformation: SDLC orchestrator, plan, implement, assert, audit, review     | `00:sdlc`, `01:plan`, `02:implement`, `05:review`, `06:test`|
| aidd-vcs          | VCS workflows: commit, pull/merge request, release tag, issue creation             | `01:commit`, `02:pull-request`, `04:issue-create`           |

### Framework Structure

AIDD installs alongside your code. Each AI tool's configuration directory holds the skills, agents, and rules it can load. Shared docs and memory live under `aidd_docs/`.

```text
8-mine/
├── .claude/                     # Claude Code: skills, agents, rules, hooks
├── CLAUDE.md                    # Claude Code main context file
├── aidd_docs/
│   ├── memory/                  # Project context (loaded each conversation)
│   │   ├── internal/            #   Architecture, design rules, état-prod, code-state
│   │   └── external/            #   Bible-jeu, overview, history, sessions
│   ├── aiw/                     # AI Workshop : bank.yml, personas, prompts, templates
│   ├── tasks/                   # Specs, plans, run summaries
│   ├── README.md                # This file
│   ├── GUIDELINES.md            # Developer operating guidelines
│   └── CONTRIBUTING.md          # How to add or modify skills, agents, rules
├── scenes/                      # Godot scenes (.tscn + .gd)
├── autoloads/                   # 14 autoloads (singletons GDScript)
├── docs/                        # Documentation technique du jeu
└── tests/                       # GUT 9.6.0
```

### Memory Block Lifecycle

The `CLAUDE.md` context file contains an `<aidd_project_memory>` block. It is:

1. **Seeded** the first time by `aidd-context:02:project-init`.
2. **Kept in sync** automatically by a session-start hook (`aidd-context/hooks/update_memory.js`) that scans `aidd_docs/memory/` and writes the current list of `.md` files into the block.

You never edit the block by hand. To change what the AI sees, add or remove files under `aidd_docs/memory/`; the hook picks them up at the next session.

---

## Installation

AIDD is delivered as a plugin marketplace. Pick what you need; do not install everything.

| Plugin       | Skills                                                                                                              |
| ------------ | ------------------------------------------------------------------------------------------------------------------- |
| aidd-context | 01-bootstrap, 02-project-init, 03-context-generate, 04-mermaid, 05-learn, 06-discovery                              |
| aidd-refine  | 01-brainstorm, 02-challenge, 03-condense                                                                            |
| aidd-dev     | 00-sdlc, 01-plan, 02-implement, 03-assert, 04-audit, 05-review, 06-test, 07-refactor, 08-debug, 09-for-sure         |
| aidd-vcs     | 01-commit, 02-pull-request, 03-release-tag, 04-issue-create                                                         |
| aidd-pm      | 01-ticket-info, 02-user-stories-create, 03-prd                                                                      |

## Typical Workflow

1. **Project init** (already done): `aidd-context:02:project-init` scaffolds `aidd_docs/` and the memory bank.
2. **Frame the request**: `aidd-refine:01:brainstorm` to clarify, `aidd-pm:01:ticket-info` to pull tracker data.
3. **Plan**: `aidd-dev:01:plan` produces the technical plan, component behavior model, or design-image extraction.
4. **Implement and assert**: `aidd-dev:02:implement` writes code against the plan; `aidd-dev:03:assert` verifies the result.
5. **Review**: `aidd-dev:05:review` for code and functional review; `aidd-refine:02:challenge` to stress-test the result.
6. **Test**: `aidd-dev:06:test` adds or runs tests and validates user journeys.
7. **Document and learn**: `aidd-context:04:mermaid` for diagrams; `aidd-context:05:learn` to feed insights back into the memory bank.
8. **Ship**: `aidd-vcs:01:commit`, `aidd-vcs:02:pull-request`.

---

## Validation Rules

- Skills must have an `## Available actions` table, `## Default flow`, `## Transversal rules`.
- Actions must contain only `## Inputs`, `## Outputs`, `## Process`, `## Test`.
- Tests must be observable: command, artifact check, or side effect.

---

## References

See [CONTRIBUTING.md](CONTRIBUTING.md) for adding or modifying skills, agents, and rules.

External:

- Anthropic, Prompt engineering overview: <https://docs.anthropic.com/en/docs/build-with-claude/prompt-engineering/overview>
- Anthropic, Claude Code memory: <https://docs.claude.com/en/docs/claude-code/memory>
