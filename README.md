# q - registers for your zsh shell
**q** implements vim like macro registers in your zsh shell!

## Installation

### Antigen

Simply place this line in your `.antigenrc`:
```
antigen bundle cal2195/q
```

**NB:** if you use `zsh-users/zsh-syntax-highlighting`, make sure you place `antigen bundle cal2195/q` below it! :)

### Manual

Download `q.plugin.zsh` to somewhere and place this line in your `.zshrc`:
```
source /path/to/q.plugin.zsh
```

## Usage

### Saving directories

To set a register, use the command `Q`:
```
Q[char] # Saves the current directory in register [char]
```

For example, to save the current directory in register `x`:
```
> Qx
Register x set to /home/cal
```

To then `cd` to that directory, just use `q`:
```
> qx
cd /home/cal
```

### Saving commands

To save a command to a register, just add it after the register:
```
> Qv vim
Register v set to vim
```

Then you can call up vim using `q`:
```
> qv
vim
```

You can also add arguments!
```
> qv .zshrc
vim .zshrc
```

Useful for longer commands:
```
> Qy yaourt -Syyu
Register y set to yaourt -Syyu
> qy
yaourt -Syyu
:: Synchronising package databases...
...
```

### Listing register contents

To see what registers you have set and their contents, just type `q`:

```
> q
q - registers for zsh

Registers:
 c: cd /home/cal/.config
 f: cd /home/cal/data/college/fyp
 g: cd /home/cal/data/git
 x: cd /home/cal/data/college/fyp/experiments

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
```

### Unsetting Registers

To unset a register, simply use the `U` command:
```
> Uh
Unset register h.
```

### Usage Helpq - registers for zsh

```
q - registers for zsh

Registers:
 c: cd /home/cal/.config
 f: cd /home/cal/data/college/fyp
 g: cd /home/cal/data/git
 x: cd /home/cal/data/college/fyp/experiments

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

```
