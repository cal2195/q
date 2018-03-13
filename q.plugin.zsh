ZSH_HIGHLIGHT_HIGHLIGHTERS=(main regexp)
ZSH_HIGHLIGHT_REGEXP+=('\bq.\b' 'fg=green,bold')
ZSH_HIGHLIGHT_REGEXP+=('\bQ.\b' 'fg=green,bold')

read -d '' Q_HELP <<EOF
q - registers for zsh

Usage: q[char] [args]
       Q[char] [command]

Setting Registers:
 Q[char]                     Set register [char] to current directory
 Q[char] [command]           Set register [char] to [command]

Running Registers:
 q[char]                     Run command or cd to directory in register [char]
 q[char] [args]              Run command in register [char] with [args]
EOF

q-accept-line() {
    if [[ "${BUFFER}" == "q" || "${BUFFER}" == "Q" ]]; then
        echo "\n$Q_HELP"
        BUFFER=""
    else
        if [[ "${BUFFER:0:1}" == "Q" ]]; then
            if [[ "${BUFFER:2:1}" == "" ]]; then
                echo "cd `pwd`" > "$HOME/.q/${BUFFER:1:1}"
                echo "\nRegister ${BUFFER:1:1} set to `pwd`"
                BUFFER=""
            fi
            if [[ "${BUFFER:2:1}" == " " ]]; then
                echo ${BUFFER:3} > "$HOME/.q/${BUFFER:1:1}"
                echo "\nRegister ${BUFFER:1:1} set to ${BUFFER:3}"
                BUFFER=""
            fi
        fi
        if [[ "${BUFFER:0:1}" == "q" && ( "${BUFFER:2:1}" == "" || "${BUFFER:2:1}" == " " ) ]]; then
            if [[ -f "$HOME/.q/${BUFFER:1:1}" ]]; then
                BUFFER="`cat $HOME/.q/${BUFFER:1:1}`${BUFFER:2}"
            else
                echo "\nRegister ${BUFFER:1:1} is unset."
                BUFFER=""
            fi
        fi
    fi
    zle .accept-line
}

zle -N accept-line q-accept-line
