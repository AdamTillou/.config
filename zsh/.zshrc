# Enable colors
autoload -U colors && colors

# Disable Ctrl+S and Ctrl+Q for freezing shell
stty -ixon

# Set environmental variables
HISTFILE=~/.zsh/histfile
HISTSIZE=1000
SAVEHIST=1000
XDG_CONFIG_HOME="$HOME/.config"
XDG_CACHE_HOME="$HOME/.cache"
PATH="$PATH:$HOME/.bin/"

# Define keybindings
four_left() { zle backward-char ; zle backward-char ; zle backward-char ; zle backward-char }
four_right() { zle forward-char ; zle forward-char ; zle forward-char ; zle forward-char }
zle -N four_left
zle -N four_right

bindkey h backward-char
bindkey l forward-char
bindkey H four_left
bindkey L four_right
bindkey j down-line-or-search
bindkey k up-line-or-search
bindkey w backward-word
bindkey e forward-word
bindkey z backward-delete-char
bindkey x delete-char
bindkey Z backward-delete-word
bindkey X delete-word
bindkey a beginning-of-line
bindkey d end-of-line
bindkey A backward-kill-line
bindkey D kill-line
bindkey s kill-word
bindkey S kill-whole-line
bindkey p yank
bindkey P yank-pop
bindkey u undo

# Create aliases
alias ls="LC_COLLATE=C ls -h --group-directories-first --color=auto"
alias la="ls -A"
alias reboot="systemctl reboot"
alias blur="compton --config $HOME/.config/compton/compton.conf &> /dev/null & ; disown %1"
alias vim="vim -u '$HOME/.config/vim/vimrc'"
alias gvim="gvim -u '$HOME/.config/vim/vimrc'"
alias shim="vim -u '$HOME/.config/vim/shimrc.vim'"
alias gshim="gvim -u '$HOME/.config/vim/shimrc.vim'"
alias mv="mv -i"
alias cp="cp -ri"

# Function to generate the prompt
function prompt {
	PROMPT=''

	[ -z $( pwd | grep $HOME ) ] 2> /dev/null || PROMPT+='~'
	PROMPT+=$( echo ${PWD/$HOME/\~} | grep -o \/. | sed "$ d" | tr -d '\n' 2> /dev/null )
	PROMPT+=$( echo ${PWD/$HOME/\~} | grep -o "\/[^/]*" | sed -n "$ p" 2> /dev/null )

	PROMPT=' %B%F{44}'$PROMPT' %b%F{9}❯%F{11}❯%F{10}❯%f%b '
}

# Update the prompt each time it is loaded
function precmd {
	prompt
}
