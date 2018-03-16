# Load the regex module for regex expressions
zmodload zsh/regex

# Integrate with zsh-syntax-highlighter
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main regexp)
ZSH_HIGHLIGHT_REGEXP+=('\bq.?\b' 'fg=green,bold')
ZSH_HIGHLIGHT_REGEXP+=('\bQ.?\b' 'fg=green,bold')
ZSH_HIGHLIGHT_REGEXP+=('\bU.\b' 'fg=green,bold')

# Setup the Q_HELP var
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

# Create the register dir, if needed
mkdir -p $HOME/.q

print-regs() {
    # If the dir is not empty, print out each register and it's contents
    if [[ ! -z `ls $HOME/.q` ]]; then
        echo "\nRegisters:"
        for reg in $HOME/.q/*; do
            echo -n " ${reg##*/}: "
            cat $reg
        done
    fi
}

q-accept-line() {
    # Check if we've been called with no arguments
    if [[ "${BUFFER}" == "q" || "${BUFFER}" == "Q" ]]; then
        echo "\nq - registers for zsh"
        echo "\n$Q_HELP"
        print-regs
        BUFFER=""
    # Check if a register is being called or set
    elif [[ "$BUFFER" -regex-match "^[Qq][a-zA-Z0-9]( (.*))?$" ]]; then
        # Parse out the command
        Q_COMMAND=${BUFFER:0:1}
        REG=${BUFFER:1:1}
        ARG=${BUFFER:2:1}

        # If trying to set a registers
        if [[ "$Q_COMMAND" == "Q" ]]; then
            # If there's no argument
            if [[ "$ARG" == "" ]]; then
                # Set the register to the current directory
                echo "cd `pwd`" > "$HOME/.q/$REG"
                echo "\nRegister $REG set to `pwd`"
                BUFFER=""
            elif [[ "$ARG" == " " ]]; then
                # Otherwise, set the register to the given command
                echo ${BUFFER:3} > "$HOME/.q/$REG"
                echo "\nRegister $REG set to ${BUFFER:3}"
                BUFFER=""
            fi
        # If trying to call a register
        else
            if [[ -f "$HOME/.q/$REG" ]]; then
                BUFFER="`cat $HOME/.q/$REG`${BUFFER:2}"
            else
                echo "\nRegister $REG is unset."
                BUFFER=""
            fi
        fi
    # Otherwise, if trying to unset a register
    elif [[ "$BUFFER" -regex-match "^U[a-zA-Z0-9]$" ]]; then
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
    # Accept the line with the new BUFFER
    zle .accept-line
}

# Replace the accept-line event with our own
zle -N accept-line q-accept-line
