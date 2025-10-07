export XDG_RUNTIME_DIR="/run/$USER"
[[ "${WAYLAND_DISPLAY}" = "" ]] && export WAYLAND_DISPLAY="$XDG_RUNTIME_DIR/wayland-1"

