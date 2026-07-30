# apmw — PRD Generation Handoff

**Date**: 2026-07-29
**Session**: Generating a greenfield PRD for `apmw` (All Package Manager Wrapper) inside the `levonk-packages` repo
**Status**: In progress — context gathering complete, clarifying questions answered, PRD file **not yet written**. Session crashed before the PRD was generated.

## Current State

### ✅ Completed

- **Workflow invoked**: `~/p/gh/levonk/skills-src/build/current/workflows/software-dev/greenfield/greenfield-prd.md` (the greenfield-prd workflow). Read in full — its template structure, naming convention (`internal-docs/feature/YYYY/MM/{slug}/feat-YYYYMMDDHHmm-{slug}.md`), and STOP conditions are understood.
- **Reference files inspected** (concepts the user wants incorporated into the PRD):
  - `~/p/gh/levonk/dotfiles/home/current/dot_local/bin/executable_skill-install.sh` — two-phase security scan (scan all → install all), scanner plugin contract, `--on-risk` modes, telemetry-off for third-party skills, shallow-clone-then-scan pattern, LLM auto-enable via API keys.
  - `~/p/gh/levonk/dotfiles/home/current/.chezmoitemplates/config/npm/npmrc.tmpl` — `engine-strict`, `frozen-lockfile`, `save-exact`, `audit`/`audit-level=high`, `provenance=true`, per-manager node-linker selection, XDG paths. The "minimum release age / audit before install" posture the user wants.
  - `~/p/gh/levonk/skills-src/build/current/includes/cli-tool-discovery.md` — devbox/mise/flox/direnv/nix wrapper detection, 30+ PATH locations, `--runner <ecosystem>` (single source of truth for `uvx` / `pnpm dlx` / `cargo binstall` / `go install`), repo-root `bin/` as last-resort (security-ordered) search.
  - `~/p/gh/levonk/skills-src/src/current/knowledge/software-architecture-essentials/indexed-ast-tools.md` — CodeGraph / Graphify / GitNexus decision tree, tree-sitter + content-addressed cache + MCP + `.gitignore` hygiene, "index once, query many".
  - `~/p/gh/levonk/skills-src/build/current/skills/software-dev/project-{detection,adopter,configuration}/` — confirmed these three skills exist (project-detection, project-adopter, project-configuration). Did NOT read their SKILL.md bodies yet — the PRD should reference them as the detection engine.
- **Rust practices bundle read in full** (`~/p/gh/levonk/skills-src/build/current/knowledge/rust-development-practices/`): 13 files covering project-structure, cargo-config, async-patterns (tokio "full"), error-handling (thiserror + anyhow, no panics in libs), cli-tool-standards (daemon mode + AXI agent mode), container-support (multi-stage Dockerfile + HEALTHCHECK), security-auditing (cargo audit, secrecy, zeroize), quality-gates (8 validation criteria), testing-strategy, serde, rustfmt/clippy. **This is the canonical best-practices source the PRD's "Technical Considerations" and "Service Model" sections must follow.**
- **CLI standards ADR read in full**: `~/p/gh/levonk/levonk-base-boilerplate/internal-docs/adr/adr-20260607001-cli-tool-standards.md` (v4.0.0, accepted). Defines the daemon contract the service model must implement: `--daemon`/`--no-daemon` flags, auto-spawn on first async op, `--list-jobs` (returns job ID immediately), `--cancel-job <id>`, platform-fallback to synchronous with clear error. Also defines AXI agent mode (TOON output, minimal schemas, content truncation, pre-computed aggregates, definitive empty states, structured errors on stdout, no interactive prompts, content-first no-args, contextual disclosure, session integrations for Claude Code/Codex/OpenCode, installable Agent Skill as secondary).
- **Existing apmw repo investigated** (via subagent): `github.com/levonk/apmw` does **NOT** exist. No local clone under `~/p/gh/levonk/` or `~/p/gh/lrepo52/`. The only "apmw" on the internet is an unrelated AUR package (apt→pacman translator by `mineleng@aur`). **The name `apmw` is free for levonk to claim on GitHub** but will collide on AUR — note in PRD's Risk Assessment.
- **Existing design docs found** (in the Obsidian vault, **not** in any git repo):
  - `~/Documents/2ndbrain/2ndbrain/Work/01 OandO/Self Improvement/Want To Build/Digital/All Package Manager Wrapper/APMW Tool Idea.md` — original concept (TS + ECM packaged, 3 features: detect / map commands / adopt richer command sets).
  - `~/Documents/2ndbrain/2ndbrain/Work/01 OandO/Self Improvement/Want To Build/Digital/All Package Manager Wrapper/All Package Manager Wrapper Tool Landscape.md` — **38KB, highly valuable**: Table 1 (project-detection attributes for npm/yarn/pnpm/pip/poetry/pipenv/pdm/conda/uv/maven/gradle/sbt/go/cargo/flutter/dart/dotnet/xcode/cocoapods/carthage/spm/cmake/ant) and Table 2 (apmw command → per-package-manager command mapping with 200+ footnoted references). **This research is salvageable and should be referenced (not duplicated) by the PRD.**
- **Clarifying questions answered** by the user:
  - **Name**: `apmw` (All Package Manager Wrapper). User confirmed despite AUR collision.
  - **Release channel**: **Multi-ecosystem** — generate npm/pnpm, PyPI (uv), brew, nix, devbox, apt, winget, apk, deb, rpm from a single source (mirrors the `levonk-packages/packaging/` generator pattern).
  - **MVP scope**: **Full vision** — detect + install + scan + historyless-clone + AST-index + background agents + MCP/Skills/hooks + AI "docs location" notification + status CLI. Not a trimmed MVP.
  - **Service model**: User pointed at the rust-development-practices bundle and ADR-20260607001 instead of picking an option. → **Daemon + CLI per the ADR**: long-running Rust daemon (tokio) for background clone/scan/index jobs, thin CLI over a local socket, `--daemon`/`--no-daemon`/`--list-jobs`/`--cancel-job`, auto-spawn, platform fallback to synchronous.

### ❌ Blocking Issues

1. **PRD file not yet created.** The next session must write `internal-docs/feature/2026/07/apmw/feat-<timestamp>-apmw.md` inside `~/p/gh/levonk/levonk-packages/` using the greenfield-prd template, inlining all the gathered context into the "Current State" section.
2. **`project-{detection,adopter,configuration}` SKILL.md bodies not read.** The PRD should reference these as the detection/configuration engine apmw delegates to. Read them before finalizing the "Technical Considerations" section so the PRD doesn't contradict their actual behavior.
3. **`levonk-packages/packaging/` generators not read.** The PRD's "Multi-ecosystem release" section claims apmw will mirror this pattern — verify the generators actually exist and what they produce before committing to that approach in the PRD.

## Project Overview

### Objective

Design and specify (PRD only — **no implementation**) a Rust-based tool called **`apmw`** (All Package Manager Wrapper) that abstracts every package installer the user uses into one intelligent surface. The tool must, depending on project type (node_modules / cargo / brew / devbox / nix / npmjs.org / python upstream / apt / winget / etc.):

- Detect the correct package manager for the current project (delegating to the `project-detection` / `project-adopter` / `project-configuration` skills' logic).
- Install a tool or add a dependency with **install-on-use** semantics, running through devbox + rtk when there are no impossible barriers.
- Map ecosystems: `pip → uv`, `npm/yarn/bun/yarn2 → pnpm`, `uvx → pnpm dlx` (and the canonical ad-hoc runner per ecosystem via `cli-tool-discovery.sh --runner`).
- Scan common PATH destinations to see if a tool is already installed before installing.
- Optionally suggest better alternatives for the current use case.
- Install missing tools itself when needed.
- Resolve versions intelligently: pinned version if locked; latest version compatible with the engine in use (e.g. node version, mobile API tag); latest if unspecified; latest minor if only a major is specified.
- Create a **historyless, branchless, tagless** clone of any package, with the indexed-AST search tools loaded and indexes created (CodeGraph/Graphify/GitNexus per the indexed-ast-tools decision tree). Add a local `.gitignore` so indexes, `devbox.json`, and `AGENTS.md` don't get pushed upstream.
- Run security scanning **before** install (two-phase: scan all → install all), with the option to update security databases first so the latest advisories are used. Telemetry off for third-party packages; on (or neutral) for levonk-owned.
- Keep an audit log in `${XDG_CACHE_HOME:-$HOME/.cache}/apmw/` recording: when, what was requested, what was done, whether the terminal was login/interactive, the caller program (if any), and which tools were used to install/run.
- Run as a **Rust service** with background agents doing clone/scan/index in the background; the CLI reports status of clone / security-scan / install / indexing.
- Notify the user's AI agent where to find the docs for an installed package.
- Expose **AI agent coding hooks, an MCP, and Skills** that force AI agents through apmw's install-on-use hook for adding dependencies / running tools.
- Follow the rust-development-practices bundle and ADR-20260607001 (daemon mode + AXI agent mode) throughout.
- Ship as a **generic multi-ecosystem release** (npm/pnpm, PyPI/uv, brew, nix, devbox, apt, winget, apk, deb, rpm) from one source.

### Current Status

PRD-generation workflow is at **step 4 (Generate the PRD)** — context is gathered, clarifying questions are answered, the next action is to synthesize everything into the PRD file. The workflow's step 3 (Derive Context) was done inline above; step 7 (Generate Task Files) comes after the user approves the PRD.

## Key Decisions Made

- **Name**: `apmw` (All Package Manager Wrapper). Accepted AUR collision risk; documented in Risk Assessment.
- **Language/runtime**: Rust, per the rust-development-practices bundle. Tokio "full" for async. Daemon + thin CLI over a local socket.
- **Service model**: Daemon + CLI per ADR-20260607001 §13 (`--daemon`/`--no-daemon`, auto-spawn, `--list-jobs`, `--cancel-job`, platform fallback). NOT CLI+spawned-workers, NOT systemd/launchd.
- **Agent mode**: AXI is the **default** (ADR §36–45): TOON on stdout, minimal schemas, content truncation, pre-computed aggregates, definitive empty states, structured errors on stdout, no interactive prompts, content-first no-args, contextual disclosure, session integrations (Claude Code/Codex/OpenCode), installable Agent Skill as secondary.
- **Release**: Multi-ecosystem from one source, mirroring `levonk-packages/packaging/` generators.
- **Scope**: Full vision (not a trimmed MVP) — the user explicitly chose "Full vision".
- **Security posture**: Two-phase scan-all-then-install-all (from `executable_skill-install.sh`); `--on-risk` modes; telemetry off for third-party; security DB refresh before scan; `audit-level=high`, `engine-strict`, `frozen-lockfile`, `save-exact`, `provenance` (from `npmrc.tmpl`).
- **Historyless clone**: `--depth 1 --single-branch --no-tags` shallow clone; local `.gitignore` for indexes / `devbox.json` / `AGENTS.md`.
- **AST indexing**: Delegate tool choice to the indexed-ast-tools decision tree (CodeGraph default for single-project zero-maintenance + dynamic dispatch; Graphify for multimodal; GitNexus for multi-repo).
- **Audit log location**: `${XDG_CACHE_HOME:-$HOME/.cache}/apmw/` (NOT `~/.apmw/`).
- **PRD output location**: `~/p/gh/levonk/levonk-packages/internal-docs/feature/2026/07/apmw/feat-<timestamp>-apmw.md`.

## Technical Context

### Stack/Tools

- **Rust** (edition 2021, rust-version 1.70+) — per `cargo-configuration.md`.
- **tokio** 1.35 ("full") — async runtime — per `async-patterns.md`.
- **thiserror** + **anyhow** — error handling — per `error-handling.md`.
- **serde** 1.0 (derive) + optional TOML — per `serde-serialization.md`.
- **ratatui** (dashboard TUI) or **cursive** (interactive CLI) — per ADR §9 / cli-tool-standards.
- **indicatif** — progress bars — per ADR §12.
- **secrecy** 0.8 + **zeroize** 1.7 — secret handling — per `security-auditing.md`.
- **assert_cmd**, **predicates**, **serial_test**, **criterion**, **proptest** — testing — per `testing-strategy.md`.
- Multi-stage Dockerfile (rust:1.75-slim builder → debian:bookworm-slim runtime, non-root `rustuser`, HEALTHCHECK) — per `container-support.md`.
- Detection delegates to: `project-detection`, `project-adopter`, `project-configuration` skills.
- Ad-hoc runner resolution delegates to: `cli-tool-discovery.sh --runner <ecosystem>`.
- AST indexing delegates to: CodeGraph / Graphify / GitNexus (per `indexed-ast-tools.md`).

### Important Files (read this session — do not re-read)

- `~/p/gh/levonk/skills-src/build/current/workflows/software-dev/greenfield/greenfield-prd.md` — the workflow driving PRD generation; contains the exact template structure to fill in.
- `~/p/gh/levonk/levonk-base-boilerplate/internal-docs/adr/adr-20260607001-cli-tool-standards.md` — daemon + AXI agent-mode contract (v4.0.0, accepted).
- `~/p/gh/levonk/skills-src/build/current/knowledge/rust-development-practices/` — 13 files; the canonical Rust best-practices source.
- `~/p/gh/levonk/dotfiles/home/current/dot_local/bin/executable_skill-install.sh` — two-phase scan pattern, scanner plugin contract, telemetry policy.
- `~/p/gh/levonk/dotfiles/home/current/.chezmoitemplates/config/npm/npmrc.tmpl` — security/lockfile posture to mirror.
- `~/p/gh/levonk/skills-src/build/current/includes/cli-tool-discovery.md` — wrapper detection + `--runner` contract.
- `~/p/gh/levonk/skills-src/src/current/knowledge/software-architecture-essentials/indexed-ast-tools.md` — AST tool decision tree.

### Important Files (NOT yet read — read before finalizing the PRD)

- `~/p/gh/levonk/skills-src/build/current/skills/software-dev/project-detection/SKILL.md`
- `~/p/gh/levonk/skills-src/build/current/skills/software-dev/project-adopter/SKILL.md`
- `~/p/gh/levonk/skills-src/build/current/skills/software-dev/project-configuration/SKILL.md`
- `~/p/gh/levonk/levonk-packages/packaging/*/generate-*.sh` (alpine/debian/fedora/arch/brew/mise) — verify the multi-ecosystem release pattern the PRD will claim to mirror.
- `~/Documents/2ndbrain/2ndbrain/Work/01 OandO/Self Improvement/Want To Build/Digital/All Package Manager Wrapper/All Package Manager Wrapper Tool Landscape.md` — the 38KB research tables (project-detection attributes + command mapping). **Reference this from the PRD; do not duplicate.**

### Environment Notes

- Working repo: `~/p/gh/levonk/levonk-packages/` (Nix flake + devbox + just). Use `devbox shell` / `devbox run --` for any commands.
- The PRD file goes under `internal-docs/feature/2026/07/apmw/` — create the directory tree if missing.
- Filename timestamp: use `date +%Y%m%d%H%M` at write time.

## Next Steps (Priority Order)

1. **Read the three unread skill files** (`project-detection`, `project-adopter`, `project-configuration` SKILL.md) and the `levonk-packages/packaging/` generators — confirm the PRD's claims about delegation and multi-ecosystem release match reality. (Parallelizable — 4 independent reads.)
2. **Generate the PRD** at `~/p/gh/levonk/levonk-packages/internal-docs/feature/2026/07/apmw/feat-<timestamp>-apmw.md` using the greenfield-prd template. Inline ALL gathered context into the "Current State" section (file paths, code excerpts, conventions, the daemon/AXI contract, the rust practices bundle, the indexed-ast-tools decision tree, the cli-tool-discovery runner contract, the skill-install two-phase scan pattern, the npmrc security posture). Reference — do not duplicate — the 2ndbrain research tables.
3. **Wait for user feedback** on the PRD (workflow step 6). Do not proceed to task generation until the user says go.
4. **Generate task files** via `~/p/gh/levonk/skills-src/build/current/workflows/software-dev/tasks/tasks-from-prod.md` (workflow step 7) after approval.

## Success Criteria

- ✅ PRD file exists at `~/p/gh/levonk/levonk-packages/internal-docs/feature/2026/07/apmw/feat-<timestamp>-apmw.md`.
- ✅ PRD follows the greenfield-prd template structure exactly (Introduction/Overview, Goals, User Stories, Functional Requirements, Non-Functional Requirements, Current State with inlined context, Technical Considerations, Verification Approach, Success Criteria, Out of Scope, Risk Assessment, Success Metrics, Open Questions, Dependencies, Timeline/Milestones, Maintenance Notes, STOP Conditions).
- ✅ PRD's "Current State" section inlines real file paths and excerpts (not "as discussed").
- ✅ PRD's service-model section cites ADR-20260607001 §13 (daemon) and §36–45 (AXI) and the rust-development-practices bundle.
- ✅ PRD's release section mirrors the actual `levonk-packages/packaging/` generators (verified, not assumed).
- ✅ PRD references (not duplicates) the 2ndbrain APMW research tables.
- ✅ PRD's Risk Assessment notes the AUR `apmw` name collision.
- ✅ User confirms the PRD before any task files are generated.

## Open Questions/Blockers

- **Does `levonk-packages` actually want this PRD inside its own tree, or should `apmw` be a new standalone repo?** The user said "create PRD here" (in levonk-packages) but apmw is a new tool, not a levonk-packages package. Impact: PRD location and eventual repo location. → **Assumed levonk-packages for now per the user's explicit instruction; flag in PRD's Open Questions.**
- **AUR name collision**: the unrelated `apmw` AUR package (apt→pacman) will confuse Arch users. Accept the collision, rename, or namespace? → **User accepted the name; document in Risk Assessment.**
- **MCP/Skills/hooks "force" semantics**: "force AI agents through apmw's install-on-use hook" — is this a hard intercept (shell wrapper / PATH shim) or a soft convention (Skill that agents load)? Impact: PRD's Functional Requirements wording. → **PRD should specify both: hard intercept via PATH shim + soft via Skill/MCP, and let the user pick during review.**

## Do Not

- **Do NOT implement apmw.** This is PRD-only. The greenfield-prd workflow's guardrail: "Do NOT implement the feature or write code; only produce the PRD."
- **Do NOT duplicate the 2ndbrain research tables** in the PRD — reference them by path.
- **Do NOT edit the built handoff skill files** in `skills-src/build/current/` — they are generated. If the `last-used` field needs updating, edit `skills-src/src/current/skills/ai/handoff/SKILL.md.tmpl` and rebuild.
- **Do NOT pick a trimmed MVP.** The user explicitly chose "Full vision".
- **Do NOT use `npm`/`brew`/`apt`/`pip install --user`/`pipx`/`cargo install`/`go install` on the host** for apmw's own dependencies — use devbox per the devbox-remediation include.
- **Do NOT skip the daemon contract** — the service model is daemon + CLI per the ADR, not CLI + spawned workers.
- **Do NOT assume the `project-{detection,adopter,configuration}` skills' behavior** — read them before the PRD's Technical Considerations section is finalized.
- **Do NOT proceed to task-file generation** (workflow step 7) until the user approves the PRD.

## Suggested Skills

- **handoff** (this skill) — to capture state again if the next session crashes before the PRD is written.
- **greenfield-prd** (the workflow at `skills-src/build/current/workflows/software-dev/greenfield/greenfield-prd.md`) — already in progress; the next session continues from its step 4.
- **agent-file-upsert** — after the PRD is approved and apmw becomes a real repo, generate its `AGENTS.md` from the rust-development-practices bundle + ADR-20260607001.
- **readme-upsert** — after the PRD is approved, generate apmw's `README.md` for human developers.
- **git-repository-management** — once the PRD and any supporting docs are written, organize and commit them.

## Additional Context

- **Project**: `apmw` (All Package Manager Wrapper) — greenfield Rust tool.
- **ADR compliance**: must comply with `adr-20260607001-cli-tool-standards.md` (daemon §13, AXI §36–45) and follow the `rust-development-practices` knowledge bundle.
- **Git workflow**: PRD goes in `levonk-packages` per the user's instruction; commit the PRD + this handoff together once the PRD is approved.
- **Naming convention**: PRD filename is `feat-YYYYMMDDHHmm-apmw.md` under `internal-docs/feature/2026/07/apmw/` (per the greenfield-prd workflow's date-embedded naming convention).
- **Self-update note**: the handoff skill's `last-used` field was not updated this session because the source `.tmpl` lives in `skills-src/src/current/skills/ai/handoff/` (a separate repo from the working tree) and the user's request was to produce the handoff, not maintain the skill. Update `last-used` on the source when next editing `skills-src`.
