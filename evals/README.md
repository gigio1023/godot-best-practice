# Cross-Harness Evaluation

The [2026-07-10 behavior evaluation](results.md) freezes the Godot fixture, prompts, and success rubric in `cases.json`. It targeted Codex with GPT-5.6 Sol and Claude Code with Claude Fable 5. Its results apply to the recorded payload hashes, not automatically to the current skill.

[Deterministic validation on 2026-10-23](validation-2026-10-23.md) records the refreshed checker and real Godot 4.7.2 smoke checks. No new model behavior matrix ran. Future behavior evaluations must record their actual model, harness, effort, engine, and payload revisions and preserve the historical cases.

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

Package checks include frontmatter validation, direct-reference existence, shell syntax, JSON parsing, and isolated skill discovery or installation. Run the checker contract cases without installing an engine:

```sh
bash evals/checker-smoke.sh
```

This uses a controlled CLI adapter and a temporary fixture copy. A passing result proves checker behavior only. The GitHub workflow runs the same cases on Linux and macOS. Use the separate real-engine commands in the [current validation record](validation-2026-10-23.md) for engine evidence.

Do **not** use `skills check` as a lint command. In Skills CLI 1.7.4, it remains an alias for `skills update` and can rewrite installed skills. The [pinned command dispatcher](https://github.com/vercel-labs/skills/blob/a80e4c9d12d607631249d4d7d059f835d4b2f13a/src/cli.ts#L420-L424) sends both commands to `runUpdate`; a subcommand `--help` [returns before dispatch](https://github.com/vercel-labs/skills/blob/a80e4c9d12d607631249d4d7d059f835d4b2f13a/src/cli.ts#L338-L356).

Historical caution: Skills CLI 1.5.15 also ran that update when passed `--help`. The help short-circuit was already present in the previously inspected 1.7.0 release. Do not infer an older CLI's behavior from the current one.

## Acceptance

Accept the candidate only when it fixes current-skill failures without losing a
useful no-skill behavior. Prefer the smaller instruction set on a tie. Report
model/harness cells that were not run, Godot runtime checks blocked by the local
environment, and any evaluation limitation.
