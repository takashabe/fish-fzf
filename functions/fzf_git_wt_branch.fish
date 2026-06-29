function fzf_git_wt_branch
  set -l fzf_flags $argv

  set -l locals (git for-each-ref --format='%(refname:short)' refs/heads)

  # remote-tracking branches without a local counterpart, so origin/feat/x and
  # feat/x are not both offered for the same worktree
  set -l remotes
  for r in (git for-each-ref --format='%(refname:short)' refs/remotes)
    # real remote-tracking branches are <remote>/<branch>; the bare <remote>
    # entry is the HEAD symref (e.g. origin -> origin/master), skip it
    string match -q '*/*' $r; or continue
    set -l short (string replace -r '^[^/]+/' '' $r)
    contains -- $short $locals; and continue
    set -a remotes $r
  end

  printf '%s\n' $locals $remotes | fzf $fzf_flags | read selected
  if test -z "$selected"
    return 0
  end

  if contains -- $selected $remotes
    # remote-only branch: git wt resolves the short name to the matching
    # remote-tracking branch and creates the local branch itself. Passing the
    # remote ref as an explicit start-point is rejected for a name git already
    # resolves to a branch ("already exists ... start-point is not allowed").
    git wt (string replace -r '^[^/]+/' '' $selected)
  else
    git wt $selected
  end
  commandline -f repaint
end
