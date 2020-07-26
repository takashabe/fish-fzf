function fzf_file
  set -l fzf_flags $argv

  rg --files --hidden --glob "!.git/*" | fzf $fzf_flags | read line
  if test $line
    commandline "$EDITOR $line"
    commandline -f execute
  end
end
