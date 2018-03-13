# q - registers for your zsh shell
**q** implements vim like macro registers in your zsh shell!

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

### Usage Help
```
q - registers for zsh

Usage: q[char] [args]
       Q[char] [command]

Setting Registers:
 Q[char]                     Set register [char] to current directory
 Q[char] [command]           Set register [char] to [command]

Running Registers:
 q[char]                     Run command or cd to directory in register [char]
 q[char] [args]              Run command in register [char] with [args]

```
