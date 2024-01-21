# Introduction

This is my linux configuration

Here's what I have configured so far:

- vim configuration and plugins (submodules)
- tmux configuration and plugins
- lazygit configuration
- ranger configuration
- vifm configuration
- Some useful bash files

# Installation

## Manual

Clone the repository with the following command

```bash
cd ~
git clone git@github.com:Lesords/dotfiles.git --depth 1 --recurse-submodules --shallow-submodules
```

Then select the desired configuration file to move to the user directory


## Git

Use the following command to automatically move all configuration files to the user directory

```bash
cd ~
git clone --bare git@github.com:Lesords/dotfiles.git --depth 1

git --git-dir=$HOME/dotfiles.git/ --work-tree=$HOME checkout

git --git-dir=$HOME/dotfiles.git/ --work-tree=$HOME submodule update --init --recursive --depth 1
```
