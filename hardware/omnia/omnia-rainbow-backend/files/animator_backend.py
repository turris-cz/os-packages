import os


class Backend:
    """Handler for all leds we can control."""

    # All available leds in order on the box
    LEDS = ["power", "lan-0", "lan-1", "lan-2", "lan-3", "lan-4", "wan", "wlan-1", "wlan-2", "wlan-3", "indicator-1", "indicator-2"]

    def __init__(self):
        self._fds = tuple(os.open(f"/sys/class/leds/rgb:{led}/color", os.O_WRONLY) for led in self.LEDS)

    def update(self, ledid: int, red: int, green: int, blue: int) -> None:
        """Update color of led on given index."""
        os.write(self._fds[ledid], f"{red} {green} {blue}".encode())

    def apply(self) -> None:
        """Apply previous LEDs state updates if that is required."""
        # We apply immediatelly so we do not need this.

    @staticmethod
    def handled(ledid: int) -> bool:
        """Informs animator if given led animation should be handled by it."""
        return True  # On Omnia all leds could be animated using animator
