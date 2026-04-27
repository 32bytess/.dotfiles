# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.config/zsh/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH="$ZDOTDIR/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"

ZSH_CUSTOM=${ZSH_CUSTOM:-$ZSH/custom}

plugins=(git zsh-autosuggestions zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

# PATH
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/sdks/flutter/bin:$PATH"

# Go
export GOPATH=$HOME/go
export PATH="$GOPATH/bin:$PATH"
export GOROOT=$HOME/.local/opt/go-v1.26.0
export PATH=$GOROOT/bin:$PATH

# aliases
alias vim='nvim'
alias open='xdg-open'
alias vi='/usr/bin/vim'
alias light='light -S'

# vim mode in zsh
bindkey -v
bindkey -s ^f "tmux-sessionizer\n"
export EDITOR="nvim"

# To customize prompt, run `p10k configure` or edit ~/.config/zsh/.p10k.zsh.
[[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh
