#!/usr/bin/env bash
set -euo pipefail

mapfile -t monitors < <(
    /usr/bin/env mmsg get all-monitors |
        /usr/bin/env jq -r '.monitors[].name'
)

has_headless=false

for monitor in "${monitors[@]}"; do
    if [[ "$monitor" == *HEADLESS* ]]; then
        has_headless=true
        break
    fi
done

if $has_headless; then
    # Physical monitors mode
    /usr/bin/env mmsg dispatch destroy_all_virtual_output

    for monitor in "${monitors[@]}"; do
        if [[ "$monitor" != *HEADLESS* ]]; then
            /usr/bin/env mmsg dispatch "enable_monitor,name:${monitor}"
        fi
    done
else
    # Headless/virtual output mode
    /usr/bin/env mmsg dispatch create_virtual_output

    for monitor in "${monitors[@]}"; do
        if [[ "$monitor" != *HEADLESS* ]]; then
            /usr/bin/env mmsg dispatch "disable_monitor,name:${monitor}"
        fi
    done
fi
