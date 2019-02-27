function fzf_ghq
  set -l query (commandline)
  if test -n $query
    set fzf_flags --query "$query"
  end

  ghq list -p | fzf $fzf_flags | read line
  if test $line
    cd $line
    commandline -f repaint
  end
end
