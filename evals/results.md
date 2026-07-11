# Evaluation Results (2026-07-10)

The final candidate completed the full Codex behavior matrix without a frozen
rubric regression or fatal failure. Claude Code produced four valid Fable 5
cells before the account session limit stopped the run; those cells all met
their required items, but they are not a complete Claude acceptance result.

## Frozen inputs

| Item | Value |
| --- | --- |
| Cases and rubric | `evals/cases.json` |
| Previous skill | Commit `903c7fe` |
| Final candidate payload hash | `be81229edbc4f5eec63c28f41bce1e3175791b04b491e3c197c4f52e9d8d6d40` |
| Godot engine evidence | `4.7-stable` at `5b4e0cb0fd279832bbdd69fed5354d4e5ad26f88` |
| Godot docs evidence | Branch `4.7` at `0585d03bea24497cf91f0969c81a187c892371c4` |

Every behavior cell used a fresh Git repository, the same fixture and official
evidence, the same prompt for its case, and the same tool surface within its
harness comparison. Review and diagnosis cases retained pre/post tree hashes,
status, transcripts, and final responses.

## Codex: complete

Environment: Codex CLI 0.144.0, `gpt-5.6-sol`, high reasoning effort,
ephemeral sessions, native web search disabled.

| Condition | Normal 4 | Review 3 | Missing engine 3 | Engine failure 3 | Version 4 | Total | Fatal |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| No skill | 4 | 2 | 3 | 3 | 4 | **16/17** | 0 |
| Previous skill | 4 | 3 | 3 | 3 | 4 | **17/17** | 0 |
| Final candidate | 4 | 3 | 3 | 3 | 4 | **17/17** | 0 |

All 15 cells completed. Each implementation condition changed only
`scripts/player.gd`; every read-only condition retained its tree hash and clean
status. The no-skill review lost one item because its reader-facing result did
not explicitly distinguish text inspection from an engine load check.

The candidate therefore demonstrates no Codex behavior regression against the
previous skill. The behavior tie does not by itself prove that the candidate is
better; the decisive improvements are the complete installable payload,
version-correct references, authority boundaries, and reproducible validation
that the previous remote package lacked.

## Claude Code: partial

Environment: Claude Code 2.1.206, `claude-fable-5`, high effort, nonpersistent
sessions, project-only settings, strict empty MCP configuration, and a
USD 1.00 cap per cell.

| Condition | Normal change | Review only | Missing engine | Engine failure | Version sensitive |
| --- | ---: | ---: | ---: | ---: | ---: |
| No skill | 4/4 | Unavailable | Unavailable | Unavailable | Unavailable |
| Previous skill | 4/4 | Unavailable | Unavailable | Unavailable | Unavailable |
| Candidate | 4/4 | 3/3 | Unavailable | Unavailable | Unavailable |

The four valid cells had no fatal failures. Both valid candidate prompts caused
Claude to load the skill through its `Skill` tool. The remaining eleven cells
and the separate trigger-classification run are unavailable because the account
session limit was reached; they were not retried or scored as failures. Claude
reported USD 2.776740 across valid cells and quota responses.

The valid Claude candidate cells evaluated payload hash
`ac6debc381bef2126490c9185a0ecad9e0aa24084ab640fac43727b1b5999536`,
not the final hash above. The final snapshot later changed only:

- `references/version-and-sources.md`, to record 4.7.1 RC2 and the official
  archive while retaining 4.7 as the stable target;
- `scripts/check_gdscript.sh`, to preserve a configured binary's failing exit
  status.

Those two changes are covered by the complete final-snapshot Codex run, official
source verification, and shell smoke tests, but not by a valid Fable cell. Full
Fable acceptance therefore remains unproven.

## Trigger classification

Codex classified the candidate metadata against the two positive and three
near-miss prompts in `cases.json`: **5/5**. This was a metadata classification,
not proof of runtime implicit discovery for all five prompts. Actual candidate
behavior runs did implicitly load the skill in Codex, and the two valid Claude
candidate runs loaded it through Claude's skill mechanism.

## Live-editor extension: initial candidate evidence (2026-07-11)

The live-editor cases added in schema version 2 were not part of the 2026-07-10
matrix above. One focused Codex candidate cell was run against a real Godot AI
`2.9.1` server and its bundled Godot 4.7 test project. Codex CLI 0.144.0 used
`gpt-5.6-sol`, high reasoning effort, an ephemeral session, and a read-only
sandbox. The prompt supplied the candidate `SKILL.md` and
`references/live-editor-control.md` directly; this cell therefore tests task
behavior, not implicit skill discovery.

The `live-editor-review-only` rubric passed **4/4**:

- the first tool-form session read was cancelled without mutation, after which
  the agent made one bounded fallback to the read-only resource form;
- it matched the sole session's canonical project path before reading editor
  state and did not activate another global session;
- it reported Godot `4.7-stable (official)`, plugin/server `2.9.1`,
  `readiness=ready`, and `res://main.tscn` from live evidence;
- it did not save, reload, run, stop, capture, or mutate anything, and correctly
  reported runtime and visual behavior as unproven.

The matching Claude Code 2.1.207 / Fable 5 read-only cell was attempted with a
USD 1.00 cap, but the account returned a session-limit response before inference
(`0` tokens, `$0`). No Claude live-editor behavior is therefore scored. The
stateful change, multiple-session, and runtime-input/visual cells also remain
explicitly untested rather than inferred from the read-only Codex result.

The current snapshot also passed the portable skill validator at 8,104 bytes,
JSON parsing, shell syntax, direct-reference existence, and `git diff --check`.
Skills CLI found exactly one skill and installed byte-identical payloads for
Codex and Claude Code in an isolated temporary project. The unchanged parser
script retained its expected smoke statuses: success `0`, intentional parse
failure `1`, and configured editor failure `42`.

## Structural and script checks

- Both skill validators accepted the final payload.
- Skills CLI 1.5.15 found exactly one skill and copied the complete payload into
  isolated Codex and Claude project locations; both installed trees matched the
  source byte for byte.
- Direct references and README-local links exist, `cases.json` parses, shell
  files pass `bash -n`, and `git diff --check` is clean.
- `check_gdscript.sh` smoke results were: fake success `0`, intentional parse
  failure `1`, configured binary failure `42`, and missing binary `127`.

## Limitations

- The 2026-07-10 core matrix had no real Godot executable, so it claims no
  actual import, script parse, scene load, runtime, visual, or export result.
  The 2026-07-11 extension adds only read-only live-editor metadata evidence.
- The review fixture's patch has an invalid hunk count in addition to its Godot
  defects. That extra finding was identical across conditions and was not a
  scored rubric item.
- The Claude matrix and negative-trigger discovery remain incomplete because of
  the session quota.
