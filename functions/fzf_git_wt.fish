function fzf_git_wt
  set -l fzf_flags $argv

  set -l output (git-wt)
  set -l header $output[1]
  printf '%s\n' $output[2..-1] | fzf --header="$header" $fzf_flags | awk '{print $1}' | read line
  if test $line
    cd $line
    commandline -f repaint
  end
end
