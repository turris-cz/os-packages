#!/bin/sh

# Generic functions used by board specific ones

predie() {
        ret_code="$1"
        shift
        if [ -f /tmp/debug.txt ]; then
            echo "Debug info:"
            cat /tmp/debug.txt
        fi
        case "$ret_code" in
            1) echo "Network error" ;;
            2) echo "No valid medkit found" ;;
            *) echo "Other error" ;;
        esac
        echo "$1"
        setsid cttyhack sh &
}

generic_pre_init() {
    :
}

board_pre_init() {
    :
}

board_init() {
    :
}

success() {
    echo "Everything done!"
    grep -v 'dont_reboot' /proc/cmdline > /dev/null || sleep 99999
}

generic_post_init() {
    # Use contract medkits for contracted boards
    local contract="$(fw_printenv contract | sed -n 's|^contract=turris_lists=contracts/||p')"
    if [ -n "$contract" ]; then
        MDKT_VARIANT="-contract-$contract"
    fi
}

