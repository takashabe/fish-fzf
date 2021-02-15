function fzf_gcloud_configurations
  set -l query (commandline)
  if test -n $query
    set fzf_flags --query "$query"
  end

  gcloud config configurations list | tail -n +2 | fzf $fzf_flags | read line
  if test $line
    gcloud config configurations activate (echo $line | awk '{print $1}')
    commandline -f repaint
  end
end
