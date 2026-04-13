# =============================================================================
# POWERLEVEL10K INSTANT PROMPT - MUST STAY AT TOP
# =============================================================================
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# =============================================================================
# OH MY ZSH CONFIGURATION
# =============================================================================

# Path to Oh My Zsh installation
export ZSH="$HOME/.oh-my-zsh"

# ZSH_THEME="random" # to load a random theme each time Zsh is loaded.
# echo $RANDOM_THEME # to know which theme was loaded.
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" "..." )

# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
plugins=(
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
    zsh-interactive-cd
    catimg
    extract
    poetry
    fzf
    zsh-bat
)

# Source Oh My Zsh
source $ZSH/oh-my-zsh.sh

# =============================================================================
# PATH CONFIGURATION
# =============================================================================

# Basic PATH setup
export PATH=$HOME/bin:/usr/local/bin:$PATH

# Local bin directory
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

# Go language paths
export GOROOT=/usr/local/go
export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$GOROOT/bin:$PATH

# Flutter SDK
export PATH="$PATH:/home/marcus/flutter/bin"

export CMAKE_PREFIX_PATH=~/libs/kfr-install/lib/cmake:$CMAKE_PREFIX_PATH

# =============================================================================
# DEVELOPMENT TOOLS & ENVIRONMENT
# =============================================================================

# C++ Development
# make c++ ASAN call stack and error message prettier
export ASAN_SYMBOLIZER_PATH=/usr/bin/llvm-symbolizer
# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
export GXX_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
# alias g++-11="gccfilter" #it makes the errors and warnings prettier, not sure whether use it or not.

# Uncomment for specific compiler settings:
# export CC=gcc-14
# export CXX=g++-14
# export CXX=clang++
# export CFLAGS="-flto" #with g++ and gcc
# export CFLAGS="-thin" #with clang and clang++
# export LDFLAGS="-fuse-ld=lld -Wl,--threads=$(nproc)"

# Python Environment (Pyenv) # SAFE TO REMOVE
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv >/dev/null; then
  eval "$(pyenv init --path)"
  eval "$(pyenv init -)"
fi

# Node Version Manager (NVM)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# =============================================================================
# TOOL INITIALIZATION
# =============================================================================

# Zoxide (cd++)
eval "$(zoxide init zsh)"
eval "$(zoxide init --cmd cd zsh)"


# AUTO-DETECTION FOR PYTHON ENVIRONMENTS ======================================

# Add this section for automatic Python virtual environment detection
autoload -U add-zsh-hook
add-zsh-hook chpwd auto_python_venv

auto_python_venv() {
    # If we're in a conda environment, don't interfere
    if [[ -n "$CONDA_DEFAULT_ENV" ]]; then
        return
    fi
    
    local current_env="$VIRTUAL_ENV"
    local found_venv=""
    
    # Check for standard virtual environments (covers 90% of cases)
    local venv_dirs=("venv" ".venv" "env" ".env")
    for venv_dir in $venv_dirs; do
        if [[ -d "$venv_dir" ]] && [[ -f "$venv_dir/bin/activate" ]]; then
            found_venv="$venv_dir"
            break
        fi
    done
    
    # Handle environment activation/deactivation
    if [[ -n "$found_venv" ]]; then
        if [[ -n "$current_env" ]]; then
            # Switch environments if different
            if [[ "$(basename "$current_env")" != "$found_venv" ]]; then
                echo "🐍 Switching to Python env: $found_venv"
                deactivate 2>/dev/null
                source "$found_venv/bin/activate"
            fi
        else
            # Activate new environment
            echo "🐍 Activating Python env: $found_venv"
            source "$found_venv/bin/activate"
        fi
    elif [[ -n "$current_env" ]]; then
        # Only deactivate if we've clearly left the environment directory
        local env_parent=$(dirname "$current_env")
        if [[ "$PWD" != "$env_parent"* ]]; then
            echo "🚪 Leaving Python env: $(basename "$current_env")"
            deactivate
        fi
    fi
    
    # Optional: Notify about Python projects without active environments
    if [[ -z "$VIRTUAL_ENV" ]] && [[ -f "pyproject.toml" || -f "requirements.txt" ]]; then
        echo "📁 Python project detected (no active virtual environment)"
    fi
}

# Run on shell startup to check initial directory
auto_python_venv

# Conda (Python package management)
# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/marcus/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/marcus/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/marcus/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/marcus/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

# Direnv (directory-specific environment variables)
eval "$(direnv hook zsh)"

# =============================================================================
# ALIASES - QUICK COMMANDS
# =============================================================================

# Git aliases
alias gs="git switch"
alias gmoji="gitmoji -c"

# System information
alias ubuntu_version="lsb_release -a"

# Clipboard utilities
alias cb="xclip -sel clip"
alias clip='xclip -selection clipboard'
alias clipboard="xclip -sel clip"

# File listing
alias ls='colorls --group-directories-first'

# Code editors
alias c='code'
alias vsc='code'
alias vsca='code --add'
alias vscd='code --diff'
alias coded='code --diff'
alias codea='code --add'

# Development navigation
alias gbin='cd ./bin || cd ../bin || cd build/bin || cd ../build/bin'
alias gbuild='cd ./build || cd ../build || cd ../../build'

# Build systems
alias cmors='m:clear && rm -rf build && cmake -S . -B ./build && cmake --build ./build && gbuild && make -j $(nproc)'
alias cmors_debug='m:clear && rm -rf build && cmake -S . -B ./build && cmake -DCMAKE_BUILD_TYPE=Debug ./build && gbuild && make -j $(nproc)'
alias cmors_release='m:clear && rm -rf build && cmake -S . -B ./build && cmake -DCMAKE_BUILD_TYPE=Release ./build && gbuild all && make -j $(nproc)'

# =============================================================================
# CUSTOM FUNCTIONS
# =============================================================================

# Database utilities
function mysql() {
    if [ -z "${1+xxx}" ]; then
        command mysql
        if [ $? -ne 0 ]; then
          echo ""
          echo "you might need to turn on the server by running:"
          echo "  sudo service mysql start"
          echo "  sudo /etc/init.d/mysql start"
        fi
    else
        command mysql $1
    fi
}

function psql() {
    if [ -z "${1+xxx}" ]; then
        command psql
        if [ $? -ne 0 ]; then
          echo ""
          echo "you might need to turn on the server by running:"
          echo "  sudo service postgresql-9.3 initdb"
          echo "  sudo /etc/init.d/postgresql start"
        fi
    else
        command psql $1
    fi
}

# Screen management
m:clear(){
  default=${LINES:-20}
  for i in $(seq 1 ${1:-${default}}); do
    echo ""
  done
}

# Git workflow
m:git_flow_init(){
  declare -a arr=($1 $2 ${3:-"h"} ${4:-"r"} ${5:-"d"})
  git init
  echo "repository initialized"
  for i in "${arr[@]}"; do
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
  done
}

# C++ project initialization
m:c++_init(){
  mkdir src/ build/ libs/ include/ tests/
  touch ./src/main.cpp ./cmakeLists.txt .gitignore README.md
  
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
\`\`\`bash
    take build/
    cmake ..
    make --build .
\`\`\`" >> README.md
}

# =============================================================================
# APPEARANCE & THEMING
# =============================================================================

# Batcat theme for syntax highlighting
#export BAT_THEME="Coldark-Dark"
#export BAT_THEME="Visual Studio Dark+"
export BAT_THEME="gruvbox-dark"
#export BAT_THEME="zenburn"

# Powerlevel10k configuration
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.

# =============================================================================
# SECURITY & SSH
# =============================================================================

# SSH cache agent setup (so that i use my password 1 time per session)
if [ -z "$SSH_AUTH_SOCK" ]; then
  eval "$(ssh-agent -s)" > /dev/null
  ssh-add ~/.ssh/id_rsa 2>/dev/null
fi

# Default editor
export FCEDIT=vim



# =============================================================================
# LEGACY/COMMENTED CONFIGURATION
# =============================================================================

# X11 display (commented out)
# export DISPLAY=$(awk '/nameserver / {print $2; exit}' /etc/resolv.conf 2>/dev/null):0

# Homebrew (commented out - potential Python conflicts)
# eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# Alternative bat themes (commented out)
# export BAT_THEME="Coldark-Dark"
# export BAT_THEME="Visual Studio Dark+"
# export BAT_THEME="zenburn"
