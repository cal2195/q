# q - registers for your zsh shell
**q** implements vim like macro registers in your zsh shell!

> Dynamic Terminal Aliases and Bookmarks On The Go!

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

**q** commands start with the prefix `Q` for setting registers, `q` for executing registers, and `U` for unsetting registers.

Register names can be any alphanumeric string! Command that already exist in your `$PATH` take priority:

```
> Qutebrowser
Sorry, "qutebrowser" already exists in your $PATH! :(
```

### Saving directories

To set a register, navigate to the directory and use the command `Q`:
```
> cd ~/fyp/experiments
> Qfe
Register fe set to /home/cal/fyp/experiments
```

To then `cd` to that directory, just use `q`:
```
> qfe
cd /home/cal/fyp/experiments
```

### Saving commands

To save a command to a register, just add it after the register:
```
> Qi3c vim ~/.config/i3/config
Register i3c set to vim ~/.config/i3/config
```

Then you can call up vim using `q`:
```
> qi3c
vim ~/.config/i3/config
```

You can also add arguments!
```
> Qv vim
Register v set to vim
> qv .zsh/alias.zsh
vim .zsh/alias.zsh
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

Usage: q[register] [args]
       Q[register] [command]
       U[register]

Setting Registers:
 Q[register]                     Set register [register] to current directory
 Q[register] [command]           Set register [register] to [command]

Unsetting Registers:
 U[register]                     Unset register [register]

Running Registers:
 q[register]                     Run command or cd to directory in register [register]
 q[register] [args]              Run command in register [register] with [args]

Registers:
 c: cd /home/cal/.config
 f: cd /home/cal/data/college/fyp
 g: cd /home/cal/data/git
 x: cd /home/cal/data/college/fyp/experiments
```

### Unsetting Registers

To unset a register, simply use the `U` command:
```
> Uh
Unset register h.
```

### Usage Help

```
q - registers for zsh

Usage: q[register] [args]
       Q[register] [command]
       U[register]

Setting Registers:
 Q[register]                     Set register [register] to current directory
 Q[register] [command]           Set register [register] to [command]

Unsetting Registers:
 U[register]                     Unset register [register]

Running Registers:
 q[register]                     Run command or cd to directory in register [register]
 q[register] [args]              Run command in register [register] with [args]

Registers:
 c: cd /home/cal/.config
 f: cd /home/cal/data/college/fyp
 g: cd /home/cal/data/git
 x: cd /home/cal/data/college/fyp/experiments
```
