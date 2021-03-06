export CLICOLOR=1
export EDITOR="vim"
export HISTCONTROL=ignoreboth # don't put duplicate lines in the history. See bash(1) for more options
export HISTIGNORE="ls:ls *:cd:cd -:pwd;exit:date:* --help" # Make some commands not show up in history
export LANG="en_US" # Prefer US English and use UTF-8
export LC_ALL="en_US.UTF-8" # Prefer US English and use UTF-8
export LSCOLORS='Gxfxcxdxdxegedabagacad'
export MANPAGER="less -X" # Don’t clear the screen after quitting a manual page
export PATH=$HOME/.yarn/bin:$HOME/bin:$PATH

# append to the history file, don't override it
shopt -s histappend

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob

set completion-ignore-case on # Make Tab autocomplete regardless of filename case
set page-completions off # Immediately show all possible completions
set show-all-if-ambiguous on # List all matches in case multiple possible completions are possible
set skip-completed-text on # Be more intelligent when autocompleting by also looking at the text after the cursor.

# Allow UTF-8 input and output, instead of showing stuff like $'\0123\0456'
set input-meta on
set output-meta on
set convert-meta off

alias less='less -R'
alias ls='CLICOLOR_FORCE=1 ls -G'
alias subl='subl -a -n'
alias subl-head='subl --add --project=~/code/pinboard $(git files -r HEAD)'

function source_file() {
	if [ -f $1 ]; then
		source $1
		return 1
	fi
	return 0
}

source_file "$HOME/.bash_profile.local"

source_file "$HOME/bin/iterm2_shell_integration.bash"
source_file "$HOME/bin/arcanist/resources/shell/bash-completion"

# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
[ -e "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2)" scp sftp ssh

if brew -h &> /dev/null; then
	brew_prefix=`brew --prefix`

	source_file "$brew_prefix/etc/bash_completion.d/brew"
	source_file "$brew_prefix/etc/bash_completion.d/flow-completion.bash"
	source_file "$brew_prefix/etc/bash_completion.d/git-completion.bash"
	source_file "$brew_prefix/etc/bash_completion.d/npm"
	source_file "$brew_prefix/etc/bash_completion.d/tig-completion.bash"
	source_file "$brew_prefix/etc/bash_completion.d/tmux"

	source_file "$brew_prefix/opt/fzf/shell/completion.bash"
	source_file "$brew_prefix/opt/fzf/shell/key-bindings.bash"

	if [ -f "$brew_prefix/etc/bash_completion.d/git-prompt.sh" ]; then
		source "$brew_prefix/etc/bash_completion.d/git-prompt.sh"

		GREEN='\[\033[32m\]'
		WHITE='\[\033[00m\]'
		BLUE='\[\033[1;36m\]'
		RED='\[\033[31m\]'
		ORANGE='\[\033[31m\]'

		PS1=$GREEN'\u@\h'$WHITE': '$BLUE'\w'$RED'$(__git_ps1 " (%s)")'$WHITE'$ '
	fi
fi

function json() {
  python -mjson.tool <<< "$*" | pygmentize -l javascript
}

gitPreAutoStatusCommands=(
  'add'
  'rm'
  'mv'
  'checkout'
  'rebase'
)

function git() {
  command git "${@}"

  if [[ " ${gitPreAutoStatusCommands[@]} " =~ " ${1} " ]]; then
    echo  # empty line
    command git status
  fi
}

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
