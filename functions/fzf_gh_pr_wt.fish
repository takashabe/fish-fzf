function fzf_gh_pr_wt
  # choose a reviewer
  if set -q FZF_GH_PR_CHECKOUT_REVIEWER
      set -f reviewer_name $FZF_GH_PR_CHECKOUT_REVIEWER
  else
      set -f reviewer_name (git config user.name)
  end
  if test -z "$reviewer_name"
    echo "Reviewer name not set. Please set git user.name or FZF_GH_PR_CHECKOUT_REVIEWER environment variable."
    return 1
  end

  # search PRs
  set -l pr_list (gh pr list --limit 100 --search "review-requested:$reviewer_name" --json number,headRefName,title,createdAt --template '{{- range .}}{{tablerow .headRefName "|" (printf "#%v" .number) "|" .title "|" (timeago .createdAt)}}{{end}}')
  if test -z "$pr_list"
    echo "No Pull Requests found for reviewer $reviewer_name"
    return 0
  end

  # select PR
  set -l fzf_flags $argv
  set -l selected_pr (printf '%s\n' $pr_list | fzf $fzf_flags)
  if test -z "$selected_pr"
    return 0
  end

  set -l branch_name (echo $selected_pr | awk '{print $1}')
  set -l pr_number (echo $selected_pr | awk '{print $3}' | tr -d '#')

  # resolve GitHub remote from gh-resolved config, fallback to origin
  set -l remote (git config --get-regexp 'remote\..*\.gh-resolved' 2>/dev/null | head -1 | string replace -r 'remote\.(.+)\.gh-resolved .*' '$1')
  if test -z "$remote"
    set remote origin
  end

  # fetch PR ref to FETCH_HEAD to avoid updating checked-out branches
  git fetch $remote pull/$pr_number/head 2>/dev/null

  # create worktree from FETCH_HEAD, or switch to existing one
  git wt $branch_name FETCH_HEAD 2>/dev/null
  or git wt $branch_name
  commandline -f repaint
  return 0
end
