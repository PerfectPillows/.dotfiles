# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="ys"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git zsh-autosuggestions zsh-syntax-highlighting fast-syntax-highlighting zsh-autocomplete)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Basic git aliases
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias c="clear"
alias g='git'
alias gco='git checkout'

# Git commit with message function
function gcm() {
    git commit -m "$*"
}

# Navigation aliases
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias home='cd ~'
alias dev='cd ~/Downloads/dev'
# Directory listing aliases (using ls)
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

#tmux set to utf8
alias tmux='tmux -u'

# Date and time aliases
alias now='date +"%T"'
alias nowdate='date +"%d-%m-%Y"'

# Network alias
alias myip='curl http://ipecho.net/plain; echo'
function opconf() {
    # Default editor is nvim
    local editor=${2:-nvim}
    
    # Define the paths for different config files
    typeset -A config_paths
    config_paths=(
        [nvim]"$HOME/.config/nvim/init.lua"
        [zshrc]"$HOME/.zshrc"
    )

    # Check if the config type exists
    if (( ! ${+config_paths[$1]} )); then
        echo "Unknown config type. Available types: ${(k)config_paths}"
        return 1
    fi

    local config_path=${config_paths[$1]}

    # Check if the config file exists
    if [[ ! -f "$config_path" ]]; then
        echo "Config file not found: $config_path"
        return 1
    fi

    # Open the config file with the specified editor
    case $editor in
        nvim)
            nvim "$config_path"
            ;;
        code)
            code "$config_path"
            ;;
        *)
            echo "Unknown editor. Opening with default (nvim)"
            nvim "$config_path"
            ;;
    esac
}

# Alias for opconf
alias conf=opconf

# Reload shell configuration
alias reload="source ~/.zshrc"

# Git branch selector function with fzf
function select_branch() {
    local branches
    
    if [[ "$1" == "-r" ]]; then
        # Remote branches
        branches=$(git branch -r | 
            sed 's/^[ *]*//' |
            sed 's/origin\///' |
            fzf --height 40% --preview 'git log --oneline {}')
            
    elif [[ "$1" == "-l" ]]; then
        # Local branches
        branches=$(git branch | 
            sed 's/^[ *]*//' |
            fzf --height 40% --preview 'git log --oneline {}')
            
    else
        # All branches
        branches=$(git branch -a | 
            sed 's/^[ *]*//' |
            sed 's/remotes\/origin\///' |
            sort -u |
            fzf --height 40% --preview 'git log --oneline {}')
    fi

    if [[ -n "$branches" ]]; then
        while true; do
            echo -n "Are you sure you want to checkout '$branches'? (y/n/c): "
            read -r yn
            case $yn in
                [Yy]*) git checkout "$branches"; break;;
                [Nn]*) select_branch "$1"; break;;
                [Cc]*) break;;
                *) echo "Error: Invalid argument. Please use y (yes), n (no), or c (cancel)" && return 1;;
            esac
        done
    fi
}

export PATH="$PATH:$(go env GOPATH)/bin"
