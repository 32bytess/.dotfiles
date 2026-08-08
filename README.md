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

`install.sh` only creates symlinks. It then warns about any commands it cannot
find, but never installs anything.

Theming is dynamic — set a wallpaper with `wallpaper-picker` (or `wallpaper-rofi`)
to regenerate colors across all apps via **wallust**.

## Fresh Fedora install

```sh
./install.sh      # symlink the configs first
./bootstrap.sh    # then install everything they need
```

Order matters: `bootstrap.sh` seeds the generated color files at the end, which
needs the stowed wallust config. Run it with `--dry-run` to see what it would do,
or name packages (`./bootstrap.sh hypr kitty`) to install only their
dependencies. It is idempotent — re-running is a no-op.

That seeding step matters more than it looks: `kitty.conf`, `rofi/theme.rasi`,
`waybar/*/style.css` and `swaync/style.css` all hard-include a wallust-generated
file, so on a fresh box those four apps fail to start until wallust has run once.
`bootstrap.sh` applies a builtin theme to render them.

### Where things come from

Binary and package names diverge a lot here, so check this table before
installing anything by hand:

| Need | Fedora package | Source |
|---|---|---|
| `hyprland`, `xdg-desktop-portal-hyprland` | `hyprland` | **COPR `lionheartp/Hyprland`** |
| `swaync` | `SwayNotificationCenter` | Fedora |
| polkit agent | `polkit-kde` | Fedora |
| `pactl` | `pulseaudio-utils` | Fedora |
| `nm-applet` | `network-manager-applet` | Fedora |
| `thunar` | `Thunar` | Fedora |
| JetBrainsMono + Symbols Nerd Font | `nerd-fonts` | **COPR `che/nerd-fonts`** |
| `yazi` | `yazi` | **COPR `lihaohong/yazi`** |
| `wallust` | — | **`cargo install wallust`** (not packaged anywhere) |
| oh-my-zsh, powerlevel10k, zsh plugins, TPM | — | git clones |

Fedora ships **no Hyprland at all**. The `solopasha/hyprland` COPR is stuck at
0.51, which is too old — this config uses the Lua (`hl`) parser introduced in
0.55, so `lionheartp/Hyprland` is required.

`.zshrc` sources `$ZSH/oh-my-zsh.sh` unguarded, so zsh is broken until the clones
exist; `bootstrap.sh` does them.

### Not installable from anywhere

These are referenced by the configs but have no package and no source in this
repo. Supply them yourself; without them the relevant keybinding or bar module
is simply a no-op:

- `herdr` — wallust reload hook and both `herdr/.local/bin/` scripts
- `waybar-pomodoro` — needed by `pomodoro-tui`
- `wifi-manager` — a keybinding in both WMs and a waybar module
- `appearance-rofi` — a sway keybinding only, already dead

### Deliberately left out

`bootstrap.sh` stays out of flatpak and vendor repos. Install these yourself if
you want them: Obsidian (flatpak `md.obsidian.Obsidian`), Brave, Zen Browser,
VS Code, NordVPN, and `gnome-calendar` (the waybar clock click does nothing
without it).

No wallpapers ship with this repo, and both WMs look for them in
`~/Pictures/wallpapers/wallpapers`.
