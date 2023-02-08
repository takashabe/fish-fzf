function fzf_cd
  set -l fzf_flags $argv

  set -l max_depth $FZF_CD_MAX_DEPTH
  set -l ignore_case $FZF_CD_IGNORE_CASE

  if test -z $max_depth
    set max_depth 3
  end

  if test -z $ignore_case
    fd --max-depth $max_depth --type d | fzf $fzf_flags | read line
  else
    fd --max-depth $max_depth --type d | grep -E -v $ignore_case | fzf $fzf_flags | read line
  end

  if test $line
    cd $line
    commandline -f repaint
  end
end
