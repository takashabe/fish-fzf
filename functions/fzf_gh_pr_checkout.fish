function fzf_gh_pr_checkout
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

  # checkout PR branch
  set -l fzf_flags $argv
  set -l selected_pr (printf '%s\n' $pr_list | fzf $fzf_flags)
  if test -n $selected_pr
    git switch (echo $selected_pr | awk '{print $1}')
    commandline -f repaint
    return 0
  end
end
