function fzf_history
  set -l fzf_flags $argv

  history | fzf $fzf_flags | read line
  if test $line
    commandline $line
  else
    commandline ''
  end
end
