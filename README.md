# Dotfiles

This repo contains my personal configuration files managed using **GNU Stow**. The setup is designed for a consistent user experience across terminal and GUI applications, with a strong emphasis on Vim-style keybindings

---

- **WM:** [Sway](https://swaywm.org/) & [Hyprland](https://hyprland.org/) (Wayland)
- **Theming:** [Wallust](https://github.com/onur/wallust) 
- **Terminal:** [Kitty](https://sw.kovidgoyal.net/kitty/)
- **Shell:** Zsh
- **Editor:** [Neovim](https://neovim.io/) ([my config](https://github.com/albertoodev/nvim))
- **Multiplexer:** Tmux
- **File Manager:** Yazi
- **Launcher:** Rofi

---

## Setup

Managed with [GNU Stow](https://www.gnu.org/software/stow/). Clone, then run the
bootstrap script to symlink every package into `~`:

```sh
git clone https://github.com/albertoodev/dotfiles ~/dotfiles
cd ~/dotfiles
./install.sh              # all packages
./install.sh zsh kitty    # or just specific ones
```

Theming is dynamic — set a wallpaper with `wallpaper-picker` (or `wallpaper-rofi`)
to regenerate colors across all apps via **wallust**.
