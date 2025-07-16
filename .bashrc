# Enable the subsequent settings only in interactive sessions
case $- in
  *i*) ;;
    *) return;;
esac


# Path to your oh-my-bash installation.
export OSH='/home/ebad/.oh-my-bash'

# setting the theme for the bat command 
export BAT_THEME=tokyonight_night



# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-bash is loaded.
OSH_THEME="vscode"

# If you set OSH_THEME to "random", you can ignore themes you don't like.
# OMB_THEME_RANDOM_IGNORED=("powerbash10k" "wanelo")

# Uncomment the following line to use case-sensitive completion.
# OMB_CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# OMB_HYPHEN_SENSITIVE="false"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_OSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
#ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
#COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you don't want the repository to be considered dirty
# if there are untracked files.
# SCM_GIT_DISABLE_UNTRACKED_DIRTY="true"

# Uncomment the following line if you want to completely ignore the presence
# of untracked files in the repository.
# SCM_GIT_IGNORE_UNTRACKED="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.  One of the following values can
# be used to specify the timestamp format.
# * 'mm/dd/yyyy'     # mm/dd/yyyy + time
# * 'dd.mm.yyyy'     # dd.mm.yyyy + time
# * 'yyyy-mm-dd'     # yyyy-mm-dd + time
# * '[mm/dd/yyyy]'   # [mm/dd/yyyy] + [time] with colors
# * '[dd.mm.yyyy]'   # [dd.mm.yyyy] + [time] with colors
# * '[yyyy-mm-dd]'   # [yyyy-mm-dd] + [time] with colors
# If not set, the default value is 'yyyy-mm-dd'.
# HIST_STAMPS='yyyy-mm-dd'

# Uncomment the following line if you do not want OMB to overwrite the existing
# aliases by the default OMB aliases defined in lib/*.sh
# OMB_DEFAULT_ALIASES="check"

# Would you like to use another custom folder than $OSH/custom?
# OSH_CUSTOM=/path/to/new-custom-folder

# To disable the uses of "sudo" by oh-my-bash, please set "false" to
# this variable.  The default behavior for the empty value is "true".
OMB_USE_SUDO=true

# To enable/disable display of Python virtualenv and condaenv
# OMB_PROMPT_SHOW_PYTHON_VENV=true  # enable
# OMB_PROMPT_SHOW_PYTHON_VENV=false # disable





# Limit history file size
HISTSIZE=1000
HISTFILESIZE=2000


# Which completions would you like to load? (completions can be found in ~/.oh-my-bash/completions/*)
# Custom completions may be added to ~/.oh-my-bash/custom/completions/
# Example format: completions=(ssh git bundler gem pip pip3)
# Add wisely, as too many completions slow down shell startup.
completions=(
  
)

# Which aliases would you like to load? (aliases can be found in ~/.oh-my-bash/aliases/*)
# Custom aliases may be added to ~/.oh-my-bash/custom/aliases/1
# Example format: aliases=(vagrant composer git-avh)
# Add wisely, as too many aliases slow down shell startup.
aliases=(
  general
)

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-bash/plugins/*)
# Custom plugins may be added to ~/.oh-my-bash/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  bashmarks
)

# Which plugins would you like to conditionally load? (plugins can be found in ~/.oh-my-bash/plugins/*)
# Custom plugins may be added to ~/.oh-my-bash/custom/plugins/
# Example format:
#  if [ "$DISPLAY" ] || [ "$SSH" ]; then
#      plugins+=(tmux-autoattach)
#  fi

#below preexec, PROMPT_COMMAND and trap is just printing the newline at the end of each command's output except the clear comamnd 

preexec() {
    printf "\n"
}

# Modified PROMPT_COMMAND to avoid newline for clear command
PROMPT_COMMAND='[[ "$PREV_CMD" != "clear" ]] && printf "\n"'

# Trap to capture the previous command
trap 'PREV_CMD=$THIS_CMD; THIS_CMD=$BASH_COMMAND' DEBUG

#[ -f ~/.fzf.bash ] && source ~/.fzf.bash


source "$OSH"/oh-my-bash.sh


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
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_3id"

# Set personal aliases, overriding those provided by oh-my-bash libs,
# plugins, and themes. Aliases can be placed here, though oh-my-bash
# users are encouraged to define aliases within the OSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias bashconfig="mate ~/.bashrc"
# alias ohmybash="mate ~/.oh-my-bash"


#neofetch

#fastfetch

#the ctrl+t works the same as the 'fzf' alias works 
source /usr/share/doc/fzf/examples/key-bindings.bash
source /usr/share/bash-completion/completions/fzf
export FZF_DEFAULT_COMMAND="fdfind --type f --hidden --exclude .git"
export FZF_PREVIEW_OPTS='--multi --preview="batcat --color=always {}"'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_T_OPTS="$FZF_PREVIEW_OPTS"
export FZF_ALT_C_COMMAND="fdfind --type d --hidden --exclude .git"
export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -200'"
export FZF_DEFAULT_OPTS="--height 100%"



#My custom alias are below :

alias bat='batcat'

#fzfc is the alias for finding the multiple files with preview beautifully using bat command 
#alias fzf='fzf -m --preview="batcat --color=always {}"'


#fzf is the alias for finding the multiple files with preview beautifully using bat command and also the copied items copied into
#the clipboard which is nice 
#alias fzf='fzf -m --preview="batcat --color=always {}" | while IFS= read -r line; do copyq add "${line}"; done && copyq copy "$(copyq read 0)" > /dev/null'

#fzfc is the alias for finding the multiple files with previw and then open them in vscode 
#alias fzfc='code $(fzf -m --preview="batcat --color=always {}")'



# Fixed __fzf_select__ function for Ctrl+T - uses fdfind and fixes clipboard duplication
# __fzf_select__() {
#   # Use fdfind instead of find command
#   local cmd="${FZF_CTRL_T_COMMAND:-"fdfind --type f --hidden --exclude .git"}"
  
#   local selected
#   selected=$(eval "$cmd" | FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} --bind=ctrl-z:ignore $FZF_DEFAULT_OPTS $FZF_CTRL_T_OPTS" fzf -m "$@")
  
#   # if [[ -n "$selected" ]]; then
#   #   # Copy to clipboard (fixed to avoid duplication)
#   #   printf "%s" "$selected" | copyq copy -
    
#   #   # Print to terminal (this makes it appear on command line)
#   #   READLINE_LINE="${READLINE_LINE}${selected}"
#   #   READLINE_POINT=${#READLINE_LINE}
#   # fi


#   if [[ -n "$selected" ]]; then
#         echo "$selected" | while IFS= read -r line; do
#             copyq add "${line}"
#         done
#         copyq copy "$(copyq read 0)" > /dev/null
#         echo "$selected"
#     fi

# }



fzf_with_copy() {
    local selected
    selected=$(command fzf -m --preview="batcat --color=always {}")
    if [[ -n "$selected" ]]; then
        echo "$selected" | while IFS= read -r line; do
            copyq add "${line}"
        done
        copyq copy "$(copyq read 0)" > /dev/null
        echo "$selected"
    fi
}


fzfc_with_code() {
    local selected
    # Use fdfind to search both files and directories
    selected=$(fdfind --hidden --exclude .git | command fzf -m --preview='
        if [[ -d {} ]]; then
            tree -C {} | head -200
        else
            batcat --color=always {}
        fi
    ')
    if [[ -n "$selected" ]]; then
        code $selected
    fi
}



fzf_for_ctrl_t() {
    local selected
    selected=$(command fzf -m --preview="batcat --color=always {}")
    if [[ -n "$selected" ]]; then
        echo "$selected" | while IFS= read -r line; do
            copyq add "${line}"
        done
        copyq copy "$(copyq read 0)" > /dev/null
        READLINE_LINE="${READLINE_LINE}${selected}"
        READLINE_POINT=${#READLINE_LINE}
    fi
}


# Bind Ctrl+T to the fixed function

bind -x '"\C-t": fzf_for_ctrl_t'



_fzf_compgen_path() {
  fdfind --type f --hidden --exclude .git . "$1"
}

# Apply completion for `cd` using FZF
_fzf_compgen_dir() {
  fdfind --type d --hidden --exclude .git . "$1"
}




alias fzf='fzf_with_copy'

alias fzfc='fzfc_with_code'

alias fd='fdfind'

alias tp='trash-put'



alias ls='eza --color=always --icons=always --group-directories-first'

#same as ls but also display the hidden files as well 
alias lsh='eza -a --color=always --icons=always --group-directories-first'

# Long format with all files excluding . and .. , file type indicators, and human readable 
alias l='eza -la --color=always --icons=always --group-directories-first --time-style="+%d %b %Y %I:%M %p"'

# Long format with all files including . and .. , file type indicators, and human readable 
alias ll='eza -laaF --color=always --icons=always --group-directories-first --time-style="+%d %b %Y %I:%M %p"'


#(list only files including hidden )
alias lsf='eza -Af --color=always --icons=always'

#(List only files including hidden in long list format)
alias lsfl='eza -lAf --color=always --icons=always --time-style="+%d %b %Y %I:%M %p"'

#(List only directories including hidden)
alias lsd='eza -AD --color=always --icons=always'

#(List only directories including hidden in long list format)
alias lsdl='eza -lAD --color=always --icons=always --time-style="+%d %b %Y %I:%M %p"'




# Sort by extension
alias lse='eza -fal --color=always --icons=always --sort=extension --time-style="+%d %b %Y %I:%M %p"' 


# Sort by size
alias lss='eza -lfa --color=always --icons=always --sort=size --time-style="+%d %b %Y %I:%M %p"'   

# Sort by modified time
alias lsm='eza -la --color=always --icons=always --group-directories-first --sort=modified --time-style="+%d %b %Y %I:%M %p"' 


#alias lsts='eza -la --color=always --icons=always --group-directories-first --total-size' # Show total size



# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/ebad/anaconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/ebad/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/home/ebad/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/ebad/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup

# <<< conda initialize <<<



. "$HOME/.cargo/env"
#"$HOME/.cargo/env"
