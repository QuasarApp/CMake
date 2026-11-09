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

### Toolchain

| Tool | Version / notes |
|---|---|
| CMake | ≥ 3.12 |
| Qt | 6.10 — a Qt prefix on `CMAKE_PREFIX_PATH` is needed for the standalone build |
| Ninja | preferred generator |
| Doxygen | for the `doc` target |
| mkdocs | documentation site (`Docs/`) |

### Build

Step by step.

**1. One-time toolchain setup.** CMake ≥ 3.12 plus a Qt 6.10 install (e.g.
via aqtinstall: `aqt install-qt linux desktop 6.10.3 gcc_64 -O /opt/Qt`) —
the module layer queries Qt, so the standalone configure needs the prefix.

**2. Get the sources.** No submodules.

```sh
git clone https://github.com/QuasarApp/CMake.git
```

**3. Configure.**

```sh
cmake -B build -G Ninja -DCMAKE_PREFIX_PATH=/opt/Qt/6.10.3/gcc_64 -DCMAKE_BUILD_TYPE=Release
```

**4. Build** (mainly produces the doc target).

```sh
cmake --build build --parallel 16
```

**5. Find the result.** There is no runtime binary — the deliverable of this
repository is the CMake modules themselves, consumed by other QuasarApp
projects via `include(<path>/QuasarApp.cmake)` or `add_subdirectory(...)`.
After changing a module, re-verify with a consuming project (a broken module
breaks every project that includes it — see Testing process).

CMake options: none at the top level (this repository is a module set, not a
product). The `doc` target (registered via `addDoc`) generates the Doxygen
documentation; `Docs/` + `mkdocs.yml` publish the module reference.

### Branching, labels and pull requests (workflow for AI agents)

- Work is issue-driven: one GitHub issue → one branch named
  `task_<issue-number>`, branched **strictly from `main`** — never from
  another task branch.
- Commit messages: short imperative subject + issue reference, e.g.
  `fix: <summary> (issue #<issue>)`, `docs: <summary> (issue #<issue>)`.
- Keep the build and lint green; a red CI blocks the merge.

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

# 5. the issue goes to waiting-for-review; watch CI from the CLI
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

## Testing process

### Test infrastructure

This repository has no unit-test suite: it is CMake logic, and its real tests
are the consuming projects. The standalone build registers an empty `test`
aggregate target (nothing is added to it).

### Running the tests from CMake

There is nothing to run here. Verification of a change = configure + build a
consuming project against the modified layer:

```sh
# in a sibling clone (e.g. easyssl), point the CMake submodule at your branch, then:
cmake -B build -G Ninja -DCMAKE_PREFIX_PATH=/opt/Qt/6.10.3/gcc_64 \
  -DCMAKE_BUILD_TYPE=Debug
cmake --build build --parallel 16
```

### Smoke tests — the most important testing step

The smoke test for this repository is: a consuming project (any QuasarApp
C++/Qt project that includes the layer) configures and builds green with the
changed modules, and its test suite still runs. `easyssl` is the cheapest
consumer — configure it with `EASYSSL_TESTS=ON` (Debug), build and execute
`easyssl_tests`. A red configure/build in any consumer is a smoke-test
failure for this repository.