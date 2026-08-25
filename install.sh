#!/usr/bin/env bash
#
# Bootstrap script: symlink stow packages into $HOME.
#
#   ./install.sh            # stow every package
#   ./install.sh zsh kitty  # stow only the named packages
#   ./install.sh -h         # help
#
# Each top-level directory is a GNU Stow package, except the meta dirs below.
set -euo pipefail

cd "$(dirname "$(readlink -f "$0")")"

# Directories that are not stow packages. `system/` holds the few files that
# have to live outside $HOME (see system/README.md); they are installed by hand
# with sudo, never symlinked.
NON_PACKAGES=(.git .claude system)

# Runtime commands each package expects. Purely advisory: missing entries are
# reported at the end and never abort the run, since a config is still worth
# symlinking on a machine where you have not installed the app yet.
SESSION_DEPS="waybar rofi swaybg swaync swaync-client swaylock grim slurp wl-copy
	pactl playerctl brightnessctl pavucontrol wdisplays nm-applet blueman-applet
	bluetoothctl nmcli kwalletd6 wallust"

declare -A DEPS=(
	[hypr]="hyprland hyprctl $SESSION_DEPS"
	[sway]="sway swaymsg swaynag $SESSION_DEPS"
	[waybar]="waybar"
	[swaync]="swaync swaync-client"
	[rofi]="rofi"
	[kitty]="kitty"
	[zsh]="zsh git"
	[tmux]="tmux git fzf"
	[yazi]="yazi nvim"
	[wallust]="wallust"
	[scripts]="rofi python3 jq"
	[herdr]="herdr fzf jq"
	[obsidian]="flatpak"
	[code]="code"
)

usage() {
	sed -n '3,8p' "$0" | sed 's/^# \{0,1\}//'
	exit "${1:-0}"
}

is_non_package() {
	local d=$1
	for n in "${NON_PACKAGES[@]}"; do
		[[ "$d" == "$n" ]] && return 0
	done
	return 1
}

[[ "${1:-}" == "-h" || "${1:-}" == "--help" ]] && usage 0

if ! command -v stow >/dev/null 2>&1; then
	echo "error: GNU Stow is not installed; install the 'stow' package first." >&2
	exit 1
fi

# Determine the package list: explicit args, or auto-discovered directories.
if [[ "$#" -gt 0 ]]; then
	packages=("$@")
else
	packages=()
	for d in */; do
		d=${d%/}
		is_non_package "$d" && continue
		packages+=("$d")
	done
fi

for pkg in "${packages[@]}"; do
	if [[ ! -d "$pkg" ]]; then
		echo "skip: '$pkg' is not a directory" >&2
		continue
	fi
	echo "stow: $pkg"
	stow --restow --target="$HOME" "$pkg"
done

echo "Done. Stowed: ${packages[*]}"

# Advisory dependency check over the packages that were actually stowed.
missing_report=()
for pkg in "${packages[@]}"; do
	[[ -d "$pkg" ]] || continue
	missing=()
	for cmd in ${DEPS[$pkg]:-}; do
		command -v "$cmd" >/dev/null 2>&1 || missing+=("$cmd")
	done
	[[ "${#missing[@]}" -gt 0 ]] && missing_report+=("  $pkg: ${missing[*]}")
done

if [[ "${#missing_report[@]}" -gt 0 ]]; then
	echo
	echo "warning: these commands are not on PATH; the configs are installed"
	echo "but the corresponding packages will not work until you install them:"
	printf '%s\n' "${missing_report[@]}"
	echo
	echo "On Fedora, run ./bootstrap.sh to install them."
fi
