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
- i3 configuration (feh rofi picom)
- Some useful bash files

Currently Vim is independent and not included in this repository, go to [here](https://github.com/Lesords/vim-config)

# Installation

## Dependencies

Ubuntu

```bash
# i3 related tools
sudo apt install i3 i3status i3lock dmenu i3blocks feh rofi picom polybar -y

# for nm-applet
sudo apt install network-manager-gnome

# rime
sudo apt install fcitx5 fcitx5-rime fcitx5-chinese-addons fcitx5-configtool
git clone --depth=1 https://github.com/iDvel/rime-ice.git ~/.local/share/fcitx5/rime

# polkit
sudo apt install policykit-1-gnome

# flameshot
sudo apt install flameshot
```

Fedora

```bash
# Xorg
sudo dnf install xorg-x11-server-Xorg xorg-x11-xinit -y

# i3 related tools
sudo dnf install i3 i3lock feh rofi picom polybar -y

# for nm-applet
sudo dnf install network-manager-applet

# polkit
sudo dnf install lxqt-policykit -y

# flameshot
sudo dnf install flameshot -y
```

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

## i3

| Shortcut Keys   | Action              |
| --------------- | ------------------- |
| mod + shift + q | kill current window |
| mod + shift + c | reload              |
| mod + shift + r | restart             |
| mod + shift + e | exit                |
| mod + -         | move to scratchpad  |
| mod + shift + - | show scratchpad     |
| mod + i | split in horizontal |
| mod + u | split in vertical   |
| mod + s | stacked layout      |
| mod + t | tabbed layout       |
| mod + w | toggle split        |
| mod + f | toggle floating     |
| mod + a | focus parent        |
| mod + d | focus child         |
| mod + h         | focus left    |
| mod + j         | focus down    |
| mod + k         | focus up      |
| mod + l         | focus right   |
| mod + shift + h | move left     |
| mod + shift + j | move down     |
| mod + shift + k | move up       |
| mod + shift + l | move right    |
| mod + space     | toggle mode   |
| mod + r         | resize window |
| mod + z         | fullscreen    |
| mod + return    | start a terminal        |
| mod + e         | start thunar            |
| mod + n         | app launcher with rofi  |
| mod + o         | window switch with rofi |
| mod + y         | greenclip with rofi     |
| mod + p         | power menu with rofi    |
| mod + shift + s | area screenshot         |
| Print           | full-screen screenshot  |
| mod + num         | switch to num workspace |
| mod + shift + num | move to num workspace   |
| mod + tab         | switch workspace        |
| mod + ctrl + left  | switch to previous workspace |
| mod + ctrl + right | switch to next workspace     |
| mod + [ | focus to previous monitor |
| mod + ] | focus to next monitor     |
| mod + , | focus to previous monitor |
| mod + . | focus to next monitor     |
| mod + { | switch to previous workspace(current monitor) |
| mod + } | switch to next workspace(current monitor)     |

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
| Copy   | r             | Open the current file in another panel using vim  |

## Kitty

| Shortcut Keys | Action              |
| ------------- | ------------------- |
| Ctrl + Shift + enter | New window   |
| Ctrl + Shift + c | Copy to clipboard     |
| Ctrl + Shift + v | Paste from clipboard  |
| Ctrl + Shift + s | Paste from selection  |
| Ctrl + Shift + l | Switch to next layout   |
| Ctrl + Shift + n | Open another window     |
| Ctrl + Shift + w | Close window      |
| Ctrl + Shift + [ | Previous window   |
| Ctrl + Shift + ] | Next window       |
| Ctrl + Shift + b | Move window backward  |
| Ctrl + Shift + f | Move window forward   |
| Ctrl + Shift + t | New tab   |
| Ctrl + Shift + q | Close tab |
| Ctrl + Shift + left    | Previous tab |
| Ctrl + Shift + right   | Next tab     |
| Ctrl + Shift + ,       | Move tab backward |
| Ctrl + Shift + .       | Move tab forward  |
| Ctrl + Shift + Alt + t | Set tab title  |
| Ctrl + Shift + g | View output of last command  |
| Ctrl + Shift + e | Click URL with keyboard  |
| Ctrl + Shift + u | Input unicode character  |

## Neovim

[nvim](./.config/nvim/README.md)
