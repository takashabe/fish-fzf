# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

A [Fisher](https://github.com/jorgebucaran/fisher)-installable fish-shell plugin providing fzf wrappers for common interactive selections. Each function is a standalone `.fish` file under `functions/`, which Fisher autoloads by filename (`functions/fzf_ghq.fish` defines `fzf_ghq`). `functions/*.fish` is the source of truth for what features exist. There is no build, test, or lint tooling.

## Development

- **Run/test a function locally**: source it, then invoke it interactively. `source functions/fzf_ghq.fish; fzf_ghq`
- **Adding a function**: create `functions/<name>.fish` defining a function of the same name, then document it in `README.md` if relevant.
- Functions assume their external CLI dependency (`fzf`, plus per-function tools like `ghq`, `gh`, `git-wt`, `fd`, `rg`, `kubectl`, `gcloud`, `z`) is installed. These are not bundled or checked.

## Conventions

Every function follows the same shape — match it when editing or adding:

1. `set -l fzf_flags $argv` first, so callers can pass extra fzf flags (the README's `wrap_*` examples rely on this).
2. Produce candidate lines → pipe to `fzf $fzf_flags` → `read line` (or capture into a var).
3. Guard with `if test $line` / `if test -n "$selected"` before acting — never act on an empty selection.
4. Terminal action by intent:
   - **Directory change** (cd-style: `fzf_cd`, `fzf_ghq`, `fzf_z`, `fzf_git_wt`): `cd $line; commandline -f repaint`.
   - **Edit the command line for the user to run** (`fzf_history`, `fzf_k8s_context`): `commandline "<cmd>"` — and `commandline ''` on cancel to clear.
   - **Execute immediately** (`fzf_file`): `commandline "$EDITOR $line"; commandline -f execute`.
5. When parsing tabular CLI output, select the column with `awk '{print $1}'` (or the relevant index) rather than fragile string slicing.

When a function needs a user-provided value, read it from an environment variable with a sensible fallback inside the function rather than hardcoding (e.g. `FZF_CD_MAX_DEPTH`, `FZF_GH_PR_CHECKOUT_REVIEWER` defaulting to `git config user.name`). Grep the function for the actual variable names.

## Notable detail

`fzf_gh_pr_wt` fetches the PR ref into `FETCH_HEAD` (`git fetch <remote> pull/<n>/head`) before creating a worktree, deliberately avoiding any update to checked-out branches. The remote is resolved from the `gh-resolved` git config (set by `gh`), falling back to `origin`. Preserve this fetch-to-FETCH_HEAD behavior if modifying worktree/PR logic.
