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

# Directories that are not stow packages.
NON_PACKAGES=(.git .claude)

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
	echo "error: GNU Stow is not installed (try: sudo dnf install stow)." >&2
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
