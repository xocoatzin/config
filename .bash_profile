
alias k='kubectl'

# LS
alias l='ls -lah'
export CLICOLOR=1
export LSCOLORS=ExGxBxDxCxEgEdxbxgxcxd

# Prompt
source ~/.git-prompt.sh
export PS1="\$? \[$(tput bold)\]\[$(tput sgr0)\]\[\033[38;5;32m\]\W\[$(tput sgr0)\]\[\033[0;32m\]\$(__git_ps1)\[$(tput sgr0)\]\[\033[38;5;15m\] \\$ \[$(tput sgr0)\]"

# Git
if [ -f ~/.git-completion.bash ]; then
  . ~/.git-completion.bash
fi

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/atorresgomez/google-cloud-sdk/path.bash.inc' ]; then source '/Users/atorresgomez/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/atorresgomez/google-cloud-sdk/completion.bash.inc' ]; then source '/Users/atorresgomez/google-cloud-sdk/completion.bash.inc'; fi
. "$HOME/.cargo/env"
