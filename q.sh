# Used to hook into bash before exec
shopt -s extdebug

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

# Create the register dir, if needed
mkdir -p $HOME/.q

print-regs() {
    # If the dir is not empty, print out each register and it's contents
    if [[ ! -z `ls $HOME/.q` ]]; then
        echo "Registers:"
        for reg in $HOME/.q/*; do
            echo -n " ${reg##*/}: "
            cat $reg
        done
    fi
}

preexec_invoke_exec () {
    [ -n "$COMP_LINE" ] && return  # do nothing if completing
    [ "$BASH_COMMAND" = "$PROMPT_COMMAND" ] && return # don't cause a preexec for $PROMPT_COMMAND
    #local this_command=`HISTTIMEFORMAT= history 1 | sed -e "s/^[ ]*[0-9]*[ ]*//"`;

    BUFFER=$BASH_COMMAND

    if [[ "$BUFFER" =~ ^[$Q_SET$Q_RUN$Q_UNSET][a-zA-Z0-9]* ]]; then
        # If the command already exists, prefer that
        if type "$BASH_REMATCH" > /dev/null 2>&1; then
            return 0
        fi

        # Check if trying to set to an existing command
        if type "q${BASH_REMATCH:1}" > /dev/null 2>&1; then
            echo "Sorry, \"q${MATCH:1}\" is already a command in your \$PATH! :("
            BUFFER=""
            return 1
        fi

        Q_COMMAND=${BASH_REMATCH:0:1}
        REG=${BASH_REMATCH:1}
        ARGS=${BUFFER:${#BASH_REMATCH}}

        # If called without register, show help
        if [[ $REG == "" ]]; then
            echo "q - registers for zsh"
            cat << EOF
Usage:
    $Q_RUN[register] [args]
    $Q_SET[register] [command]
    $Q_UNSET[register]

Setting Registers:
    $Q_SET[register]                     Set register [register] to current directory
    $Q_SET[register] [command]           Set register [register] to [command]

Unsetting Registers:
    $Q_UNSET[register]                     Unset register [register]

Running Registers:
    $Q_RUN[register]                     Run command or cd to directory in register [register]
    $Q_RUN[register] [args]              Run command in register [register] with [args]
EOF
            print-regs
            BUFFER=""
            return 1
        fi

        # If setting a register
        if [[ "$Q_COMMAND" == "$Q_SET" ]]; then
            # If there's no argument
            if [[ "$ARGS" == "" ]]; then
                # Set the register to the current directory
                echo "cd `pwd`" > "$HOME/.q/$REG"
                echo "Register $REG set to `pwd`"
                BUFFER=""
            else
                # Otherwise, set the register to the given command
                echo $ARGS > "$HOME/.q/$REG"
                echo "Register $REG set to $ARGS"
                BUFFER=""
            fi
        # If trying to call a register
        elif [[ "$Q_COMMAND" == "$Q_RUN" ]]; then
            # Check it exists
            if [[ -f "$HOME/.q/$REG" ]]; then
                BUFFER="`cat $HOME/.q/$REG`$ARGS"
            else
                echo "Register $REG is unset."
                BUFFER=""
            fi
        # If unsetting a register
        else
            # Check it exists
            if [[ -f "$HOME/.q/$REG" ]]; then
                rm "$HOME/.q/$REG"
                echo "Unset register $REG."
            else
                echo "Register $REG already unset!"
            fi
            BUFFER=""
        fi
    else
        return 0
    fi

    if [[ ! -z $BUFFER ]]; then
        eval $BUFFER
    fi
    return 1 # This prevent executing of original command
}
trap 'preexec_invoke_exec' DEBUG
