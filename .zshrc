# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:$PATH

# make c++ ASAN call stack and error message prettier
export ASAN_SYMBOLIZER_PATH=/usr/bin/llvm-symbolizer

# export PATH=$HOME/bin:/usr/local/bin:$PATH

# X11 perf display
# export DISPLAY=$(awk '/nameserver / {print $2; exit}' /etc/resolv.conf 2>/dev/null):0

# Path to your oh-my-zsh installation.
export ZSH="/home/marcus/.oh-my-zsh"

# go path
export GOROOT=/usr/local/go
export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$GOROOT/bin:$PATH


# colored GCC warnings and errors
# alias gmoji="gitmoji -c"
# alias g++-11="gccfilter" #it makes the errors and warnings prettier, not sure whether use it or not.
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
export GXX_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

export CC=gcc-13
# export CXX=clang++
export CXX=g++-13

# FLUTTER
export PATH="$PATH:/home/marcus/flutter/bin"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

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

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# Caution: this setting can cause issues with multiline prompts (zsh 5.7.1 and newer seem to work)
# See https://github.com/ohmyzsh/ohmyzsh/issues/5765
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

plugins=(
git
zsh-autosuggestions
zsh-syntax-highlighting
zsh-interactive-cd
catimg
extract
poetry
)

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
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
alias clip='xclip -selection clipboard'
alias ubuntu_version="lsb_release -a"
alias cb="xclip -sel clip"
alias clipboard="xclip -sel clip"
alias gmoji="gitmoji -c"
alias ls='colorls --group-directories-first'
alias c='code'
alias vsc='code'
alias vsca='code --add'
alias vscd='code --diff'
alias gbin='cd ./bin || cd ../bin || cd build/bin || cd ../build/bin'
alias gbuild='cd ./build || cd ../build || cd ../../build'
# alias cmors='cmake -S . -B ./build && cmake --build && cd build && make'
alias cmors='rm -rf build && cmake -S . -B ./build && cmake --build ./build && gbuild && make -j $(nproc)'
alias cmors_debug='rm -rf build && cmake -S . -B ./build && cmake -DCMAKE_BUILD_TYPE=Debug ./build && gbuild && make -j $(nproc)'
alias cmors_release='rm -rf build && cmake -S . -B ./build && cmake -DCMAKE_BUILD_TYPE=Release ./build && gbuild all && make -j $(nproc)'

function mysql() {

    # if the `mysql` argument is not set
    if [ -z "${1+xxx}" ]; then # mysql to the default server
        command mysql
        # MYVARIABLE="$(path/myExcecutable-bin 2>&1 > /dev/null)" #to save stderr message
        if [ $? -ne 0 ]; then
          echo ""
          echo "you might need to turn on the server by running the following commands:
  sudo service mysql start #or
  sudo /etc/init.d/mysql start"
        fi
    fi

    # if the `mysql` argument is set
    if [ -z "$1" ] && [ "${1+xxx}" = "xxx" ]; then # mysql using a different server
        command mysql $1
    fi
}

function psql() {

    # if the `psql` argument is not set
    if [ -z "${1+xxx}" ]; then # psql to the default server
        command psql
        # MYVARIABLE="$(path/myExcecutable-bin 2>&1 > /dev/null)" #to save stderr message
        if [ $? -ne 0 ]; then
          echo ""
          echo "you might need to turn on the server by running the following commands:
  sudo service postgresql-9.3 initdb #Initialize the server
  sudo /etc/init.d/postgresql start #Start the server"
        fi
    fi

    # if the `psql` argument is set
    if [ -z "$1" ] && [ "${1+xxx}" = "xxx" ]; then # psql using a different server
        command psql $1
    fi
}

m:clear(){
  default=20
  for i in `seq 1 ${1:-${default}}` do
    echo ""
}

m:git_flow_init(){
  declare -a arr=($1 $2 ${3:-"h"} ${4:-"r"} ${5:-"d"})
  git init
  echo "repository initialized"
  for i in "${arr[@]}" do
    case ${i} in
    m)  git branch marcus ;;
    f)  echo "Feature branch name: "
        read fname
        git branch $fname ;;
    h)  git branch hotfix ;;
    r)  git branch releases ;;
    d)  git branch develop ;;
    ?) echo "Not recognizable gitflow branch";;
    esac
}


m:c++_init(){
#   declare -a arr=($1 $2 $3)
#   CURRENTDATE=`date +”%A, %b %d, %Y %H:%M:%S”"`
  mkdir src/ build/ libs/ include/ tests/
  # mkdir ./src/headers/
  touch ./src/main.cpp ./cmakeLists.txt .gitignore README.md
  #date
  #date +”%A, %b %d, %Y %H:%M:%S”
  #sed
  echo "¿What license you want for your project?
  [GPLv3][none]
  default: GPLv3
  ==> "
  read license
  if [[ "$license" != "none" ]]
  then
    cp ~/.aliases-src/licenses/$license.txt .
    mv ./$license.txt ./COPYING
  fi
  echo "build/*" >> .gitignore
  echo "## Project File Structure

    Project_name/
    |
    |---- CMakeLists.txt
    |---- main.cpp
    |
    |---- include/
    |       |
    |       |---- Project_name
    |               |
    |               |---- public_headers.hh (C++ only)
    |               |---- public_headers.h (C & C++)
    |---- src/
    |       |
    |       |---- private_headers.hh (C++ only)
    |       |---- private_headers.h  (C & C++)
    |       |---- implementation_files.cc
    |       |---- implementation_files.C (if compiler doesn't accept .cc)
    |       |---- inline_definition_files.icc
    |
    |---- libs/
    |       |
    |       |---- A
    |       |
    |       |---- B
    |
    |---- tests/
## Compile the project
\`\`\`bash I'm A tab
    take build/
    cmake ..
    make --build .
\`\`\`" >> README.md
}


# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh


# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/marcus/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/marcus/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/home/marcus/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/marcus/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

#export PATH="$PATH"
# if [ -d "$HOME/+projects/exe_scripts/benchplot/dist" ] ; then
#     PATH="$HOME/+projects/exe_scripts/benchplot/dist:$PATH"
# fi

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"
#eval "$(pyenv init -)"
#eval "$(pyenv virtualenv-init -)"
# export PYTHONHOME=""
export PYTHONHOME=/usr/bin/python
# export PYTHONHOME=/usr/bin/python
# export PYTHONPATH=/usr/bin/python3
# alias python="python3"
# eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# [[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
# eval "$(pyenv init -)"

# eval "$(pyenv init --path)"
# eval "$(pyenv pyenv virtualenv-init -)"

export PATH="$HOME/.pyenv/plugins/pyenv-virtualenv/bin:$PATH"
#eval "$(pyenv virtualenv-init -)"
eval "$(zoxide init zsh)"
export FCEDIT=vim
