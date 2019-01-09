HOMEBREW_GITHUB_API_TOKEN=<SOME_TOKEN>

# base 64 encode|decode
function b64e() { echo -n "$1" | base64 | pbcopy; }
function b64d() { echo -n "$1" | base64 -D | pbcopy; echo ""; }
function env2secret { while IFS='=' read -r key value; do B64E=`echo -n $value | base64 `; echo  "$key: \"$B64E\" # $value"; done <$1; }

# Sharing/Opening secrets files
function secret_share() { find . -name 'secret.*' | tar cf secret.tar -T - && openssl enc -AES256 -in secret.tar -out secret.tar.enc && rm secret.tar; }
function secret_open() { openssl enc -d -AES256 -in secret.tar.enc | tar -xv; }

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
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin
export PATH=$PATH:/usr/local/sbin
export PATH=$PATH:/usr/local/opt/go/libexec/bin
export PATH=$PATH:/usr/local/opt/mysql-client/bin

# AWS CLI
export AWS_SDK_LOAD_CONFIG=1
export AWS_PROFILE=sts

# ALIASES
alias saws='docker run -it -v ~/.aws/:/root/.aws:ro saws'
alias dc=docker-compose
alias tf=terraform
alias k=kubectl

# COMPLETION
[ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion
complete -C '/usr/local/bin/aws_completer' aws
complete -C /usr/local/Cellar/terraform/0.11.8/bin/terraform terraform
complete -o default -F __start_kubectl k
