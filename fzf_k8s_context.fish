function fzf_k8s_context
  set fzf_flags $argv

  kubectl config get-contexts --no-headers=true | awk '{print $2}'| fzf $fzf_flags | read line
  if test $line
    commandline "kubectl config use-context $line"
  else
    commandline ''
  end
end
