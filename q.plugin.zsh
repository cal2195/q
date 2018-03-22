# Load the regex module for regex expressions
zmodload zsh/regex

# Check for a custom Q command
# Check if Q_SET is defined
if [[ -z $Q_SET ]]; then
    Q_SET="Q"
elif type "$Q_SET" > /dev/null; then
    echo "$Q_SET already exists in your path, using default Q."
    Q_SET="Q"
fi

# Check if Q_RUN is defined
if [[ -z $Q_RUN ]]; then
    Q_RUN='q'
elif type "$Q_RUN" > /dev/null; then
    echo "$Q_RUN already exists in your path, using default q."
    Q_RUN='q'
fi

# Check if Q_UNSET is defined
if [[ -z $Q_UNSET ]]; then
    Q_UNSET='U'
elif type "$Q_UNSET" > /dev/null; then
    echo "$Q_UNSET already exists in your path, using default U."
    Q_UNSET='U'
fi

# Integrate with zsh-syntax-highlighter
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main regexp)
ZSH_HIGHLIGHT_REGEXP+=('\b$Q_RUN.*\b' 'fg=green,bold')
ZSH_HIGHLIGHT_REGEXP+=('\b$Q_SET.*\b' 'fg=green,bold')
ZSH_HIGHLIGHT_REGEXP+=('\b$Q_UNSET.*\b' 'fg=green,bold')

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
    if [[ "$BUFFER" =~ "^[$Q_SET$Q_RUN$Q_UNSET][a-zA-Z0-9]*" ]]; then
        # If the command already exists, prefer that
        if type "$MATCH" > /dev/null; then
            zle .accept-line
            return
        fi

        # Check if trying to set to an existing command
        if type "q${MATCH:1}" > /dev/null; then
            echo "\nSorry, \"q${MATCH:1}\" is already a command in your \$PATH! :("
            BUFFER=""
            zle .accept-line
            return
        fi

        Q_COMMAND=${MATCH:0:1}
        REG=${MATCH:1}
        ARGS=${BUFFER:${#MATCH}}

        # If called without register, show help
        if [[ $REG == "" ]]; then
            echo "\nq - registers for zsh"
            cat << EOF
Usage:
    $Q_RUN[register] [args]
    $Q_SET[register] [command]
    $Q_UNSET[register]

Setting Registers:
    $Q_SET[register]                     Set register [register] to current directory
    $Q_SET[register] [command]           Set register [register] to [command]

Unsetting Registers:
    $Q_UNSET[register]                   Unset register [register]

Running Registers:
    $Q_RUN[register]                     Run command or cd to directory in register [register]
    $Q_RUN[register] [args]              Run command in register [register] with [args]
EOF
            print-regs
            BUFFER=""
            zle .accept-line
            return
        fi

        # If setting a register
        if [[ "$Q_COMMAND" == $Q_SET ]]; then
            # If there's no argument
            if [[ "$ARGS" == "" ]]; then
                # Set the register to the current directory
                echo "cd `pwd`" > "$HOME/.q/$REG"
                echo "\nRegister $REG set to `pwd`"
                BUFFER=""
            else
                # Otherwise, set the register to the given command
                echo $ARGS > "$HOME/.q/$REG"
                echo "\nRegister $REG set to $ARGS"
                BUFFER=""
            fi
        # If trying to call a register
        elif [[ "$Q_COMMAND" == $Q_RUN ]]; then
            # Check it exists
            if [[ -f "$HOME/.q/$REG" ]]; then
                BUFFER="`cat $HOME/.q/$REG`$ARGS"
            else
                echo "\nRegister $REG is unset."
                BUFFER=""
            fi
        # If unsetting a register
        else
            # Check it exists
            if [[ -f "$HOME/.q/$REG" ]]; then
                rm "$HOME/.q/$REG"
                echo "\nUnset register $REG."
            else
                echo "\nRegister $REG already unset!"
            fi
            BUFFER=""
        fi
    fi

    # Accept the line with the new BUFFER
    zle .accept-line
}

# Replace the accept-line event with our own
zle -N accept-line q-accept-line
