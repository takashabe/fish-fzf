function fzf_ghq
  set fzf_flags $argv

  ghq list -p | fzf $fzf_flags | read line
  if test $line
    cd $line
    commandline -f repaint
  end
end
