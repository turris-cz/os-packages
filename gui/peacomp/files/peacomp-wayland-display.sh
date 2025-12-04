[ -n "$USER" ] || USER=root
export XDG_RUNTIME_DIR="/run/$USER"
mkdir -p "$XDG_RUNTIME_DIR"
chown "$USER" "$XDG_RUNTIME_DIR"
[ -n "${WAYLAND_DISPLAY}" ] || export WAYLAND_DISPLAY="$XDG_RUNTIME_DIR/wayland-1"

