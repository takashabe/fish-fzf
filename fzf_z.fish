function fzf_z 
  set -l fzf_flags $argv

  z -l | sort -rn | cut -c 12- | fzf $fzf_flags | read line
  if test $line
    cd $line
    commandline -f repaint
  end
end
