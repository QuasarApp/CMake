# AGENTS.md

Working guidance for AI coding agents and developers in the `QuasarApp/CMake` repository.

## Description

QuasarApp/CMake is the shared CMake layer of the QuasarApp project group. It
is not a compiled product — it is a set of CMake modules that every QuasarApp
C++/Qt project includes (via `include(...)` or `add_subdirectory(...)`) to get
uniform versioning, CI targets, translations and cross-platform toolchains.
It is also shipped inside `QuasarApp/QuasarAppLib` as the `CMake/` submodule,
so a change here reaches every project in the group.

- **Language:** CMake (plus generated-file helpers in shell/qmake)
- **Build system:** CMake ≥ 3.12
- **License:** GPLv3

### Repository layout

| Path | Contents |
|---|---|
| `QuasarApp.cmake` | Main module: `initAll()`, `updateGitVars()` / `updateGitVarsWithHash()` (git commit count/hash → project version) |
| `QuasarAppCITargets.cmake` | `initTests()`/`addTests()` (the `test` aggregate + per-suite `test<Name>` / `deployTest<Name>` targets), `initDeploy()`/`addDeploy*()` (CQtDeployer), `initRelease()`, `initDoc()`/`addDoc()` |
| `QtUtils.cmake` | Qt utilities: translations (lupdate/lrelease targets), QML templates |
| `Version.cmake` | Version helpers |
| `ccache.cmake` | optional ccache support |
| `crossplatform/` | cross-platform toolchains (Android, iOS, wasm32, …) |
| `qt-android-cmake/`, `QtIosCMake/`, `QtStaticCMake/` | platform-specific CMake glue |
| `Docs/` | module documentation (mkdocs → `quasarapp.github.io`) |

### Architecture

- Projects call `initAll()` early (registers the `test` / `doc` / `deploy` /
  `release` aggregates), then register subtargets: `addTests(<name> <exec>)`,
  `addDeploy*()`, `addDoc()`.
- A `test<name>` target deploys the suite binary with `cqtdeployer` into
  `Testing/<name>/` and executes it there; the `test` aggregate depends on
  every registered suite.
- Versioning: `updateGitVars*()` read `GIT_COMMIT_COUNT_FROM` /
  `GIT_COMMIT_HASH` from git; projects build their version string from them.

## Developing process

### Branching, labels and pull requests (workflow for AI agents)

- Work is issue-driven: one GitHub issue → one branch named
  `task_<issue-number>`, branched **strictly from `main`** — never from
  another task branch.
- Commit messages: short imperative subject + issue reference, e.g.
  `fix: <summary> (issue #<issue>)`, `docs: <summary> (issue #<issue>)`.
- This repository has no build CI: it is a CMake module set, not a buildable
  product. The only workflow is `.github/workflows/deploy-docs.yml` (MkDocs
  site → GitHub Pages, runs on push to `main`); a red `Deploy Documentation`
  run blocks the merge.

**The exact commands.**

```sh
# 1. every task starts from a freshly fetched main
git fetch origin
git checkout -b task_<issue> origin/main

# 2. label the issue while working. Workflow labels in this repo:
#    in-progress, waiting-for-review, needs-clarification,
#    help wanted, question
gh issue edit <issue> --add-label in-progress

# 3. post the initial checklist as a comment; afterwards update that same
#    comment in place, never re-post it
gh issue comment <issue> --body-file /tmp/checklist.md
gh issue comment <issue> --edit-last --body-file /tmp/checklist.md

# 4. push and open the PR — see "Creating the pull request" below
git push -u origin task_<issue>
gh pr create --base main --head task_<issue> \
  --title "<type>: <short imperative summary> (issue #<issue>)" \
  --body-file /tmp/pr_body.md

# 5. the issue goes to waiting-for-review; check the docs-deploy run
#    (the only CI in this repository) from the CLI
gh issue edit <issue> --remove-label in-progress --add-label waiting-for-review
gh pr checks <number>
```

This repo does not define a `blocked` label yet — create it before first
use: `gh label create blocked --color 'e6e6e6'`.

**Status messages — what to post and when.** An agent must keep a
human-readable trail on the issue (and on the PR once it exists). Every
message is a GitHub comment with a `##` heading; the checklist comment is
updated in place (`--edit-last`), never duplicated.

| Stage | Label(s) | Comment template |
|---|---|---|
| Start | `in-progress` | `## Task issue_XXX: <title> — initial checklist (branch task_XXX from main)` — one `- [ ]` line per sub-task |
| Each step done | — | edit the checklist comment: mark the line `- [x]` + one short evidence note (command run, result) |
| Blocked / needs input | `blocked` / `question` | `## Blocked — task_XXX` — what is blocking and exactly what is needed to continue |
| PR opened | `waiting-for-review` | `## Progress — task_XXX` — all lines `- [x]` + `**PR: <url>**` + one-line verification summary |
| Review changes requested | `waiting-for-review` | `## Review-fix cycle — PR #NNN — update` — one `- [x]` line per review point, each with the evidence |
| CI red on the PR | `in-progress` | `## CI failure — PR #NNN` — failing check, cause, fix plan; push the fix, then update the comment |

**Creating the pull request.** An agent has no browser and cannot create a
pull request from the GitHub web UI — it must use the `gh` CLI (a token with
the `repo` scope; in this organisation the agent runs as `QuasarAppCI`):

```sh
gh pr create \
  --base main \
  --head task_<issue> \
  --title "<type>: <short imperative summary> (issue #<issue>)" \
  --body-file /tmp/pr_body.md
```

- The body carries what changed and the verification actually performed
  (commands + their real output); `(issue #<n>)` in the title links the PR
  to the issue. Use `--draft` while still iterating.
- A pull request exists only when `gh pr create` prints its URL. Confirm
  with `gh pr view <number> --json number,url,mergeable` before reporting
  "PR created" — never post that status on faith.
- If work is blocked, keep the PR open, set the issue label to `blocked` and
  post the status message above.

### Documentation rules

- Every public module function gets a comment block in the module file — the
  comments are the documentation (see `QuasarAppCITargets.cmake`).
- `Docs/*.md` must stay in sync with the module they describe; a module
  change and its `Docs/` page ship in the same PR.
- New modules ship **with** their `Docs/` page — never in a follow-up ticket.