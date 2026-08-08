#!/usr/bin/env bash
#
# Provision a Fedora install with everything these dotfiles need.
#
#   ./install.sh && ./bootstrap.sh   # the fresh-install flow
#   ./bootstrap.sh hypr kitty        # only what those packages need
#   ./bootstrap.sh --dry-run         # show what would happen, change nothing
#   ./bootstrap.sh -h                # help
#
# Run install.sh first: the theme-seeding step needs the stowed wallust config.
# Safe to re-run -- every step checks before it acts.
set -euo pipefail

cd "$(dirname "$(readlink -f "$0")")"

DRY_RUN=0

usage() {
	sed -n '3,10p' "$0" | sed 's/^# \{0,1\}//'
	exit "${1:-0}"
}

# Directories that are not stow packages (mirrors install.sh).
NON_PACKAGES=(.git .claude)

# Everything a graphical session needs regardless of which compositor runs it.
SESSION="waybar SwayNotificationCenter rofi swaybg swaylock grim slurp
	wl-clipboard wdisplays pulseaudio-utils playerctl brightnessctl pavucontrol
	network-manager-applet blueman kf6-kwallet polkit-kde nerd-fonts
	papirus-icon-theme"

# Fedora package names per stow package. Note these are *package* names, which
# often differ from the command they provide: swaync -> SwayNotificationCenter,
# pactl -> pulseaudio-utils, nm-applet -> network-manager-applet,
# the polkit agent -> polkit-kde. The union is deduplicated before installing.
declare -A PKGS=(
	[base]="stow git-core jq fzf xdg-utils python3"
	[hypr]="hyprland xdg-desktop-portal-hyprland xdg-desktop-portal-gtk $SESSION"
	[sway]="sway xdg-desktop-portal-wlr xdg-desktop-portal-gtk $SESSION"
	[waybar]="waybar nerd-fonts"
	[swaync]="SwayNotificationCenter nerd-fonts"
	[rofi]="rofi papirus-icon-theme nerd-fonts"
	[kitty]="kitty nerd-fonts"
	[zsh]="zsh git-core"
	[tmux]="tmux git-core fzf"
	[yazi]="yazi neovim"
	[wallust]="cargo"
	[scripts]="rofi python3 jq"
	[herdr]="fzf jq"
	# obsidian and code are installed from flatpak / vendor repos, which this
	# script deliberately stays out of. See README.
	[obsidian]=""
	[code]=""
)

# COPRs, and the packages that only exist there. A COPR is enabled only when one
# of its packages actually turns out to be missing.
declare -A COPRS=(
	[lionheartp/Hyprland]="hyprland xdg-desktop-portal-hyprland"
	[che/nerd-fonts]="nerd-fonts"
	[lihaohong/yazi]="yazi"
)

# Git-cloned shell deps: "destination|repo|depth". .zshrc sources
# $ZSH/oh-my-zsh.sh unguarded, so zsh is broken until these exist.
ZDOT=${ZDOTDIR:-$HOME/.config/zsh}
OMZ=$ZDOT/.oh-my-zsh
CLONES=(
	"$OMZ|https://github.com/ohmyzsh/ohmyzsh|1"
	"$OMZ/custom/themes/powerlevel10k|https://github.com/romkatv/powerlevel10k|1"
	"$OMZ/custom/plugins/zsh-autosuggestions|https://github.com/zsh-users/zsh-autosuggestions|1"
	"$OMZ/custom/plugins/zsh-syntax-highlighting|https://github.com/zsh-users/zsh-syntax-highlighting|1"
	"$HOME/.config/tmux/plugins/tpm|https://github.com/tmux-plugins/tpm|1"
)

# Builtin wallust theme used to seed the generated color files on a fresh box.
SEED_THEME=${WALLUST_SEED_THEME:-Afterglow}

say() { printf '\n== %s\n' "$*"; }
skip() { printf '   skip: %s\n' "$*"; }
run() {
	printf '   $ %s\n' "$*"
	[[ "$DRY_RUN" -eq 1 ]] || "$@"
}

is_non_package() {
	local d=$1
	for n in "${NON_PACKAGES[@]}"; do
		[[ "$d" == "$n" ]] && return 0
	done
	return 1
}

args=()
for arg in "$@"; do
	case "$arg" in
	-h | --help) usage 0 ;;
	-n | --dry-run) DRY_RUN=1 ;;
	-*)
		echo "error: unknown option '$arg'" >&2
		usage 1 >&2
		;;
	*) args+=("$arg") ;;
	esac
done

[[ "$DRY_RUN" -eq 1 ]] && echo "(dry run: nothing will be changed)"

# --- step 1: this script only knows Fedora -----------------------------------

distro=$(. /etc/os-release 2>/dev/null && echo "${ID:-unknown}" || echo unknown)
if [[ "$distro" != "fedora" ]]; then
	echo "error: this bootstrap is Fedora-specific (detected: $distro)." >&2
	echo "See the package table in README.md to install the equivalents by hand." >&2
	exit 1
fi

SUDO=""
[[ "$(id -u)" -eq 0 ]] || SUDO="sudo"

# --- step 2: resolve the package set -----------------------------------------

if [[ "${#args[@]}" -gt 0 ]]; then
	packages=("${args[@]}")
else
	packages=()
	for d in */; do
		d=${d%/}
		is_non_package "$d" && continue
		packages+=("$d")
	done
fi

wanted=("${PKGS[base]}")
for pkg in "${packages[@]}"; do
	if [[ -z "${PKGS[$pkg]+set}" ]]; then
		echo "note: no Fedora packages known for '$pkg'" >&2
		continue
	fi
	wanted+=("${PKGS[$pkg]}")
done

# Deduplicate, then keep only what is not already installed. The splitting here
# is deliberate: each array entry is a space-separated list of package names.
# shellcheck disable=SC2048,SC2086
mapfile -t wanted < <(printf '%s\n' ${wanted[*]} | sort -u)
missing=()
for p in "${wanted[@]}"; do
	rpm -q --quiet "$p" || missing+=("$p")
done

say "Packages"
if [[ "${#missing[@]}" -eq 0 ]]; then
	skip "all ${#wanted[@]} packages already installed"
else
	printf '   missing (%d): %s\n' "${#missing[@]}" "${missing[*]}"
fi

# --- step 3: COPRs, only for missing packages that need them -----------------

say "COPRs"
enabled_coprs=$(dnf copr list 2>/dev/null | grep -v '(disabled)$' || true)
copr_needed=0
for copr in "${!COPRS[@]}"; do
	need=0
	for provided in ${COPRS[$copr]}; do
		for m in "${missing[@]}"; do
			[[ "$m" == "$provided" ]] && need=1
		done
	done
	[[ "$need" -eq 1 ]] || continue
	copr_needed=1
	if grep -qx "copr.fedorainfracloud.org/$copr" <<<"$enabled_coprs"; then
		skip "$copr already enabled"
	else
		# Fedora ships no Hyprland at all, and solopasha's COPR is stuck at
		# 0.51 -- too old for the Lua config parser, which needs >= 0.55.
		run $SUDO dnf copr enable -y "$copr"
	fi
done
[[ "$copr_needed" -eq 1 ]] || skip "none needed"

# --- step 4: install ---------------------------------------------------------

if [[ "${#missing[@]}" -gt 0 ]]; then
	say "Installing"
	run $SUDO dnf install -y "${missing[@]}"
fi

# --- step 5: wallust (not packaged anywhere) ---------------------------------

say "wallust"
if command -v wallust >/dev/null 2>&1 || [[ -x "$HOME/.cargo/bin/wallust" ]]; then
	skip "already installed"
else
	run cargo install wallust
	echo "   note: wallust lands in ~/.cargo/bin; make sure that is on PATH"
	echo "   (the zsh package adds it, but not until a new shell starts)"
fi

# --- step 6: shell plugins ---------------------------------------------------

say "Shell plugins"
for entry in "${CLONES[@]}"; do
	IFS='|' read -r dest repo depth <<<"$entry"
	if [[ -d "$dest" ]]; then
		skip "${dest/#$HOME/\~}"
	else
		run git clone --depth "$depth" "$repo" "$dest"
	fi
done

# --- step 7: seed the generated color files ----------------------------------

# kitty.conf, rofi/theme.rasi, waybar/*/style.css and swaync/style.css all
# hard-include a wallust-generated file, so those four apps fail to start until
# wallust has run at least once. Applying a builtin theme renders every template
# without needing a wallpaper.
say "Theme seed"
wallust_bin=$(command -v wallust || echo "$HOME/.cargo/bin/wallust")
if [[ ! -r "$HOME/.config/wallust/wallust.toml" ]]; then
	skip "wallust config not stowed yet -- run ./install.sh, then re-run this"
elif [[ ! -x "$wallust_bin" ]]; then
	skip "wallust not available yet (dry run?)"
elif [[ -r "$HOME/.cache/wallust/current.json" ]]; then
	skip "colors already generated"
else
	run "$wallust_bin" theme "$SEED_THEME"
fi

# --- done --------------------------------------------------------------------

cat <<'EOF'

== Done

Still to do by hand:
  - ./install.sh                      if you have not stowed the configs yet
  - chsh -s "$(command -v zsh)"       make zsh the login shell
  - prefix + I inside tmux            install tmux plugins via TPM
  - log out and pick the Hyprland or Sway session

Not installable from any repo -- supply these yourself, the configs no-op
without them: herdr, waybar-pomodoro, wifi-manager, appearance-rofi.
Left out on purpose: Obsidian (flatpak), Brave / Zen / VS Code / NordVPN
(vendor repos). See README.md.
EOF
