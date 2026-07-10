# Cross-Harness Evaluation

This evaluation freezes the same Godot fixture, prompts, and success rubric for
Codex with GPT-5.6 Sol and Claude Code with Claude Fable 5.

See [the latest recorded results](results.md) for completed cells and explicit
environment limitations.

## Matrix

Run each target in three conditions:

1. target model and harness without the skill;
2. target model and harness with commit `903c7fe` of the previous skill;
3. target model and harness with the candidate payload at
   `skills/godot-best-practice/`.

Keep the model ID, effort, tool surface, fixture, prompt, evaluator, official
source commits, and Godot binary availability fixed within each comparison.
Record an unavailable cell instead of borrowing another harness's result.

`cases.json` contains:

- two positive triggers and three adjacent near-miss negatives;
- normal implementation;
- review-only behavior;
- a missing-engine fallback;
- a configured failing engine binary;
- a current-stable version assessment.

Fatal failures are unrequested mutation, an unsupported current-version claim,
false engine-validation success, or an unauthorized dependency installation.
The review patch also has a malformed hunk count; detecting it is useful but is
not part of the frozen Godot rubric.

## Isolation

Create a fresh temporary Git repository from `fixture/` for each run. Add the
same byte-identical, frozen official-evidence subtree to every condition when
the harness cannot read the source checkouts directly. Do not expose
`cases.json`, expected answers, previous outputs, or the target skill's source
history to the task agent. Install or inject only the condition under test.
Hash the fixture before and after every review-only run.

For change cases, retain the final diff and command transcript. For read-only
cases, retain the response, tool transcript, before/after hash, and git status.
Score observable artifacts and evidence, never private reasoning.

## Structural checks

Safe checks include frontmatter validation, direct-reference existence, script
syntax/smoke tests, JSON parsing, and an isolated `skills add --list` or install
into a temporary HOME/project.

Do **not** use `skills check` as a lint command with Skills CLI 1.5.15. It is a
hidden alias for `skills update` and can rewrite installed user skills even when
passed `--help`.

## Acceptance

Accept the candidate only when it fixes current-skill failures without losing a
useful no-skill behavior. Prefer the smaller instruction set on a tie. Report
model/harness cells that were not run, Godot runtime checks blocked by the local
environment, and any evaluation limitation.
