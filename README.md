# Introduction

This is my linux configuration

Here's what I have configured so far:

- tmux configuration and plugins
- lazygit configuration
- ranger configuration
- vifm configuration
- joshuto configuration
- btop configuration
- delta configuration
- Some useful bash files

Currently Vim is independent and not included in this repository, go to [here](https://github.com/Lesords/vim-config)

# Installation

## Manual

Clone the repository with the following command

```bash
cd ~
git clone git@github.com:Lesords/dotfiles.git --depth 1 --recurse-submodules --shallow-submodules

# Or
git clone https://github.com/Lesords/dotfiles.git --depth 1 --recurse-submodules --shallow-submodules
```

Next, use the following command to move the configuration file to the user directory

```bash
cd dotfiles
./dot install
```

After the file move is complete, you can verify the configuration file using the following command

```bash
./dot status
./dot diff
```

Then, you can use the following command to bring the configuration file into effect

```bash
~/.config/lese/init.sh --config
```

Finally restart your terminal

## Git

Use the following command to automatically move all configuration files to the user directory

```bash
cd ~
git clone --bare git@github.com:Lesords/dotfiles.git --depth 1
# Or
git clone --bare https://github.com/Lesords/dotfiles.git --depth 1

git --git-dir=$HOME/dotfiles.git/ --work-tree=$HOME checkout

git --git-dir=$HOME/dotfiles.git/ --work-tree=$HOME submodule update --init --recursive --depth 1
```

# Keymaps

## tmux

| Mode   | Shortcut Keys | Action             |
| ------ | ------------- | ------------------ |
| Normal | Ctrl + h      | Go to left panel   |
| Normal | Ctrl + j      | Go to down panel   |
| Normal | Ctrl + k      | Go to up panel     |
| Normal | Ctrl + l      | Go to right panel  |
| Normal | Prefix + Tab  | Open extrakto      |
| Normal | Prefix + Ctrl + s  | Save Tmux environment      |
| Normal | Prefix + Ctrl + r  | Restore Tmux environment   |
| Normal | Prefix + /         | Search with regex                        |
| Normal | Prefix + Ctrl + f  | Search simple file                       |
| Normal | Prefix + Ctrl + g  | Jumping over git status files            |
| Normal | Prefix + Alt + h   | Jumping over SHA-1/SHA-256 hashes        |
| Normal | Prefix + Ctrl + u  | Search url (http, ftp and git urls)      |
| Normal | Prefix + Ctrl + d  | Search number (mnemonic d, as digit)     |
| Normal | Prefix + Alt + i   | Search ip address                        |
| Copy   | o             | Open a highlighted selection with the system default program                           |
| Copy   | Ctrl + o      | Open a highlighted selection with the $EDITOR                                          |
| Copy   | Shift + s     | Search the highlighted selection directly inside a search engine (defaults to google)  |
