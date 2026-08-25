# system/

Files that cannot live in `$HOME` and are therefore **not** stowed. Install them
by hand; `install.sh` skips this directory.

```sh
sudo install -Dm755 system/bin/hyprland-session /usr/local/bin/hyprland-session
sudo install -Dm644 system/wayland-sessions/hyprland.desktop \
    /usr/local/share/wayland-sessions/hyprland.desktop
```

Removing both files is a complete uninstall — SDDM falls straight back to the
packaged session entry.

## What this fixes

A black internal panel after logging into Hyprland from a cold boot, which
"goes away" if an external monitor is plugged in.

SDDM opens the user session *before* logind removes the greeter session: on this
machine the greeter is torn down roughly 0.8s too late, on every boot. Hyprland
reaches its DRM setup inside that window about half the time, and aquamarine's
`take_device` on the GPU the greeter still holds fails:

```
[libseat] Could not take device: Device or resource busy
libseat: Couldn't open device at /dev/dri/card1
drm: Skipping device .../card1, not a KMS device
drm: Found 1 GPUs
```

Hyprland then comes up on whichever GPU it *could* open. On a hybrid laptop that
is the discrete card, whose only connector is the external one — so the session
is alive and healthy, painting to a display that isn't plugged in, while the
built-in panel stays black. Connecting an external monitor appears to fix it
only because it gives that GPU somewhere to draw; nothing about the monitor
config was ever wrong, and Hyprland never even saw the GPU driving the panel.

`bin/hyprland-session` closes the window by waiting for the greeter session to
disappear from logind before exec'ing `/usr/bin/start-hyprland`.

## Files

| File | Installed to | Notes |
|------|--------------|-------|
| `bin/hyprland-session` | `/usr/local/bin/` | Wrapper; must be outside `$HOME` because the `.desktop` `Exec` cannot expand `$HOME` (see below) |
| `wayland-sessions/hyprland.desktop` | `/usr/local/share/wayland-sessions/` | Shadows the packaged entry; `SessionDir` searches `/usr/local` first |

The `Exec=` line has to be one whitespace-free token. SDDM passes it to
`/etc/sddm/wayland-session`, which ends in an unquoted `exec $@`: any quoting is
destroyed by word splitting and never re-interpreted, so an
`Exec=/bin/sh -c '…$HOME…'` form silently breaks the login instead of fixing it.
