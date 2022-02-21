export PATH=/bin:/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/Users/ryomanakagawa/development/flutter/bin 
export PS1='\W\$'
export XDG_CONFIG_HOME='~/.config'
export GOOGLE_APPLICATION_CREDENTIALS="/Users/ryomanakagawa/keys/gcp_master_key_ryoma.json"
export BASH_SILENCE_DEPRECATION_WARNING=1
# added by Anaconda3 4.4.0 installer
# export PATH="/anaconda3/bin:$PATH"  # commented out by conda initialize
export PATH=/Users/ryomanakagawa/opt/anaconda3/bin:$PATH
export PATH="/usr/local/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"

# ドットの数で表現
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# 数字で表現
alias ..2='cd ../..'
alias ..3='cd ../../..'
alias out='./a.out'
# alias jupyter='/Users/admin/anaconda/bin/jupyter_mac.command'
#alias emacs='/Applications/Emacs.app/Contents/MacOS/Emacs'
alias mongod='mongod --config /usr/local/etc/mongod.conf'
alias julia='/Applications/Julia-0.6.app/Contents/Resources/julia/bin/julia'
alias atom='/Applications/Atom.app/Contents/MacOS/Atom'
alias psql='/Library/PostgreSQL/10/bin/psql -U postgres'
alias mvim='/Applications/MacVim.app/Contents/bin/mvim'
alias cot='Applications/CotEditor.app/Contents/MacOS/CotEditor' 
alias coda='/Applications/Coda.app/Contents/MacOS/Coda\ 2'
alias magicavoxel='/Applications/MagicaVoxel-0.99.2-alpha-mac/MagicaVoxel.app/Contents/MacOS/MagicaVoxel '
eval "$(rbenv init -)"
alias sublime='/Applications/Sublime\ Text.app/Contents/MacOS/Sublime\ Text'
alias jt='/anaconda3/bin/jt'
alias ap='./a.out < input'
alias gp='git push'
alias ga='git add'
alias gc='git commit'
alias gacp='git add .;git commit -m `date "+%Y/%m/%d/%X"`; git push origin master'
alias giboinit='gibo dump macOS VisualStudio Python R C++'
alias find='fd'
alias cat='bat'
alias ls='exa'
alias l1='exa -1'

# source .bash_profileをどこでも使えるようにする
function readbash () {
  tmp=`pwd`
  cd $HOME
  source .bash_profile
  cd $tmp
}
# 出力の後に改行を入れる
function add_line {
  if [[ -z "${PS1_NEWLINE_LOGIN}" ]]; then
    PS1_NEWLINE_LOGIN=true
  else
    printf '\n'
  fi
}
PROMPT_COMMAND='add_line'


#add path of google cloud sdk
script_link="$( readlink "$BASH_SOURCE" )" || script_link="$BASH_SOURCE"
apparent_sdk_dir="${script_link%/*}"
if [ "$apparent_sdk_dir" == "$script_link" ]; then
  apparent_sdk_dir=.
fi
sdk_dir="$( command cd -P "$apparent_sdk_dir" > /dev/null && pwd -P )"
bin_path="$sdk_dir/bin"
export PATH=$bin_path:$PATH
_python_argcomplete() {
    local IFS=''
    local prefix=
    typeset -i n
    (( lastw=${#COMP_WORDS[@]} -1))
    if [[ ${COMP_WORDS[lastw]} == --*=* ]]; then
        # for bash version 3.2
        flag=${COMP_WORDS[lastw]%%=*}
        set -- "$1" "$2" '='
    elif [[ $3 == '=' ]]; then
      flag=${COMP_WORDS[-3]}
    fi
    if [[ $3 == ssh  && $2 == *@* ]] ;then
        # handle ssh user@instance specially
        prefix=${2%@*}@
        COMP_LINE=${COMP_LINE%$2}"${2#*@}"
    elif [[ $3 == '=' ]] ; then
        # handle --flag=value
        prefix=$flag=$2
        line=${COMP_LINE%$prefix};
        COMP_LINE=$line${prefix/=/ };
        prefix=
    fi
    if [[ $2 == *,* ]]; then
          # handle , separated list
          prefix=${2%,*},
          set -- "$1" "${2#$prefix}" "$3"
          COMP_LINE==${COMP_LINE%$prefix*}$2
    fi
    # Treat --flag=<TAB> as --flag <TAB> to work around bash 4.x bug
    if [[ ${COMP_LINE} == *=  && ${COMP_WORDS[-2]} == --* ]]; then
        COMP_LINE=${COMP_LINE%=}' '
    fi
    COMPREPLY=( $(IFS="$IFS"                   COMP_LINE="$COMP_LINE"                   COMP_POINT="$COMP_POINT"                   _ARGCOMPLETE_COMP_WORDBREAKS="$COMP_WORDBREAKS"                   _ARGCOMPLETE=1                   "$1" 8>&1 9>&2 1>/dev/null 2>/dev/null) )
    if [[ $? != 0 ]]; then
        unset COMPREPLY
        return
    fi
    if [[ $prefix != '' ]]; then
        for ((n=0; n < ${#COMPREPLY[@]}; n++)); do
            COMPREPLY[$n]=$prefix${COMPREPLY[$n]}
        done
    fi
    for ((n=0; n < ${#COMPREPLY[@]}; n++)); do
        match=${COMPREPLY[$n]%' '}
        if [[ $match != '' ]]; then
            COMPREPLY[$n]=${match//? /' '}' '
        fi
    done
    # if flags argument has a single completion and ends in  '= ', delete ' '
    if [[ ${#COMPREPLY[@]} == 1 && ${COMPREPLY[0]} == -* &&
          ${COMPREPLY[0]} == *'= ' ]]; then
        COMPREPLY[0]=${COMPREPLY[0]%' '}
    fi
}
complete -o nospace -F _python_argcomplete "gcloud"

_completer() {
    command=$1
    name=$2
    eval '[[ "$'"${name}"'_COMMANDS" ]] || '"${name}"'_COMMANDS="$('"${command}"')"'
    set -- $COMP_LINE
    shift
    while [[ $1 == -* ]]; do
          shift
    done
    [[ $2 ]] && return
    grep -q "${name}\s*$" <<< $COMP_LINE &&
        eval 'COMPREPLY=($'"${name}"'_COMMANDS)' &&
        return
    [[ "$COMP_LINE" == *" " ]] && return
    [[ $1 ]] &&
        eval 'COMPREPLY=($(echo "$'"${name}"'_COMMANDS" | grep ^'"$1"'))'
}

unset bq_COMMANDS
_bq_completer() {
    _completer "CLOUDSDK_COMPONENT_MANAGER_DISABLE_UPDATE_CHECK=1 bq help | grep '^[^ ][^ ]*  ' | sed 's/ .*//'" bq
}

complete -F _bq_completer bq
complete -o nospace -F _python_argcomplete gsutil

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/ryomanakagawa/google-cloud-sdk/path.bash.inc' ]; then . '/Users/ryomanakagawa/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/ryomanakagawa/google-cloud-sdk/completion.bash.inc' ]; then . '/Users/ryomanakagawa/google-cloud-sdk/completion.bash.inc'; fi


## 競技プロ用
function makeABCfiles () {
  touch {a,b,c,d,e,f}.cpp
  touch input
}
function mkABCdir () {
  mkdir `pwd`/ABC/$1
  cd ABC/$1
  touch {a,b,c,d,e,f}.cpp
  touch input
  cd ../..
}
function init_abc () {
  cat snippet.txt > a.cpp
  cat snippet.txt > b.cpp
  cat snippet.txt > c.cpp
  cat snippet.txt > d.cpp
  cat snippet.txt > e.cpp
  cat snippet.txt > f.cpp
  echo > input
}

function ojd () {
  if [ -e test ]; then
    rm -r test
  fi
  oj d $1
}

function ojt () {
  if [ $# = 1 ]; then
    g++ $1
  else
    g++ ans.cpp
  fi
  if [ $? != 0 ]; then
    return 1
  fi
  oj t
}

function ojdt () {
  ojd $1
  if [ $? != 0 ]; then
    return 1
  fi
  ojt
}

function ojs () {
  if [ $# = 1 ]; then
    oj s $1
  else 
    oj s ans.cpp
  fi
}

function pjt () {
    if [ $# = 1 ]; then 
        oj t -c "python3 $1"
    else 
        oj t -c "python3 ans.py"
    fi
}

function pjdt () {
    ojd $1
    pjt
}

function impl () { 
  if [ $# = 1 ]; then
    g++ $1
  else
    g++ ans.cpp
  fi
  if [ $? != 0 ]; then
    return 1
  fi
  ./a.out < input; 
  }

function p () {
    if [ $# = 1 ]; then 
        python3 $1 < input 
    else 
        python3 ans.py < input 
    fi 
}
function a () {
  if [ $# = 1 ]; then
    ./a.out < $1
  else
    ./a.out < input
  fi
}
##############
### KAGGLE ###
##############
export KAGGLE_USERNAME=ryomanakagawa
export KAGGLE_KEY=33df9527253d8d7cd4784e539a84a628




