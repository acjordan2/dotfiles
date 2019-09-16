## Install

`git clone --recursive https://github.com/acjordan2/dotfiles`

This will pull the following submodules:

- [Fast Syntax-Highlighting](https://github.com/zdharma/fast-syntax-highlighting)
- [ZSh Auto Sugesstions](https://github.com/zsh-users/zsh-autosuggestions)
- [ZSH-Completions](https://github.com/zsh-users/zsh-completions)
- [ZSH-History-Substring Search](https://github.com/zsh-users/zsh-history-substring-search)
- [ZSH-Syntax-Highlighting](https://github.com/zsh-users/zsh-syntax-highlighting) (Soon to be removed)

run `./setup-symlink.sh`, this will create symlinks in your home directory. This is safe to run multiple times and will prompt you about anything unclear. 

**Notes;**

- By default everything will run in tmux for non-SSH sessions if tmux exists.
- Tmux is not aliased to use the config file in .config, so if you run tmux directly, it will default to loading $HOME/.tmux.conf
- All utils use the XDG base dir spec when possbile. 
- Using a recent version of ZSH (5.7+) is recommended

Screenshot:

![](./screenshot.png)
