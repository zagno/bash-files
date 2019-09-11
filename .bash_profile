
# HOMEBREW_GITHUB_API_TOKEN=

# bash history helper
export HISTCONTROL=ignoredups:erasedups
export HISTSIZE=100000
export HISTFILESIZE=100000
shopt -s histappend
export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND" # Save and reload the history after each command finishes

# Go
export GOROOT=/usr/local/opt/go/libexec
export GOPATH=$HOME/Projects/go

# Path
export PATH=$GOROOT/bin:$GOPATH/bin:$PATH
export PATH=/usr/local/sbin:$PATH
export PATH=/usr/local/opt/go/libexec/bin:$PATH
export PATH=/usr/local/opt/mysql-client/bin:$PATH
export PATH=/usr/local/opt/findutils/libexec/gnubin:$PATH
export PS1="\[\033[32m\]\W\[\033[36m\]\$(parse_aws_profile)\[\033[00m\]\[\033[33m\]\$(parse_git_branch)\[\033[00m\]$ "

### ALIASES
alias saws='docker run -it -v ~/.aws/:/root/.aws:ro saws'
alias dc=docker-compose
alias d=docker
alias tf=terraform
alias tg=terragrunt
alias k=kubectl
alias awsp="source _awsp"
alias ninjacommit="git commit --amend --no-edit && git push --force-with-lease $argv"

### COMPLETION - bash-completion@2
[[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"

# complete -C /usr/local/Cellar/terraform/0.11.8/bin/terraform terraform
complete -C '/usr/local/aws/bin/aws_completer' aws
source <(kubectl completion bash)
# source <(kops completion bash)

HOMEBREW_PREFIX=$(brew --prefix)
if type brew &>/dev/null; then
  for COMPLETION in "$HOMEBREW_PREFIX"/etc/bash_completion.d/*
  do
    [[ -f $COMPLETION ]] && source "$COMPLETION"
  done
  if [[ -f ${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh ]];
  then
    source "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh"
  fi
fi

### FUNCTIONS

# Display get branch
function parse_git_branch {
     git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/|\1/'
}

function parse_aws_profile {
     if [ "$AWS_PROFILE" ]; then
      echo "|$AWS_PROFILE"
     fi
}

# Base64 encode|decode
function b64e { echo -n "$1" | base64 | pbcopy; }
function b64d { echo -n "$1" | base64 -D | pbcopy; echo ""; }

# Env to Kuberbetes secrets
function env2secret { while IFS='=' read -r key value; do B64E=`echo -n $value | base64 `; echo "$key: \"$B64E\" # $value"; done <$1; }

function update_terminal_cwd() {
    # Identify the directory using a "file:" scheme URL,
    # including the host name to disambiguate local vs.
    # remote connections. Percent-escape spaces.
    local SEARCH=' '
    local REPLACE='%20'
    local PWD_URL="file://$HOSTNAME${PWD//$SEARCH/$REPLACE}"
    printf '\e]7;%s\a' "$PWD_URL"
}


