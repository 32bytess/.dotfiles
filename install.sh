#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

info() { echo -e "${BLUE}[info]${NC} $*"; }
success() { echo -e "${GREEN}[ok]${NC} $*"; }
warn() { echo -e "${YELLOW}[warn]${NC} $*"; }

# DNF packages

DNF_PACKAGES=(
  git
  stow
  zsh
  neovim
  tmux
  kitty
  fira-code-fonts
  swayfx
  waybar
  swaync
  wofi
  grim
  slurp
  wl-clipboard
  brightnessctl
  playerctl
  blueman
  kanshi
  pavucontrol
  network-manager-applet
)

install_dnf_packages() {
  info "Installing DNF packages..."

  local to_install=()
  for pkg in "${DNF_PACKAGES[@]}"; do
    if ! rpm -q "$pkg" &>/dev/null; then
      to_install+=("$pkg")
    fi
  done

  if [[ ${#to_install[@]} -gt 0 ]]; then
    sudo dnf install -y "${to_install[@]}"
    success "Installed: ${to_install[*]}"
  else
    success "All DNF packages already installed."
  fi
}

# Flatpak

FLATPAK_APPS=(
  md.obsidian.Obsidian
  com.spotify.Client
  org.onlyoffice.desktopeditors
  org.zotero.Zotero
)

install_flatpaks() {
  info "Installing Flatpak apps..."

  if ! command -v flatpak &>/dev/null; then
    sudo dnf install -y flatpak
    sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
  fi

  local to_install=()
  for app in "${FLATPAK_APPS[@]}"; do
    if ! flatpak list --app --columns=application 2>/dev/null | grep -q "^${app}$"; then
      to_install+=("$app")
    fi
  done

  if [[ ${#to_install[@]} -gt 0 ]]; then
    flatpak install -y flathub "${to_install[@]}"
    success "Installed flatpaks: ${to_install[*]}"
  else
    success "All Flatpak apps already installed."
  fi
}

# Stow dotfiles

STOW_PACKAGES=(
  zsh
  nvim
  tmux
  kitty
  code
  obsidian
  sway
  waybar
)

stow_dotfiles() {
  info "Stowing dotfiles from $DOTFILES_DIR..."
  cd "$DOTFILES_DIR"

  for pkg in "${STOW_PACKAGES[@]}"; do
    if [[ -d "$pkg" ]]; then
      stow --restow "$pkg"
      success "Stowed: $pkg"
    else
      warn "Package directory not found, skipping: $pkg"
    fi
  done
}

# Post-install setup

setup_zsh_default() {
  if [[ "$SHELL" != "$(which zsh)" ]]; then
    info "Setting zsh as default shell..."
    chsh -s "$(which zsh)"
    success "Default shell set to zsh"
  else
    success "Zsh is already the default shell."
  fi
}

setup_oh_my_zsh() {
  local omz_dir="$HOME/.config/zsh/.oh-my-zsh"
  if [[ ! -d "$omz_dir" ]]; then
    info "Installing Oh My Zsh..."
    git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git "$omz_dir"
    success "Oh My Zsh installed at $omz_dir."
  else
    success "Oh My Zsh already installed."
  fi
}

setup_tmux_tpm() {
  local tpm_dir="$HOME/.tmux/plugins/tpm"
  if [[ ! -d "$tpm_dir" ]]; then
    info "Installing TPM ..."
    git clone https://github.com/tmux-plugins/tpm "$tpm_dir"
    success "TPM installed. Run <prefix>I inside tmux to install plugins."
  else
    success "TPM already installed."
  fi
}

setup_p10k() {
  local p10k_dir="$HOME/.config/zsh/.oh-my-zsh/custom/themes/powerlevel10k"
  if [[ ! -d "$p10k_dir" ]]; then
    info "Installing Powerlevel10k..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$p10k_dir"
    success "Powerlevel10k installed."
  else
    success "Powerlevel10k already installed."
  fi
}

# main

main() {
  echo "Dotfiles installer"
  echo ""

  install_dnf_packages
  echo ""
  install_flatpaks
  echo ""
  stow_dotfiles
  echo ""
  setup_oh_my_zsh
  setup_p10k
  setup_zsh_default
  setup_tmux_tpm

  echo ""
  success "Done! Open a new shell to load zsh config."
  warn "Inside tmux, press <prefix>I to install tmux plugins."
}

main "$@"
