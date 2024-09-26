# fish-fzf

fzf wrapper script for fish-shell.

## Install

Using [Fisherman](https://github.com/fisherman/fisherman):

```fish
fisher install takashabe/fish-fzf
```

## Feature

Use fzf with:

* [ghq](https://github.com/motemen/ghq)
* git switch branch based on [GitHub pull request](https://cli.github.com/manual/gh_pr_list)
* history
* [z](https://github.com/fisherman/z)
* [files(use ripgrep)](https://github.com/BurntSushi/ripgrep)
* [k8s context](https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#config)
* gcloud project
* cd (directory)

## Usage

Type the function name on the shell.

```fish
fzf_ghq
```

Or you can easily use it by adding key binding to `config.fish`:

```fish
function fish_user_key_bindings
  bind \c] fzf_ghq      # Ctrl-]
  bind \cr fzf_history  # Ctrl-r
  bind \cj fzf_z        # Ctrl-j
  bind \co fzf_file     # Ctrl-f
end
```

advanced usage:

```fish
function wrap_fzf_history
  history-merge
  fzf_history
end

function wrap_fzf_file
  fzf_file --preview "bat --style=numbers --color=always --line-range :500 {}"
end

function fish_user_key_bindings
  bind \cr wrap_fzf_history
  bind \co wrap_fzf_file
end
```

Type these bound keys you can use the function. You can change the key binding to anything.
