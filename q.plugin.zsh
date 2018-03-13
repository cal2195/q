ZSH_HIGHLIGHT_HIGHLIGHTERS=(main regexp)
ZSH_HIGHLIGHT_REGEXP+=('\bq.?\b' 'fg=green,bold')
ZSH_HIGHLIGHT_REGEXP+=('\bQ.?\b' 'fg=green,bold')
ZSH_HIGHLIGHT_REGEXP+=('\bU.\b' 'fg=green,bold')
zmodload zsh/regex

read -d '' Q_HELP <<EOF
Usage: q[char] [args]
       Q[char] [command]
       U[char]

Setting Registers:
 Q[char]                     Set register [char] to current directory
 Q[char] [command]           Set register [char] to [command]

Unsetting Registers:
 U[char]                     Unset register [char]

Running Registers:
 q[char]                     Run command or cd to directory in register [char]
 q[char] [args]              Run command in register [char] with [args]
EOF

mkdir -p $HOME/.q

print-regs() {
    if [[ ! -z `ls $HOME/.q` ]]; then
        echo "\nRegisters:"
        for reg in $HOME/.q/*; do
            echo -n " ${reg##*/}: "
            cat $reg
        done
    fi
}

q-accept-line() {
    if [[ "${BUFFER}" == "q" || "${BUFFER}" == "Q" ]]; then
        echo "\nq - registers for zsh"
        echo "\n$Q_HELP"
        print-regs
        BUFFER=""
    elif [[ "$BUFFER" -regex-match "^[Qq][a-z]( (.*))?$" ]]; then
        Q_COMMAND=${BUFFER:0:1}
        REG=${BUFFER:1:1}
        ARG=${BUFFER:2:1}

        if [[ "$Q_COMMAND" == "Q" ]]; then
            if [[ "$ARG" == "" ]]; then
                echo "cd `pwd`" > "$HOME/.q/$REG"
                echo "\nRegister $REG set to `pwd`"
                BUFFER=""
            elif [[ "$ARG" == " " ]]; then
                echo ${BUFFER:3} > "$HOME/.q/$REG"
                echo "\nRegister $REG set to ${BUFFER:3}"
                BUFFER=""
            fi
        else
            if [[ -f "$HOME/.q/$REG" ]]; then
                BUFFER="`cat $HOME/.q/$REG`${BUFFER:2}"
            else
                echo "\nRegister $REG is unset."
                BUFFER=""
            fi
        fi
    elif [[ "$BUFFER" -regex-match "^U[a-z]$" ]]; then
        Q_COMMAND=${BUFFER:0:1}
        REG=${BUFFER:1:1}

        if [[ -f "$HOME/.q/$REG" ]]; then
            rm "$HOME/.q/$REG"
            echo "\nUnset register $REG."
        else
            echo "\nRegister $REG already unset!"
        fi
        BUFFER=""
    fi
    zle .accept-line
}

zle -N accept-line q-accept-line
